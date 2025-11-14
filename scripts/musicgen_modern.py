#!/usr/bin/env python
"""
Generate a modernized instrumental using MusicGen's melody model, guided by an
existing reference stem mix. By default it reads the reference from
`outputs/<track>/melody_reference.wav` and writes the result to
`outputs/musicgen/<track>_modern_instrumental.wav`.

Requirements:
- Run inside a Python 3.10 virtual environment with audiocraft installed, e.g.:
    python -m pip install --no-cache-dir git+https://github.com/facebookresearch/audiocraft@v1.2.0
- Ensure the reference file exists (default: melody_reference.wav within the outputs/<track> folder).
"""

import os
from pathlib import Path

os.environ.setdefault("TORCHAUDIO_USE_TORCHCODEC", "0")

import torch
import torchaudio
from audiocraft.data.audio import audio_write
from audiocraft.models import MusicGen


PROJECT_ROOT = Path(__file__).resolve().parents[1]

INPUT_DIR_ENV = os.environ.get("MUSICGEN_INPUT_DIR", "poor_man_rose")
INPUT_DIR = Path(INPUT_DIR_ENV)
if not INPUT_DIR.is_absolute():
	INPUT_DIR = PROJECT_ROOT / INPUT_DIR

REFERENCE_FILENAME = os.environ.get("MUSICGEN_REFERENCE", "melody_reference.wav")
OUTPUT_FILENAME = os.environ.get("MUSICGEN_OUTPUT", "modern_instrumental.wav")
OUTPUT_DIR_ENV = os.environ.get("MUSICGEN_OUTPUT_DIR")

REFERENCE_PATH = INPUT_DIR / REFERENCE_FILENAME
if OUTPUT_DIR_ENV:
	OUTPUT_DIR = Path(OUTPUT_DIR_ENV)
	if not OUTPUT_DIR.is_absolute():
		OUTPUT_DIR = PROJECT_ROOT / OUTPUT_DIR
else:
	OUTPUT_DIR = PROJECT_ROOT / "outputs" / "musicgen"

OUTPUT_PATH = OUTPUT_DIR / OUTPUT_FILENAME

# Adjust the prompt to taste; add stylistic cues you want MusicGen to follow.
PROMPT = os.environ.get(
	"MUSICGEN_PROMPT",
	"modern pop electronic production with tight punchy drums, warm sub bass, "
	"shimmering synths, lush ambient pads, uplifting energy, ready for female lead vocals",
)

# Target duration in seconds. Match the original song length for best results.
TARGET_DURATION_ENV = os.environ.get("MUSICGEN_DURATION")
TARGET_DURATION = float(TARGET_DURATION_ENV) if TARGET_DURATION_ENV is not None else None
DEVICE_PREF = os.environ.get("MUSICGEN_DEVICE", "auto").lower()


def resolve_device() -> str:
	if DEVICE_PREF == "cpu":
		return "cpu"

	def _try_cuda(explicit: bool) -> str:
		try:
			if not torch.cuda.is_available():
				raise RuntimeError("CUDA not available")
			# Attempt a trivial CUDA op to ensure kernels exist for this GPU.
			torch.zeros(1, device="cuda")
			return "cuda"
		except Exception as err:
			message = (
				"[musicgen] CUDA requested but not usable; falling back to CPU."
				if not explicit
				else "[musicgen] CUDA explicitly requested but unusable."
			)
			print(f"{message} ({err})")
			if explicit:
				raise
			return "cpu"

	if DEVICE_PREF == "cuda":
		return _try_cuda(explicit=True)

	# auto mode
	return _try_cuda(explicit=False)


def load_reference(device: str, sample_rate: int) -> torch.Tensor:
	if not REFERENCE_PATH.exists():
		raise FileNotFoundError(
			f"Reference audio missing: {REFERENCE_PATH}\n"
			"Generate it first (e.g., mix drums/bass/other stems into melody_reference.wav)."
		)

	melody, sr = torchaudio.load(REFERENCE_PATH)
	if sr != sample_rate:
		melody = torchaudio.functional.resample(melody, sr, sample_rate)

	# MusicGen expects shape (batch, channels, time)
	return melody.unsqueeze(0).to(device)


def main() -> None:
	device = resolve_device()
	print(f"[musicgen] Using device: {device}")
	model = MusicGen.get_pretrained("facebook/musicgen-melody", device=device)
	melody = load_reference(device, model.sample_rate)
	target_duration = TARGET_DURATION
	if target_duration is None:
		target_duration = melody.shape[-1] / model.sample_rate

	model.set_generation_params(
		duration=target_duration,
		top_k=250,
		top_p=0.0,
		temperature=1.2,
		cfg_coef=4.0,
	)

	wav = model.generate_with_chroma(
		descriptions=[PROMPT],
		melody_wavs=[melody.squeeze(0)],
		melody_sample_rate=model.sample_rate,
	)[0].cpu()

	if wav.dim() == 1:
		wav = wav.unsqueeze(0)
	if wav.shape[0] == 1:
		wav = wav.repeat(2, 1)

	OUTPUT_PATH.parent.mkdir(parents=True, exist_ok=True)
	audio_write(
		OUTPUT_PATH,
		wav,
		model.sample_rate,
		strategy="loudness",
		add_suffix=False,
	)

	print(f"[musicgen] Saved modern instrumental to {OUTPUT_PATH}")


if __name__ == "__main__":
	main()

