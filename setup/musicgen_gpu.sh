#!/usr/bin/env bash
set -euo pipefail

# --- Configuration ---
PROJECT_ROOT="/mnt/c/projects/SoundCloud"
cd "$PROJECT_ROOT"

LOG_DIR="${PROJECT_ROOT}/logs"
mkdir -p "$LOG_DIR"
TIMESTAMP="$(date +"%Y%m%d-%H%M%S")"
LOG_PATH="${LOG_DIR}/musicgen_gpu_setup_${TIMESTAMP}.log"

# Redirect all output to log file and terminal
exec > >(tee -a "$LOG_PATH") 2>&1

# Use Python 3.10 as specified in the original script
VENV_PATH=".venv_musicgen_gpu"
PYTHON_BIN="${PYTHON_BIN:-python3.10}"

# RTX 5080 (Blackwell) requires CUDA 12.8+
# PyTorch wheels for CUDA 12.8
TORCH_INDEX_URL="${TORCH_INDEX_URL:-https://download.pytorch.org/whl/cu128}"

# --- Environment Setup ---

if [[ ! -d "$VENV_PATH" ]]; then
	echo "Creating GPU MusicGen virtual environment at ${PROJECT_ROOT}/${VENV_PATH} using ${PYTHON_BIN}..."
	"${PYTHON_BIN}" -m venv "$VENV_PATH"
fi

source "${VENV_PATH}/bin/activate"

echo "Upgrading pip/setuptools/wheel..."
python -m pip install --upgrade pip setuptools wheel

# --- Dependency Installation (RTX 5080 Optimized) ---

# Pinning numpy is often required for specific PyTorch/Audiocraft compatibility
echo "Pinning numpy 1.26.4 for Torch/Audiocraft compatibility..."
python -m pip install --no-cache-dir --force-reinstall "numpy==1.26.4"

# PyTorch 2.9.0 is the best practice stable version with full sm_120 (RTX 5080) support on CUDA 12.8
echo "Installing CUDA-enabled torch/torchaudio 2.9.0 (CUDA 12.8) for RTX 5080 (sm_120)..."
python -m pip install \
	--no-cache-dir \
	torch==2.9.0 \
	torchvision==0.24.0 \
	torchaudio==2.9.0 \
	--index-url "${TORCH_INDEX_URL}"

# Re-pinning numpy (Torch installation may bump it to a newer version)
echo "Re-pinning numpy 1.26.4 (Torch may bump it)..."
python -m pip install --no-cache-dir --force-reinstall "numpy==1.26.4"

# Install xFormers (required for memory efficiency, compatible with CUDA 12.8)
echo "Installing xFormers (CUDA 12.8 wheel)..."
python -m pip install --no-cache-dir xformers==0.0.33 --extra-index-url "${TORCH_INDEX_URL}"

# ==============================================================================================
# 🌟 CRITICAL FIX: Install audiocraft with --no-deps to prevent PyTorch downgrade back to 2.1.0
# ==============================================================================================
echo "Installing audiocraft (MusicGen) from GitHub, skipping dependency checks (--no-deps)..."
python -m pip install --no-cache-dir --no-deps git+https://github.com/facebookresearch/audiocraft@main

# Pinning transformers is a common practice to avoid issues with older HuggingFace models
echo "Pinning transformers..."
python -m pip install --no-cache-dir transformers==4.38.2

echo "Installation complete."