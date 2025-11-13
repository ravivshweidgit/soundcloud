#!/usr/bin/env bash
set -euo pipefail

PROJECT_ROOT="/mnt/c/projects/SoundCloud"
cd "$PROJECT_ROOT"

LOG_DIR="${PROJECT_ROOT}/logs"
mkdir -p "$LOG_DIR"
TIMESTAMP="$(date +"%Y%m%d-%H%M%S")"
LOG_PATH="${LOG_DIR}/musicgen_gpu_setup_${TIMESTAMP}.log"

exec > >(tee -a "$LOG_PATH") 2>&1

VENV_PATH=".venv_musicgen_gpu"
PYTHON_BIN="${PYTHON_BIN:-python3.10}"
TORCH_INDEX_URL="${TORCH_INDEX_URL:-https://download.pytorch.org/whl/cu128}"

if [[ ! -d "$VENV_PATH" ]]; then
	echo "Creating GPU MusicGen virtual environment at ${PROJECT_ROOT}/${VENV_PATH} using ${PYTHON_BIN}..."
	"${PYTHON_BIN}" -m venv "$VENV_PATH"
fi

source "${VENV_PATH}/bin/activate"

echo "Upgrading pip/setuptools/wheel..."
python -m pip install --upgrade pip setuptools wheel

echo "Pinning numpy 1.26.4 for Torch/Audiocraft compatibility..."
python -m pip install --no-cache-dir --force-reinstall "numpy==1.26.4"

echo "Installing CUDA-enabled torch/torchaudio 2.7.0 (CUDA 12.8)..."
python -m pip install --no-cache-dir torch==2.7.0 torchvision==0.22.0 torchaudio==2.7.0 --index-url "${TORCH_INDEX_URL}"

echo "Re-pinning numpy 1.26.4 (Torch may bump it)..."
python -m pip install --no-cache-dir --force-reinstall "numpy==1.26.4"

echo "Installing xFormers (CUDA 12.8 wheel)..."
python -m pip install --no-cache-dir xformers==0.0.33 --extra-index-url "${TORCH_INDEX_URL}"

echo "Installing audiocraft (MusicGen) from GitHub..."
python -m pip install --no-cache-dir git+https://github.com/facebookresearch/audiocraft@main

echo "Pinning transformers 4.37.2 for Torch compatibility..."
python -m pip install --no-cache-dir --force-reinstall "transformers==4.37.2"

echo "Ensuring NumPy stays below 2.0 for CUDA wheels..."
python -m pip install --no-cache-dir --force-reinstall "numpy==1.26.4"

echo
echo "Setup log saved to ${LOG_PATH}"
echo "GPU MusicGen environment ready. Activate with:"
echo "  source ${PROJECT_ROOT}/${VENV_PATH}/bin/activate"

