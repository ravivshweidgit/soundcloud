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

REFERENCE_PATH = INPUT_DIR / REFERENCE_FILENAME
OUTPUT_PATH = PROJECT_ROOT / "outputs" / "musicgen" / OUTPUT_FILENAME

# Adjust the prompt to taste; add stylistic cues you want MusicGen to follow.
PROMPT = os.environ.get(
	"MUSICGEN_PROMPT",
	"modern pop electronic production with tight punchy drums, warm sub bass, "
	"shimmering synths, lush ambient pads, uplifting energy, ready for female lead vocals",
)

# Target duration in seconds. Match the original song length for best results.
TARGET_DURATION = float(os.environ.get("MUSICGEN_DURATION", "30.0"))


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
	device = "cuda" if torch.cuda.is_available() else "cpu"
	model = MusicGen.get_pretrained("facebook/musicgen-melody", device=device)
	model.set_generation_params(
		duration=TARGET_DURATION,
		top_k=250,
		top_p=0.0,
		temperature=1.2,
		cfg_coef=4.0,
	)

	melody = load_reference(device, model.sample_rate)
	wav = model.generate_with_chroma(
		descriptions=[PROMPT],
	melody_wavs=[melody.squeeze(0)],
		melody_sample_rate=model.sample_rate,
	)[0].cpu()

	OUTPUT_PATH.parent.mkdir(parents=True, exist_ok=True)
	audio_write(
		OUTPUT_PATH.with_suffix(""),
		wav,
		model.sample_rate,
		strategy="loudness",
		add_suffix=False,
	)

	print(f"[musicgen] Saved modern instrumental to {OUTPUT_PATH}")


if __name__ == "__main__":
	main()

