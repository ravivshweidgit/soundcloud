param(
	[switch]$InstallPython,
	[switch]$InstallFFmpeg,
	[switch]$WarmupDemucs,
	[switch]$NoPrompt,
	[string]$FFmpeg7Url,
	[switch]$FFmpeg7PersistPath,
	[string]$LogDir = ".\logs",
	[string]$LogName
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

function Test-Cmd($name) {
	try {
		Get-Command $name -ErrorAction Stop | Out-Null
		return $true
	} catch {
		return $false
	}
}

function New-LogPath {
	param([string]$Dir, [string]$Name)
	if (-not (Test-Path $Dir)) { New-Item -ItemType Directory -Force -Path $Dir | Out-Null }
	if ([string]::IsNullOrWhiteSpace($Name)) {
		$stamp = Get-Date -Format "yyyyMMdd-HHmmss"
		return Join-Path $Dir "setup_$stamp.log"
	}
	return Join-Path $Dir $Name
}

function Write-Log {
	param([string]$Message, [ValidateSet('INFO','WARN','ERROR')] [string]$Level = 'INFO')
	$line = "[{0}] {1}  {2}" -f $Level, (Get-Date -Format "HH:mm:ss"), $Message
	switch ($Level) {
		'INFO' { Write-Host $line }
		'WARN' { Write-Warning $Message }
		'ERROR' { Write-Error $Message }
	}
	Add-Content -Path $script:LogPath -Value $line
}

# Resolve repo root (parent of this 'setup' directory)
$repoRoot = Split-Path $PSScriptRoot -Parent
Push-Location $repoRoot

try {
	$script:LogPath = New-LogPath -Dir $LogDir -Name $LogName
	Write-Host ""
	Write-Host "==============================================="
	Write-Host " SoundCloud Project Setup"
	Write-Host " Repo: $repoRoot"
	Write-Host " Log : $LogPath"
	Write-Host "==============================================="
	Write-Host ""

	Write-Log "Starting setup" 'INFO'

	# 1) Python check (py or python)
	$hasPy = Test-Cmd 'py'
	$hasPython = Test-Cmd 'python'
	if (-not $hasPy -and -not $hasPython) {
		Write-Log "Python not found on PATH." 'WARN'
		if ($InstallPython -and (Test-Cmd 'winget')) {
			Write-Log "Installing Python via winget..." 'INFO'
			winget install -e --id Python.Python.3.12 --silent --accept-package-agreements --accept-source-agreements | Out-Null
			$hasPy = Test-Cmd 'py'
			$hasPython = Test-Cmd 'python'
		}
	}
	if (-not $hasPy -and -not $hasPython) {
		throw "Python not found. Install Python 3.10+ or re-run with -InstallPython (requires winget)."
	}

	# 2) Create venv if missing
	if (!(Test-Path ".\.venv")) {
		Write-Log "Creating virtual environment at .\.venv" 'INFO'
		if ($hasPy) { py -3 -m venv .venv } else { python -m venv .venv }
	}
	if (!(Test-Path ".\.venv\Scripts\python.exe")) {
		throw "Failed to create virtual environment at .\.venv"
	}
	$venvPy = ".\.venv\Scripts\python.exe"
	Write-Log "Venv Python: $venvPy" 'INFO'

	# 3) Upgrade pip and install requirements
	Write-Log "Upgrading pip..." 'INFO'
	& $venvPy -m pip install --upgrade pip | ForEach-Object { Add-Content -Path $LogPath -Value $_ }
	if (!(Test-Path ".\requirements.txt")) {
		throw "requirements.txt not found at repo root."
	}
	Write-Log "Installing requirements from requirements.txt" 'INFO'
	& $venvPy -m pip install -r requirements.txt | ForEach-Object { Add-Content -Path $LogPath -Value $_ }

	# 4) FFmpeg check (auto-install if missing and winget available), then locate and prepend bin to PATH
	if (-not (Test-Cmd 'ffmpeg')) {
		Write-Log "FFmpeg not found on PATH." 'WARN'
		if (Test-Cmd 'winget') {
			Write-Log "Attempting to install FFmpeg via winget..." 'INFO'
			winget install -e --id Gyan.FFmpeg --silent --accept-package-agreements --accept-source-agreements | Out-Null
			if (-not (Test-Cmd 'ffmpeg')) {
				winget install -e --id FFmpeg.FFmpeg --silent --accept-package-agreements --accept-source-agreements | Out-Null
			}
		} else {
			Write-Log "winget not available; cannot auto-install FFmpeg." 'WARN'
		}
	}

	# Try to locate ffmpeg.exe in common locations (including WinGet package cache) and prepend its bin to PATH
	if (-not (Test-Cmd 'ffmpeg')) {
		$searchRoots = @()
		$searchRoots += (Join-Path $env:ProgramFiles 'FFmpeg')
		$searchRoots += (Join-Path $env:ProgramFiles 'ffmpeg')
		$searchRoots += (Join-Path ${env:ProgramFiles(x86)} 'FFmpeg')
		$searchRoots += 'C:\ffmpeg'
		$wingetRoot = Join-Path $env:LOCALAPPDATA 'Microsoft\WinGet\Packages'
		if (Test-Path $wingetRoot) { $searchRoots += $wingetRoot }

		$foundExe = $null
		foreach ($root in $searchRoots) {
			if (-not (Test-Path $root)) { continue }
			$hit = Get-ChildItem -Path $root -Recurse -Filter ffmpeg.exe -ErrorAction SilentlyContinue |
				Sort-Object LastWriteTime -Descending | Select-Object -First 1
			if ($hit) { $foundExe = $hit.FullName; break }
		}
		if ($foundExe) {
			$ffBin = Split-Path $foundExe
			$env:Path = "$ffBin;$env:Path"
			Write-Log "Found FFmpeg at '$foundExe'. Added '$ffBin' to PATH for this session." 'INFO'
			# Persist for user so new shells pick it up
			try {
				$currentUserPath = [Environment]::GetEnvironmentVariable('Path','User')
				if (-not $currentUserPath) { $currentUserPath = '' }
				if ($currentUserPath -notlike "*$ffBin*") {
					[Environment]::SetEnvironmentVariable('Path', "$ffBin;$currentUserPath", 'User')
					Write-Log "Persisted '$ffBin' to User PATH (restart PowerShell to take effect)." 'INFO'
				}
			} catch {
				Write-Log "Failed to persist FFmpeg bin to User PATH: $($_.Exception.Message)" 'WARN'
			}
		}
	}

	if (-not (Test-Cmd 'ffmpeg')) {
		Write-Log "FFmpeg still not found on PATH. Install FFmpeg and reopen PowerShell, or ensure PATH includes the FFmpeg bin directory." 'WARN'
	}

	# If FFmpeg is present but version 8 on Windows, install a local FFmpeg 7 for TorchCodec compatibility and prepend PATH
	try {
		if (Test-Cmd 'ffmpeg') {
			$verLine = & ffmpeg -version 2>$null | Select-Object -First 1
			if ($verLine -match 'ffmpeg version\s+(\d+)') {
				$ffMajor = [int]$Matches[1]
				if ($ffMajor -ge 8) {
					# Check for existing local FFmpeg 7
					$toolsDir = Join-Path $repoRoot "tools"
					$ff7Dir = Join-Path $toolsDir "ffmpeg7"
					$existingBin = $null
					if (Test-Path $ff7Dir) {
						# Prefer direct bin folder if user already placed it (.\tools\ffmpeg7\bin\ffmpeg.exe)
						$directBin = Join-Path $ff7Dir "bin"
						if (Test-Path (Join-Path $directBin "ffmpeg.exe")) {
							$existingBin = $directBin
						} else {
							# Else, look for extracted ffmpeg-7.* subfolder layout
							$maybeBin = Get-ChildItem -Path $ff7Dir -Directory -Filter "ffmpeg-7.*" -ErrorAction SilentlyContinue | Select-Object -First 1
							if ($maybeBin) {
								$tmpPath = Join-Path $maybeBin.FullName "bin"
								if (Test-Path (Join-Path $tmpPath "ffmpeg.exe")) { $existingBin = $tmpPath }
							}
						}
					}
					if ($existingBin) {
						$env:Path = "$existingBin;$env:Path"
						Write-Log "Detected local FFmpeg 7 at '$existingBin' and added to PATH for this session. Skipping download." 'INFO'
						if ($FFmpeg7PersistPath) {
							try {
								$currentUserPath = [Environment]::GetEnvironmentVariable('Path','User')
								if (-not $currentUserPath) { $currentUserPath = '' }
								if ($currentUserPath -notlike "*$existingBin*") {
									[Environment]::SetEnvironmentVariable('Path', "$existingBin;$currentUserPath", 'User')
									Write-Log "Persisted '$existingBin' to User PATH (restart PowerShell to take effect)." 'INFO'
								}
							} catch {
								Write-Log ("Failed to persist FFmpeg7 bin to User PATH: {0}" -f $_.Exception.Message) 'WARN'
							}
						}
					} else {
						# Decide whether to download
						$shouldDownload = $false
						if ($FFmpeg7Url) {
							$shouldDownload = $true
							Write-Log "FFmpeg 8 detected; will download FFmpeg 7 from override URL." 'INFO'
						} elseif (-not $NoPrompt) {
							$answer = Read-Host "FFmpeg $ffMajor detected. Download FFmpeg 7 fallback now for compatibility? (Y/N)"
							if ($answer -match '^(y|yes)$') { $shouldDownload = $true }
						} else {
							Write-Log "FFmpeg 8 detected; NoPrompt set, skipping automatic FFmpeg 7 download." 'WARN'
						}

						if ($shouldDownload) {
							if (-not (Test-Path $ff7Dir)) { New-Item -ItemType Directory -Force -Path $ff7Dir | Out-Null }
							$urls = @()
							if ($FFmpeg7Url) { $urls += $FFmpeg7Url }
							$urls += @(
								"https://www.gyan.dev/ffmpeg/builds/packages/ffmpeg-7.1-full_build.zip",
								"https://www.gyan.dev/ffmpeg/builds/packages/ffmpeg-7.1-essentials_build.zip",
								"https://www.gyan.dev/ffmpeg/builds/packages/ffmpeg-7.0.1-full_build.zip",
								"https://www.gyan.dev/ffmpeg/builds/packages/ffmpeg-7.0-full_build.zip"
							)
							$tmpZip = Join-Path $env:TEMP "ffmpeg7_full_build.zip"
							$downloaded = $false
							Write-Log "Attempting to download an FFmpeg 7 build for compatibility..." 'INFO'
							foreach ($u in $urls) {
								try {
									Write-Log "Trying $u ..." 'INFO'
									Invoke-WebRequest -Uri $u -OutFile $tmpZip -UseBasicParsing -ErrorAction Stop
									$downloaded = $true
									break
								} catch {
									Write-Log ("Download failed for {0}: {1}" -f $u, $_.Exception.Message) 'WARN'
								}
							}
							if ($downloaded) {
								Write-Log "Extracting FFmpeg 7 to $ff7Dir ..." 'INFO'
								Expand-Archive -Path $tmpZip -DestinationPath $ff7Dir -Force
								Remove-Item -Force $tmpZip -ErrorAction SilentlyContinue
								$bin = Get-ChildItem -Path $ff7Dir -Directory -Filter "ffmpeg-7.*" -ErrorAction SilentlyContinue | Select-Object -First 1
								if ($bin) {
									$ff7bin = Join-Path $bin.FullName "bin"
									if (Test-Path (Join-Path $ff7bin "ffmpeg.exe")) {
										$env:Path = "$ff7bin;$env:Path"
										Write-Log "Using FFmpeg 7 at '$ff7bin' for this session (PATH updated)." 'INFO'
										if ($FFmpeg7PersistPath) {
											try {
												$currentUserPath = [Environment]::GetEnvironmentVariable('Path','User')
												if (-not $currentUserPath) { $currentUserPath = '' }
												if ($currentUserPath -notlike "*$ff7bin*") {
													[Environment]::SetEnvironmentVariable('Path', "$ff7bin;$currentUserPath", 'User')
													Write-Log "Persisted '$ff7bin' to User PATH (restart PowerShell to take effect)." 'INFO'
												}
											} catch {
												Write-Log ("Failed to persist FFmpeg7 bin to User PATH: {0}" -f $_.Exception.Message) 'WARN'
											}
										}
									}
								}
							} else {
								Write-Log "Could not download an FFmpeg 7 package automatically (non-fatal). You can manually place a 7.x build under 'tools\\ffmpeg7\\' so that '.\\tools\\ffmpeg7\\...\\bin\\ffmpeg.exe' exists." 'WARN'
								Write-Log "Manual builds: https://www.gyan.dev/ffmpeg/builds/ (choose a 7.x full/essentials build)" 'INFO'
							}
						}
					}
				}
			}
		}
	} catch {
		Write-Log "FFmpeg 7 setup step failed (non-fatal): $($_.Exception.Message)" 'WARN'
	}

	# 5) Manage TorchCodec based on active FFmpeg version (7 recommended on Windows)
	try {
		$verLine2 = & ffmpeg -version 2>$null | Select-Object -First 1
		$ffMajor2 = $null
		if ($verLine2 -match 'ffmpeg version\s+(\d+)') {
			$ffMajor2 = [int]$Matches[1]
		}
		$hasTorchCodec2 = & $venvPy -c "import importlib.util as u; print(1 if u.find_spec('torchcodec') else 0)"
		if ($ffMajor2 -and $ffMajor2 -le 7) {
			# Ensure torchcodec installed for torchaudio.save compatibility
			if ($hasTorchCodec2 -ne '1') {
				Write-Log "FFmpeg $ffMajor2 active. Installing torchcodec for torchaudio save support..." 'INFO'
				& $venvPy -m pip install torchcodec | ForEach-Object { Add-Content -Path $LogPath -Value $_ }
			}
		} elseif ($ffMajor2 -and $ffMajor2 -ge 8) {
			# Avoid torchcodec with FFmpeg 8 on Windows to prevent DLL load errors
			if ($hasTorchCodec2 -eq '1') {
				Write-Log "FFmpeg $ffMajor2 active. Uninstalling torchcodec to avoid DLL load issues..." 'INFO'
				& $venvPy -m pip uninstall -y torchcodec | ForEach-Object { Add-Content -Path $LogPath -Value $_ }
			}
		}
	} catch {
		Write-Log ("TorchCodec management step failed (non-fatal): {0}" -f $_.Exception.Message) 'WARN'
	}

	# 6) Verify Demucs import
	Write-Log "Verifying Demucs import..." 'INFO'
	& $venvPy -c "import demucs; print('Demucs OK')" | ForEach-Object { Add-Content -Path $LogPath -Value $_ }

	# 7) Optional warmup (download model weights)
	if ($WarmupDemucs) {
		Write-Log "Warming up Demucs model download (may take a while)..." 'INFO'
		if (Test-Cmd 'ffmpeg') {
			$tmpIn = Join-Path $env:TEMP "demucs_warmup_input.wav"
			$tmpOutDir = Join-Path $env:TEMP "demucs_warmup_out"
			ffmpeg -f lavfi -i anullsrc=channel_layout=stereo:sample_rate=44100 -t 1 -acodec pcm_s16le "$tmpIn" -y | Out-Null
			& $venvPy -m demucs -n htdemucs -o "$tmpOutDir" "$tmpIn" | ForEach-Object { Add-Content -Path $LogPath -Value $_ }
			Remove-Item -Force "$tmpIn" -ErrorAction SilentlyContinue
			Remove-Item -Recurse -Force "$tmpOutDir" -ErrorAction SilentlyContinue
		} else {
			Write-Log "FFmpeg not available; skipping warmup." 'WARN'
		}
	}

	Write-Host ""
	Write-Host "-----------------------------------------------"
	Write-Host " Environment is ready."
	Write-Host " Next steps:"
	Write-Host "  1) Use the venv Python to run the processor:"
	Write-Host '     .\.venv\Scripts\python.exe scripts\process_track.py `'
	Write-Host '       --input ".\poor_man_rose\Poor_man_rose.mp3" `'
	Write-Host '       --output-dir ".\outputs\poor_man_rose"'
	Write-Host "  2) Help: .\.venv\Scripts\python.exe scripts\process_track.py --help"
	Write-Host "-----------------------------------------------"
	Write-Host ""
	Write-Log "Setup completed successfully." 'INFO'

} catch {
	Write-Log ("Setup failed: {0}" -f $_.Exception.Message) 'ERROR'
	throw
} finally {
	Pop-Location
}


