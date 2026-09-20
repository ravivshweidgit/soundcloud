import os
import sys
import math
import shutil
import subprocess
from pathlib import Path
from typing import Optional, Tuple

import click
from rich import print as rprint
from rich.console import Console
from rich.progress import Progress, SpinnerColumn, TextColumn

import numpy as np
from pydub import AudioSegment
import ffmpeg


console = Console()


def ensure_dir(path: Path) -> None:
	"""Create a directory if it does not exist."""
	path.mkdir(parents=True, exist_ok=True)


def check_ffmpeg_available() -> bool:
	try:
		subprocess.run(["ffmpeg", "-version"], capture_output=True, check=True)
		return True
	except Exception:
		return False


def db_to_ratio(db: float) -> float:
	return 10 ** (db / 20.0)


def run_demucs(input_path: Path, separated_root: Path) -> Path:
	"""
	Run Demucs to separate stems. Returns the path to the final stems directory
	containing vocals.wav, drums.wav, bass.wav, other.wav
	"""
	ensure_dir(separated_root)

	# Clear previous separation outputs to avoid mixing stale stems
	for existing in separated_root.iterdir():
		if existing.is_dir():
			shutil.rmtree(existing)
		else:
			existing.unlink()
	model = "htdemucs"
	cmd = [
		sys.executable,
		"-m",
		"demucs",
		"-n",
		model,
		"-o",
		str(separated_root),
		str(input_path),
	]
	rprint(f"[cyan]Running Demucs separation with model '{model}'...[/cyan]")
	# Prepare environment to avoid TorchCodec path on Windows and prefer local ffmpeg7 if present
	env = os.environ.copy()
	# Force torchaudio to avoid TorchCodec DLL usage and rely on soundfile backend
	env["TORCHAUDIO_USE_TORCHCODEC"] = "0"
	env["TORCHAUDIO_AUDIO_BACKEND"] = "soundfile"
	# Prepend tools\ffmpeg7\bin if available (relative to current working directory)
	try:
		ff7_bin = Path("./tools/ffmpeg7/bin")
		if ff7_bin.exists():
			env["PATH"] = str(ff7_bin.resolve()) + os.pathsep + env.get("PATH", "")
	except Exception:
		pass
	subprocess.run(cmd, check=True, env=env)

	# Demucs output is: separated_root / model / track_basename
	model_dir = separated_root / model
	if not model_dir.exists():
		raise RuntimeError("Demucs output directory not found.")

	# Find most recent track directory
	candidates = [p for p in model_dir.iterdir() if p.is_dir()]
	if not candidates:
		raise RuntimeError("No Demucs stems directory found.")
	latest = max(candidates, key=lambda p: p.stat().st_mtime)

	# Flatten into separated_root (no nested model/track directories)
	for item in latest.iterdir():
		target_path = separated_root / item.name
		if target_path.exists():
			if target_path.is_dir():
				shutil.rmtree(target_path)
			else:
				target_path.unlink()
		shutil.move(str(item), target_path)

	# Remove intermediate directories created by Demucs
	shutil.rmtree(model_dir, ignore_errors=True)

	return separated_root


def load_audio_segment(path: Path, target_sr: int) -> AudioSegment:
	seg = AudioSegment.from_file(str(path))
	if seg.frame_rate != target_sr:
		seg = seg.set_frame_rate(target_sr)
	return seg


def trim_or_pad(seg: AudioSegment, target_ms: int) -> AudioSegment:
	if len(seg) == target_ms:
		return seg
	if len(seg) > target_ms:
		return seg[:target_ms]
	pad_ms = target_ms - len(seg)
	return seg + AudioSegment.silent(duration=pad_ms, frame_rate=seg.frame_rate)


def mix_stems(
	vocals: Optional[AudioSegment],
	drums: Optional[AudioSegment],
	bass: Optional[AudioSegment],
	other: Optional[AudioSegment],
	replace_vocals: Optional[AudioSegment],
	replace_instrumental: Optional[AudioSegment],
	gains_db: Tuple[float, float, float, float],
) -> AudioSegment:
	"""
	Mix stems using simple gain and overlay logic.
	gains_db order: (vocals, drums, bass, other)
	"""
	target_len = 0
	segments = [s for s in [vocals, drums, bass, other, replace_vocals, replace_instrumental] if s is not None]
	if not segments:
		raise ValueError("No audio segments to mix.")
	target_len = max(len(s) for s in segments)

	def safe(seg: Optional[AudioSegment]) -> AudioSegment:
		return trim_or_pad(seg, target_len) if seg is not None else AudioSegment.silent(duration=target_len)

	vocals_gain_db, drums_gain_db, bass_gain_db, other_gain_db = gains_db

	if replace_instrumental is not None:
		instrumental = safe(replace_instrumental)
	else:
		instrumental = AudioSegment.silent(duration=target_len)
		instrumental = instrumental.overlay(safe(drums) + drums_gain_db)
		instrumental = instrumental.overlay(safe(bass) + bass_gain_db)
		instrumental = instrumental.overlay(safe(other) + other_gain_db)

	if replace_vocals is not None:
		v = safe(replace_vocals) + vocals_gain_db
	else:
		v = safe(vocals) + vocals_gain_db if vocals is not None else AudioSegment.silent(duration=target_len)

	mix = instrumental.overlay(v)
	return mix


def apply_mastering_ffmpeg(input_wav: Path, output_wav: Path, target_lufs: float) -> None:
	"""
	Apply a simple mastering chain with ffmpeg filters:
	- highpass at 20 Hz
	- compression
	- loudness normalization to target LUFS
	- limiter to -1 dBTP
	"""
	limit_dbtp = -1.0  # desired true peak limit in dBTP
	limit_linear = db_to_ratio(limit_dbtp)
	filter_chain = (
		f"highpass=f=20,"
		f"acompressor=threshold=-18dB:ratio=3:attack=5:release=50:makeup=5,"
		f"loudnorm=I={target_lufs}:TP={limit_dbtp}:LRA=11,"
		f"alimiter=limit={limit_linear:.6f}"
	)
	try:
		(
			ffmpeg
			.input(str(input_wav))
			.output(str(output_wav), acodec="pcm_s16le", af=filter_chain, ac=2, ar="44100")
			.overwrite_output()
			.run(quiet=True, capture_stdout=True, capture_stderr=True)
		)
	except ffmpeg.Error as exc:
		stderr = exc.stderr.decode(errors="ignore") if exc.stderr else "No stderr captured."
		raise RuntimeError(f"FFmpeg mastering failed:\n{stderr}") from exc


@click.command()
@click.option("--input", "input_path", type=click.Path(exists=True, dir_okay=False, path_type=Path), required=True, help="Input audio file (WAV/MP3/FLAC/etc).")
@click.option("--output-dir", type=click.Path(file_okay=False, path_type=Path), default=Path("./outputs"), show_default=True, help="Output directory.")
@click.option("--replace-vocals", type=click.Path(exists=True, dir_okay=False, path_type=Path), default=None, help="Optional path to replacement vocals.")
@click.option("--replace-instrumental", type=click.Path(exists=True, dir_okay=False, path_type=Path), default=None, help="Optional path to replacement instrumental/backing.")
@click.option("--vocals-gain-db", type=float, default=0.0, show_default=True)
@click.option("--drums-gain-db", type=float, default=0.0, show_default=True)
@click.option("--bass-gain-db", type=float, default=0.0, show_default=True)
@click.option("--other-gain-db", type=float, default=0.0, show_default=True)
@click.option("--master-target-lufs", type=float, default=-10.0, show_default=True, help="Target integrated LUFS.")
@click.option("--sample-rate", type=int, default=44100, show_default=True, help="Output sample rate.")
def main(
	input_path: Path,
	output_dir: Path,
	replace_vocals: Optional[Path],
	replace_instrumental: Optional[Path],
	vocals_gain_db: float,
	drums_gain_db: float,
	bass_gain_db: float,
	other_gain_db: float,
	master_target_lufs: float,
	sample_rate: int,
):
	rprint("[bold]SoundCloud Track Processor[/bold] — local stems + modernize")
	if not check_ffmpeg_available():
		rprint("[red]FFmpeg not found on PATH. Please install FFmpeg and try again.[/red]")
		sys.exit(1)

	separated_root = output_dir / "separated"
	final_root = output_dir / "final"
	ensure_dir(separated_root)
	ensure_dir(final_root)

	with Progress(SpinnerColumn(), TextColumn("[progress.description]{task.description}")) as progress:
		t1 = progress.add_task("Separating stems with Demucs...", total=None)
		stems_dir = run_demucs(input_path, separated_root)
		progress.remove_task(t1)

		rprint(f"[green]Stems at:[/green] {stems_dir}")

		# Load stems
		get = lambda name: (stems_dir / f"{name}.wav")
		stem_paths = {
			"vocals": get("vocals"),
			"drums": get("drums"),
			"bass": get("bass"),
			"other": get("other"),
		}
		def optional_seg(p: Path) -> Optional[AudioSegment]:
			return load_audio_segment(p, sample_rate) if p.exists() else None

		vocals_seg = optional_seg(stem_paths["vocals"])
		drums_seg = optional_seg(stem_paths["drums"])
		bass_seg = optional_seg(stem_paths["bass"])
		other_seg = optional_seg(stem_paths["other"])

		replace_vocals_seg = load_audio_segment(replace_vocals, sample_rate) if replace_vocals else None
		replace_instrumental_seg = load_audio_segment(replace_instrumental, sample_rate) if replace_instrumental else None

		rprint("[cyan]Mixing stems...[/cyan]")
		mix = mix_stems(
			vocals=vocals_seg,
			drums=drums_seg,
			bass=bass_seg,
			other=other_seg,
			replace_vocals=replace_vocals_seg,
			replace_instrumental=replace_instrumental_seg,
			gains_db=(vocals_gain_db, drums_gain_db, bass_gain_db, other_gain_db),
		)

		# Export pre-master
		pre_master_wav = final_root / f"{input_path.stem}_premaster.wav"
		mix = mix.set_frame_rate(sample_rate).set_channels(2).set_sample_width(2)
		mix.export(str(pre_master_wav), format="wav")
		rprint(f"[green]Wrote premaster:[/green] {pre_master_wav}")

		# Master
		mastered_wav = final_root / f"{input_path.stem}_final_master.wav"
		rprint("[cyan]Applying mastering chain...[/cyan]")
		apply_mastering_ffmpeg(pre_master_wav, mastered_wav, master_target_lufs)
		rprint(f"[bold green]Done![/bold green] Final master: {mastered_wav}")


if __name__ == "__main__":
	main()

