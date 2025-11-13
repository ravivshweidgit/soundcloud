#!/usr/bin/env bash
set -euo pipefail

PROJECT_ROOT="/mnt/c/projects/SoundCloud"
cd "$PROJECT_ROOT"

VENV_PATH=".venv_musicgen_gpu"
PYTHON_BIN="${PYTHON_BIN:-python3.10}"
TORCH_INDEX_URL="${TORCH_INDEX_URL:-https://download.pytorch.org/whl/cu121}"

if [[ ! -d "$VENV_PATH" ]]; then
	echo "Creating GPU MusicGen virtual environment at ${PROJECT_ROOT}/${VENV_PATH} using ${PYTHON_BIN}..."
	"${PYTHON_BIN}" -m venv "$VENV_PATH"
fi

source "${VENV_PATH}/bin/activate"

echo "Upgrading pip/setuptools/wheel..."
python -m pip install --upgrade pip setuptools wheel

echo "Pinning numpy 1.26.4 for Torch/Audiocraft compatibility..."
python -m pip install --no-cache-dir --force-reinstall "numpy==1.26.4"

echo "Installing CUDA-enabled torch/torchaudio 2.2.2 (cu121)..."
python -m pip install --no-cache-dir torch==2.2.2+cu121 torchaudio==2.2.2+cu121 --index-url "${TORCH_INDEX_URL}"

echo "Re-pinning numpy 1.26.4 (Torch may bump it)..."
python -m pip install --no-cache-dir --force-reinstall "numpy==1.26.4"

echo "Installing audiocraft (MusicGen) from GitHub..."
python -m pip install --no-cache-dir git+https://github.com/facebookresearch/audiocraft@v1.2.0

echo "Pinning transformers 4.37.2 for Torch compatibility..."
python -m pip install --no-cache-dir --force-reinstall "transformers==4.37.2"

echo
echo "GPU MusicGen environment ready. Activate with:"
echo "  source ${PROJECT_ROOT}/${VENV_PATH}/bin/activate"

