Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

# Resolve repo root (parent of this script's directory)
$repoRoot = Split-Path $PSScriptRoot -Parent
Push-Location $repoRoot
try {
	$venvPy = ".\.venv\Scripts\python.exe"
	if (-not (Test-Path $venvPy)) {
		Write-Error "Virtual environment not found at .\.venv. Run .\setup\setup.ps1 first."
		exit 1
	}

	$inputPath  = ".\poor_man_rose\Poor_man_rose.mp3"
	$outDir = ".\outputs\poor_man_rose"
	$logDir = ".\logs"
	New-Item -ItemType Directory -Force -Path $logDir | Out-Null
	$stamp  = Get-Date -Format "yyyyMMdd-HHmmss"
	$log    = Join-Path $logDir "process_$stamp.log"

	if (-not (Test-Path $inputPath)) {
		Write-Error "Input file not found: $inputPath"
		exit 1
	}

	New-Item -ItemType Directory -Force -Path $outDir | Out-Null
	Write-Host "Logging to: $log"
	# Prefer local ffmpeg7 if present for TorchCodec compatibility on Windows
	$ff7bin = ".\tools\ffmpeg7\bin"
	if (Test-Path $ff7bin) {
		$env:Path = (Resolve-Path $ff7bin).Path + ";" + $env:Path
	}
	# If torchcodec is installed, add its site-packages folder to PATH so dependent DLLs resolve
	$tcDir = ".\.venv\Lib\site-packages\torchcodec"
	if (Test-Path $tcDir) {
		$env:Path = (Resolve-Path $tcDir).Path + ";" + $env:Path
	}
	# Ensure UTF-8 console encoding to avoid Rich spinner Unicode errors
	$env:PYTHONIOENCODING = 'utf-8'
	# Best-effort: ask torchaudio to avoid torchcodec if possible (may be ignored)
	$env:TORCHAUDIO_USE_TORCHCODEC = '0'
	# Run the processor while allowing native stderr without aborting this script,
	# capture exit code, and ensure all output goes to the log.
	$prevEAP = $ErrorActionPreference
	try {
		$ErrorActionPreference = 'Continue'
		& $venvPy "scripts\process_track.py" --input $inputPath --output-dir $outDir 2>&1 | Tee-Object -FilePath $log
		$exitCode = $LASTEXITCODE
	} finally {
		$ErrorActionPreference = $prevEAP
	}
	if ($exitCode -ne 0) {
		Write-Error "Processor exited with code $exitCode. See log: $log"
		exit $exitCode
	} else {
		Write-Host "Processor completed successfully. See log: $log"
	}
} finally {
	Pop-Location
}


