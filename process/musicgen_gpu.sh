#!/usr/bin/env bash
set -euo pipefail

PROJECT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
VENV_PATH="${MUSICGEN_VENV_PATH:-${PROJECT_ROOT}/.venv_musicgen_gpu}"

if [[ ! -d "$VENV_PATH" ]]; then
	CPU_VENV="${PROJECT_ROOT}/.venv_musicgen"
	if [[ -d "$CPU_VENV" ]]; then
		echo "[WARN] GPU venv not found; falling back to CPU environment at ${CPU_VENV}." >&2
		VENV_PATH="$CPU_VENV"
	else
		echo "[ERROR] MusicGen GPU virtualenv not found. Run setup/musicgen_gpu.sh first (or set MUSICGEN_VENV_PATH)."
		exit 1
	fi
fi

TRACK_ID=""
CREATE_REFERENCE=true
CUSTOM_PROMPT=""
CUSTOM_DURATION=""

usage() {
	cat <<'EOF'
Usage: process/musicgen_gpu.sh <track_id> [options]

Options:
  <track_id>              Name of the track (expects inputs/<track_id>.mp3 & outputs/<track_id>/separated/)
  --skip-reference        Skip mixing stems into outputs/<track_id>/melody_reference.wav
  --prompt "TEXT"         Override MusicGen prompt
  --duration SECONDS      Override generation duration (float)
  -h, --help              Show this message

Environment overrides passed through to MusicGen:
  MUSICGEN_INPUT_DIR      Defaults to outputs/<track_id>
  MUSICGEN_REFERENCE      Defaults to melody_reference.wav
  MUSICGEN_OUTPUT         Defaults to <track_id>_modern_instrumental.wav (under outputs/<track_id>/musicgen)
  MUSICGEN_PROMPT         Defaults to script-defined modern pop prompt
  MUSICGEN_DURATION       Defaults to 30.0
  MUSICGEN_DEVICE         Defaults to cuda

Examples:
  process/musicgen_gpu.sh poor_man_rose
  process/musicgen_gpu.sh poor_man_rose --prompt "dark synthwave with heavy bass" --duration 45
  process/musicgen_gpu.sh demo_track --skip-reference
EOF
}

while [[ "$#" -gt 0 ]]; do
	case "$1" in
		--skip-reference)
			CREATE_REFERENCE=false
			shift
			;;
		--prompt)
			shift
			[[ "$#" -gt 0 ]] || { echo "Missing value for --prompt"; exit 1; }
			CUSTOM_PROMPT="$1"
			shift
			;;
		--duration)
			shift
			[[ "$#" -gt 0 ]] || { echo "Missing value for --duration"; exit 1; }
			CUSTOM_DURATION="$1"
			shift
			;;
		-h|--help)
			usage
			exit 0
			;;
		*)
			if [[ -z "$TRACK_ID" ]]; then
				TRACK_ID="$1"
				shift
			else
				echo "Unknown option: $1"
				usage
				exit 1
			fi
			;;
	esac
done

if [[ -z "$TRACK_ID" ]]; then
	echo "Track id (first argument) is required."
	usage
	exit 1
fi

INPUT_FILE="${PROJECT_ROOT}/inputs/${TRACK_ID}.mp3"
if [[ ! -f "$INPUT_FILE" ]]; then
	echo "Input file not found: ${INPUT_FILE}"
	echo "Place your audio at inputs/${TRACK_ID}.mp3 or use a different track id."
	exit 1
fi

TRACK_OUTPUT_DIR="${PROJECT_ROOT}/outputs/${TRACK_ID}"
SEPARATED_DIR="${TRACK_OUTPUT_DIR}/separated"
REFERENCE_PATH="${TRACK_OUTPUT_DIR}/melody_reference.wav"
OUTPUT_DIR="${TRACK_OUTPUT_DIR}/musicgen"
OUTPUT_FILENAME="${TRACK_ID}_modern_instrumental.wav"
OUTPUT_PATH="${OUTPUT_DIR}/${OUTPUT_FILENAME}"

mkdir -p "$OUTPUT_DIR"

if $CREATE_REFERENCE; then
	if [[ ! -d "$SEPARATED_DIR" ]]; then
		echo "Stem directory not found at ${SEPARATED_DIR}."
		echo "Ensure process_track.py has generated Demucs outputs first."
		exit 1
	fi
	if ! command -v ffmpeg >/dev/null 2>&1; then
		echo "ffmpeg not found on PATH. Install ffmpeg to build the reference mix."
		exit 1
	fi
	echo "Creating melody reference at ${REFERENCE_PATH} from stems..."
	mkdir -p "$(dirname "$REFERENCE_PATH")"
	ffmpeg -hide_banner -y \
		-i "${SEPARATED_DIR}/drums.wav" \
		-i "${SEPARATED_DIR}/bass.wav" \
		-i "${SEPARATED_DIR}/other.wav" \
		-filter_complex "amix=inputs=3:normalize=0" \
		"${REFERENCE_PATH}"
fi

if [[ ! -f "$REFERENCE_PATH" ]]; then
	echo "Reference file missing: ${REFERENCE_PATH}"
	echo "Either provide it or run without --skip-reference so the mix is created automatically."
	exit 1
fi

source "${VENV_PATH}/bin/activate"

export MUSICGEN_INPUT_DIR="$TRACK_OUTPUT_DIR"
export MUSICGEN_REFERENCE="$(basename "$REFERENCE_PATH")"
export MUSICGEN_OUTPUT_DIR="$OUTPUT_DIR"
export MUSICGEN_OUTPUT="$OUTPUT_FILENAME"
export MUSICGEN_DEVICE="${MUSICGEN_DEVICE:-cuda}"
# Disable TorchCodec so torchaudio falls back to libsox backends
export TORCHAUDIO_USE_TORCHCODEC=0

if [[ -n "$CUSTOM_PROMPT" ]]; then
	export MUSICGEN_PROMPT="$CUSTOM_PROMPT"
else
	unset MUSICGEN_PROMPT
fi

if [[ -n "$CUSTOM_DURATION" ]]; then
	export MUSICGEN_DURATION="$CUSTOM_DURATION"
else
	unset MUSICGEN_DURATION
fi

echo "Running MusicGen (GPU) for track ${TRACK_ID}"
python "${PROJECT_ROOT}/scripts/musicgen_modern.py"
echo "Modern instrumental written to ${OUTPUT_PATH}"

