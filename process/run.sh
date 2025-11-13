#!/usr/bin/env bash
set -euo pipefail

PROJECT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
VENV_PATH="${PROJECT_ROOT}/.venv310"
PYTHON_BIN="${PYTHON_BIN:-python3.10}"

usage() {
	cat <<'EOF'
Usage: process/run.sh <track_id> [--input-file PATH] [--output-dir PATH] [-- extra process_track.py args...]

Defaults:
  --input     inputs/<track_id>.mp3
  --output-dir  outputs/<track_id>

Examples:
  process/run.sh poor_man_rose
  process/run.sh poor_man_rose -- --master-target-lufs -12
  process/run.sh demo_song --input-file "/mnt/c/audio/demo_song.wav"

Environment variables:
  PYTHON_BIN  Override the Python 3.10 executable used to manage the venv (default: python3.10)
  DEMUCS_DEVICE  Demucs device override (default: cpu; set to cuda to try GPU)
EOF
	exit 1
}

if [[ "$#" -lt 1 ]]; then
	usage
fi

TRACK_ID=""
INPUT_FILE=""
OUTPUT_DIR=""
EXTRA_ARGS=()

while [[ "$#" -gt 0 ]]; do
	case "$1" in
		--input-file)
			shift
			[[ "$#" -gt 0 ]] || { echo "Missing value for --input-file"; exit 1; }
			INPUT_FILE="$1"
			shift
			;;
		--output-dir)
			shift
			[[ "$#" -gt 0 ]] || { echo "Missing value for --output-dir"; exit 1; }
			OUTPUT_DIR="$1"
			shift
			;;
		--)
			shift
			if [[ "$#" -gt 0 ]]; then
				EXTRA_ARGS+=("$@")
			fi
			break
			;;
		-*)
			echo "Unknown option: $1"
			usage
			;;
		*)
			if [[ -z "$TRACK_ID" ]]; then
				TRACK_ID="$1"
				shift
			else
				EXTRA_ARGS+=("$1")
				shift
			fi
			;;
	esac
done

if [[ -z "$TRACK_ID" ]]; then
	echo "Track id is required."
	usage
fi

if [[ -z "$INPUT_FILE" ]]; then
	INPUT_FILE="${PROJECT_ROOT}/inputs/${TRACK_ID}.mp3"
fi

if [[ ! -f "$INPUT_FILE" ]]; then
	echo "Input file not found: $INPUT_FILE"
	exit 1
fi

if [[ -z "$OUTPUT_DIR" ]]; then
	OUTPUT_DIR="${PROJECT_ROOT}/outputs/${TRACK_ID}"
fi

mkdir -p "$OUTPUT_DIR"

if [[ ! -d "$VENV_PATH" ]]; then
	echo "Creating virtual environment at ${VENV_PATH} using ${PYTHON_BIN}..."
	"${PYTHON_BIN}" -m venv "$VENV_PATH"
fi

source "${VENV_PATH}/bin/activate"

export TORCHAUDIO_USE_TORCHCODEC=0
export DEMUCS_DEVICE="${DEMUCS_DEVICE:-cpu}"

echo "Running process_track.py --input \"$INPUT_FILE\" --output-dir \"$OUTPUT_DIR\" ${EXTRA_ARGS[*]}"
python "${PROJECT_ROOT}/scripts/process_track.py" --input "$INPUT_FILE" --output-dir "$OUTPUT_DIR" "${EXTRA_ARGS[@]}"

