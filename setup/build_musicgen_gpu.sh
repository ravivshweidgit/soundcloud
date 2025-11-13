#!/usr/bin/env bash
# Guided build of PyTorch/Torchaudio with CUDA sm_120 support for MusicGen.
# This script runs interactively and logs every step so issues can be diagnosed.

set -euo pipefail

PROJECT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
LOG_DIR="${PROJECT_ROOT}/logs"
TIMESTAMP="$(date +"%Y%m%d-%H%M%S")"
LOG_PATH="${LOG_DIR}/torch_build_${TIMESTAMP}.log"

BUILD_VENV="${PROJECT_ROOT}/.venv_musicgen_gpu_build"
MUSICGEN_VENV="${PROJECT_ROOT}/.venv_musicgen_gpu"

SRC_ROOT="${PROJECT_ROOT}/build/src"
PYTORCH_SRC="${SRC_ROOT}/pytorch"
TORCHAUDIO_SRC="${SRC_ROOT}/torchaudio"

TORCH_TAG="${TORCH_TAG:-v2.2.2}"
TORCHAUDIO_TAG="${TORCHAUDIO_TAG:-v2.2.2}"

ARCH_LIST="${TORCH_CUDA_ARCH_LIST:-5.0;6.0;7.0;7.5;8.0;8.6;9.0;12.0}"

mkdir -p "${LOG_DIR}"
mkdir -p "${SRC_ROOT}"

exec > >(tee -a "${LOG_PATH}") 2>&1

echo "============================================================"
echo " PyTorch + Torchaudio CUDA build (interactive guide)"
echo " Project root : ${PROJECT_ROOT}"
echo " Log file     : ${LOG_PATH}"
echo " Build venv   : ${BUILD_VENV}"
echo " Target venv  : ${MUSICGEN_VENV}"
echo " Torch tag    : ${TORCH_TAG}"
echo " Torchaudio   : ${TORCHAUDIO_TAG}"
echo " CUDA archs   : ${ARCH_LIST}"
echo "============================================================"
echo

pause() {
	read -rp "Press Enter to continue (Ctrl+C to abort)..." _
	echo
}

prompt_step() {
	local title="$1"
	shift
	while true; do
		read -rp "---- ${title} ---- [y=run / s=skip / q=quit]: " choice
		case "${choice:-y}" in
			y|Y)
				echo "Running..."
				"$@"
				echo
				return 0
				;;
			s|S)
				echo "Skipped: ${title}"
				echo
				return 1
				;;
			q|Q)
				echo "Aborting at user request."
				exit 1
				;;
			*)
				echo "Please enter y, s, or q."
				;;
		esac
	done
}

run_step() {
	local title="$1"
	shift
	prompt_step "${title}" "$@"
}

info_step() {
	local title="$1"
	read -rp "---- ${title} ---- [Enter=continue / q=quit]: " choice
	if [[ "${choice}" =~ ^[Qq]$ ]]; then
		echo "Aborting at user request."
		exit 1
	fi
	echo
}

if [[ ! -d "${MUSICGEN_VENV}" ]]; then
	echo "[WARN] MusicGen GPU venv not found at ${MUSICGEN_VENV}."
	echo "Run setup/musicgen_gpu.sh before this script."
fi

run_step "Install system dependencies (requires sudo)" \
	sudo apt update

run_step "Install build toolchain packages" \
	sudo apt install -y build-essential ninja-build cmake libopenblas-dev libblas-dev \
		libssl-dev libffi-dev python3-dev python3-pip python3-setuptools python3-wheel \
		curl git pkg-config

if [[ ! -d "${BUILD_VENV}" ]]; then
	run_step "Create build virtualenv (${BUILD_VENV})" \
		python3.10 -m venv "${BUILD_VENV}"
else
	echo "Build venv already exists at ${BUILD_VENV}"
fi

run_step "Activate build virtualenv" \
	source "${BUILD_VENV}/bin/activate"

run_step "Upgrade pip/setuptools/wheel in build venv" \
	pip install --upgrade pip setuptools wheel

if [[ ! -d "${PYTORCH_SRC}" ]]; then
	run_step "Clone PyTorch repository" \
		git clone --recursive https://github.com/pytorch/pytorch "${PYTORCH_SRC}"
else
	echo "PyTorch source already present at ${PYTORCH_SRC}"
fi

run_step "Checkout PyTorch tag ${TORCH_TAG}" \
	bash -c "cd '${PYTORCH_SRC}' && git fetch --all && git checkout ${TORCH_TAG} && git submodule sync && git submodule update --init --recursive"

run_step "Install PyTorch Python build dependencies" \
	bash -c "cd '${PYTORCH_SRC}' && pip install -r requirements.txt"

export TORCH_CUDA_ARCH_LIST="${ARCH_LIST}"
export CMAKE_PREFIX_PATH="$(python -c 'from sysconfig import get_paths as gp; print(gp()[\"platlib\"])')"

run_step "Build PyTorch wheel (this can take >1 hour)" \
	bash -c "cd '${PYTORCH_SRC}' && python setup.py bdist_wheel"

PYTORCH_WHEEL="$(ls "${PYTORCH_SRC}"/dist/torch-*.whl | tail -n1)"
echo "PyTorch wheel built: ${PYTORCH_WHEEL}"
echo

if [[ ! -d "${TORCHAUDIO_SRC}" ]]; then
	run_step "Clone torchaudio repository" \
		git clone https://github.com/pytorch/audio "${TORCHAUDIO_SRC}"
else
	echo "torchaudio source already present at ${TORCHAUDIO_SRC}"
fi

run_step "Checkout torchaudio tag ${TORCHAUDIO_TAG}" \
	bash -c "cd '${TORCHAUDIO_SRC}' && git fetch --all && git checkout ${TORCHAUDIO_TAG} && git submodule sync && git submodule update --init --recursive"

run_step "Install torchaudio Python build dependencies" \
	bash -c "cd '${TORCHAUDIO_SRC}' && pip install -r requirements.txt"

run_step "Build torchaudio wheel (also lengthy)" \
	bash -c "cd '${TORCHAUDIO_SRC}' && python setup.py bdist_wheel"

TORCHAUDIO_WHEEL="$(ls "${TORCHAUDIO_SRC}"/dist/torchaudio-*.whl | tail -n1)"
echo "torchaudio wheel built: ${TORCHAUDIO_WHEEL}"
echo

run_step "Deactivate build virtualenv" \
	deactivate

run_step "Activate MusicGen GPU virtualenv (${MUSICGEN_VENV})" \
	source "${MUSICGEN_VENV}/bin/activate"

run_step "Uninstall existing torch/torchaudio from MusicGen venv" \
	pip uninstall -y torch torchaudio || true

run_step "Install freshly built PyTorch wheel" \
	pip install --force-reinstall "${PYTORCH_WHEEL}"

run_step "Install freshly built torchaudio wheel" \
	pip install --force-reinstall "${TORCHAUDIO_WHEEL}"

run_step "Re-pin numpy 1.26.4 for compatibility" \
	pip install --force-reinstall "numpy==1.26.4"

info_step "Verify CUDA availability with new build"
python - <<'PY'
import torch
print("torch version:", torch.__version__)
print("CUDA available:", torch.cuda.is_available())
if torch.cuda.is_available():
    x = torch.zeros(1, device="cuda")
    print("Default CUDA device:", torch.cuda.get_device_name(0))
else:
    print("CUDA still unavailable. Check build logs.")
PY

run_step "Deactivate MusicGen virtualenv" \
	deactivate

echo "============================================================"
echo "Build steps completed. Review ${LOG_PATH} for the full log."
echo "You can now rerun ./process/musicgen.sh poor_man_rose to test GPU support."
echo "============================================================"

