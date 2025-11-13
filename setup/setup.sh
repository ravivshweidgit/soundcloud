#!/usr/bin/env bash
set -euo pipefail

PROJECT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
LOG_DIR="${LOG_DIR:-logs}"
mkdir -p "${PROJECT_ROOT}/${LOG_DIR}"
LOG_PATH="${PROJECT_ROOT}/${LOG_DIR}/setup_$(date +"%Y%m%d-%H%M%S").log"

INFO()  { echo "[INFO]  $*"; }
WARN()  { echo "[WARN]  $*" >&2; }
ERROR() { echo "[ERROR] $*" >&2; }

INSTALL_FFMPEG=false
WARMUP_DEMUCS=false
PYTHON_BIN="${PYTHON_BIN:-python3.10}"

usage() {
	cat <<'EOF'
Usage: setup/setup.sh [options]

Options:
  --install-ffmpeg   Attempt to install FFmpeg via apt if missing.
  --warmup-demucs     Run a Demucs warmup pass to pre-download models.
  --python PATH       Override the python executable used to create the venv (default: python3.10).
  -h, --help          Show this help message.

Environment variables:
  PYTHON_BIN          Same as --python.
  LOG_DIR             Override logs directory (default: logs).

This script creates .venv310, installs requirements, and verifies Demucs.
EOF
}

while [[ $# -gt 0 ]]; do
	case "$1" in
		--install-ffmpeg)
			INSTALL_FFMPEG=true
			shift
			;;
		--warmup-demucs)
			WARMUP_DEMUCS=true
			shift
			;;
		--python)
			shift
			[[ $# -gt 0 ]] || { ERROR "Missing value for --python"; exit 1; }
			PYTHON_BIN="$1"
			shift
			;;
		-h|--help)
			usage
			exit 0
			;;
		*)
			ERROR "Unknown option: $1"
			usage
			exit 1
			;;
	esac
done

exec > >(tee -a "$LOG_PATH") 2>&1

INFO "SoundCloud project setup (Linux/WSL)"
INFO "Project root: ${PROJECT_ROOT}"
INFO "Log file    : ${LOG_PATH}"

command -v "$PYTHON_BIN" >/dev/null 2>&1 || {
	ERROR "Python interpreter '${PYTHON_BIN}' not found. Install Python 3.10 or set PYTHON_BIN."
	exit 1
}

PY_VERSION="$("$PYTHON_BIN" -c 'import sys; print(f"{sys.version_info.major}.{sys.version_info.minor}")')"
if ! "$PYTHON_BIN" -m ensurepip --version >/dev/null 2>&1; then
	if command -v apt >/dev/null 2>&1; then
		PY_VENV_PKG="python${PY_VERSION}-venv"
		INFO "Python '${PYTHON_BIN}' lacks ensurepip; installing ${PY_VENV_PKG} via apt."
		sudo apt update
		if ! sudo apt install -y "${PY_VENV_PKG}"; then
			ERROR "Failed to install ${PY_VENV_PKG}. Install it manually and re-run setup."
			exit 1
		fi
	else
		ERROR "Python '${PYTHON_BIN}' lacks ensurepip. Install the corresponding venv package (e.g. python${PY_VERSION}-venv)."
		exit 1
	fi
fi

VENV_PATH="${PROJECT_ROOT}/.venv310"
if [[ -d "$VENV_PATH" && ! -f "${VENV_PATH}/bin/activate" ]]; then
	INFO "Existing virtual environment at ${VENV_PATH} appears corrupted; recreating."
	rm -rf "$VENV_PATH"
fi

if [[ ! -d "$VENV_PATH" ]]; then
	INFO "Creating virtual environment at ${VENV_PATH}"
	"$PYTHON_BIN" -m venv "$VENV_PATH"
else
	INFO "Virtual environment already exists at ${VENV_PATH}"
fi

source "${VENV_PATH}/bin/activate"
trap 'deactivate >/dev/null 2>&1 || true' EXIT

INFO "Upgrading pip/setuptools/wheel"
python -m pip install --upgrade pip setuptools wheel

REQ_FILE="${PROJECT_ROOT}/requirements.txt"
if [[ ! -f "$REQ_FILE" ]]; then
	ERROR "requirements.txt not found at ${REQ_FILE}"
	exit 1
fi
INFO "Installing project requirements"
python -m pip install --no-cache-dir -r "$REQ_FILE"

if ! command -v ffmpeg >/dev/null 2>&1; then
	if $INSTALL_FFMPEG; then
		if command -v apt >/dev/null 2>&1; then
			INFO "FFmpeg not found; installing via apt"
			sudo apt update
			sudo apt install -y ffmpeg
		else
			WARN "FFmpeg missing and apt unavailable. Install FFmpeg manually."
		fi
	else
		WARN "FFmpeg not found. Install it manually via 'sudo apt install ffmpeg' or re-run with --install-ffmpeg."
	fi
fi

if ! command -v ffmpeg >/dev/null 2>&1; then
	WARN "FFmpeg still not detected; the mastering step will fail until it is installed."
else
	INFO "FFmpeg detected: $(ffmpeg -version | head -n 1)"
fi

INFO "Verifying Demucs import"
python -c "import demucs; print('Demucs OK')" || {
	ERROR "Demucs import failed. Check requirements installation."
	exit 1
}

if $WARMUP_DEMUCS; then
	if ! command -v ffmpeg >/dev/null 2>&1; then
		WARN "Skipping Demucs warmup because FFmpeg is unavailable."
	else
		INFO "Warming up Demucs (downloading models)..."
		tmp_in="$(mktemp --suffix=.wav)"
		tmp_out="$(mktemp -d)"
		ffmpeg -f lavfi -i anullsrc=channel_layout=stereo:sample_rate=44100 -t 1 -acodec pcm_s16le "$tmp_in" -y >/dev/null 2>&1
		python -m demucs -n htdemucs -o "$tmp_out" "$tmp_in" || WARN "Demucs warmup encountered an issue (non-fatal)."
		rm -f "$tmp_in"
		rm -rf "$tmp_out"
	fi
fi

INFO "Setup complete. Activate the environment with: source .venv310/bin/activate"

