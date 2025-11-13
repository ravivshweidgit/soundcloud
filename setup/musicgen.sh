#!/usr/bin/env bash
set -euo pipefail

PROJECT_ROOT="/mnt/c/projects/SoundCloud"
cd "$PROJECT_ROOT"

VENV_PATH=".venv_musicgen"
PYTHON_BIN="${PYTHON_BIN:-python3.10}"

if [[ ! -d "$VENV_PATH" ]]; then
	echo "Creating virtual environment at ${PROJECT_ROOT}/${VENV_PATH} using ${PYTHON_BIN}..."
	"${PYTHON_BIN}" -m venv "$VENV_PATH"
fi

source "${VENV_PATH}/bin/activate"

echo "Upgrading pip/setuptools/wheel..."
python -m pip install --upgrade pip setuptools wheel

echo "Pinning numpy 1.26.4 for Torch/Audiocraft compatibility..."
python -m pip install --no-cache-dir --force-reinstall "numpy==1.26.4"

echo "Installing torch/torchaudio 2.2.2 (CPU build)..."
python -m pip install --no-cache-dir torch==2.2.2 torchaudio==2.2.2

# Torch wheels may pull a newer NumPy; re-pin to ensure 1.26.4 stays active
python -m pip install --no-cache-dir --force-reinstall "numpy==1.26.4"

echo "Installing audiocraft (MusicGen) from GitHub..."
python -m pip install --no-cache-dir git+https://github.com/facebookresearch/audiocraft@v1.2.0

echo "Pinning transformers 4.37.2 for Torch compatibility..."
python -m pip install --no-cache-dir --force-reinstall "transformers==4.37.2"

echo
echo "MusicGen environment ready. Activate with:"
echo "  source ${PROJECT_ROOT}/${VENV_PATH}/bin/activate"

