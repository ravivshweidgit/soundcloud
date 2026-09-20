SoundCloud Track Processor (Local Stems + Modernize)

Process an audio file you own the rights to: separate stems, optionally replace vocals or the instrumental, keep melodies, and render a more modern production with a simple mastering chain.

Important:
- Only use audio you created or have explicit permission to process. For SoundCloud, use the track’s official Download button when the artist provided it, or your own exported audio. Do not download or process copyrighted material without permission.
- This tool does not download from SoundCloud. Provide a local audio file path.

## Downloading from SoundCloud (if available)

- For someone else’s track:
  - The Download button only appears if the uploader enabled downloads.
  - On desktop, open the track page and look for:
    - “Download file” below the waveform, or
    - The three-dots “More” menu > “Download file”.
  - If you don’t see it, downloads aren’t enabled. Respect the artist’s settings.
  - Mobile apps generally don’t offer file downloads.
- For your own track (enable downloads):
  1. Open SoundCloud for Artists and go to your Tracks.
  2. Open the track > Edit > Permissions.
  3. Check “Enable downloads” and Save.
  4. Visit the public track page and use “Download file”.
- Alternative: export your song from your DAW to WAV/AIFF/FLAC and use that local file.

## Quickstart (Windows)

### One-time setup via script (recommended)

```powershell
# From the project root
powershell -ExecutionPolicy Bypass -File .\setup\setup.ps1
# Optional flags:
#   -InstallPython   Attempt Python install via winget if missing
#   -InstallFFmpeg   Attempt FFmpeg install via winget if missing
#   -WarmupDemucs    Trigger model download (can take a while)
```

Prerequisites:
- Python 3.10 (needed for the pinned `torch==2.2.2` / `torchaudio==2.2.2` wheels)
- FFmpeg installed and on PATH (check in PowerShell: `ffmpeg -version`)

Setup:
1) Create and activate a dedicated 3.10 virtual environment:

```powershell
py -3.10 -m venv .venv310
.\.venv310\Scripts\Activate.ps1
```

2) Install dependencies:

```powershell
python -m pip install --upgrade pip setuptools wheel
python -m pip install --no-cache-dir -r requirements.txt
```

3) Add the bundled FFmpeg (optional but recommended if you use `tools\ffmpeg7`):

```powershell
$env:PATH="C:\projects\SoundCloud\tools\ffmpeg7\bin;" + $env:PATH
```

> Tip: drop your source files into `inputs\<track_id>.mp3` to use the helper scripts with their defaults.

4) Run the processor (example: keep melodies, replace vocals):

```powershell
python scripts\process_track.py `
  --input "C:\path\to\your_track.wav" `
  --output-dir ".\outputs" `
  --replace-vocals "C:\path\to\new_vocals.wav"
```

5) Result:
- Separated stems will be placed under `.\\outputs\\<track_name>\\separated\\...`
- Final versions will be in `.\\outputs\\<track_name>\\final\\...`

Tip: `process\run.ps1` automates the steps above for Windows users.

## Quickstart (WSL2 / Linux)

The project also runs cleanly under WSL2 with Python 3.10. From your WSL shell:

```bash
cd /mnt/c/projects/SoundCloud
./setup/setup.sh --install-ffmpeg
source .venv310/bin/activate
export TORCHAUDIO_USE_TORCHCODEC=0
python scripts/process_track.py \
  --input "/mnt/c/projects/SoundCloud/inputs/poor_man_rose.mp3" \
  --output-dir "/mnt/c/projects/SoundCloud/outputs/poor_man_rose"
```

> Prefer manual steps? Follow the commands in `setup/setup.sh` (create `.venv310`, install requirements, ensure FFmpeg).

For repeated runs, you can call `process/run.sh poor_man_rose` to activate `.venv310`, read `inputs/poor_man_rose.mp3`, and write to `outputs/poor_man_rose`. The script assumes you already installed dependencies in that venv; pass extra `process_track.py` flags after a `--`, for example `process/run.sh poor_man_rose -- --master-target-lufs -12`.

### MusicGen workflow (optional modern instrumental)

1. Provision the MusicGen virtual environment:

```bash
cd /mnt/c/projects/SoundCloud
./setup/musicgen.sh
```

This pins `numpy==1.26.4` so the bundled Torch/Audiocraft stack loads correctly.
The script also installs `transformers==4.37.2`, which matches the Torch 2.2.2 wheels.

> GPU setup? Use `./setup/musicgen_gpu.sh` instead—it installs the CUDA wheels (torch/torchaudio 2.2.2+cu121). Update `TORCH_INDEX_URL` if your CUDA toolkit needs a different build.

2. Create a reference mix from Demucs stems and render a modern instrumental:

```bash
./process/musicgen.sh poor_man_rose
```

This saves `outputs/musicgen/poor_man_rose_modern_instrumental.wav`. The default prompt targets “modern pop electronic production ... shimmering synths”; override it with `--prompt "your description"` or adjust length via `--duration 45`.

3. Fold the AI instrumental back into the mastering pipeline:

```bash
./process/run.sh poor_man_rose -- --replace-instrumental "/mnt/c/projects/SoundCloud/outputs/musicgen/poor_man_rose_modern_instrumental.wav"
```

## What it does

- Separates the track into stems using Demucs (`vocals`, `drums`, `bass`, `other`).
- By default, keeps existing instrumentation (melodies in `other`/`bass`) and replaces vocals if you provide a `--replace-vocals` file.
- Optionally replace instrumental/backing with `--replace-instrumental`.
- Mixes stems and applies a light mastering chain (high‑pass, compression, loudness normalization, limiter) for a more modern sound.

## CLI options

```text
Usage: process_track.py [OPTIONS]

Options:
  --input PATH                Input audio file (WAV/MP3/FLAC/etc).  [required]
  --output-dir PATH           Output directory. Defaults to .\outputs
  --replace-vocals PATH       Optional path to replacement vocals file
  --replace-instrumental PATH Optional path to replacement instrumental/backing
  --vocals-gain-db FLOAT      Gain for vocals in dB (default: 0.0)
  --drums-gain-db FLOAT       Gain for drums in dB (default: 0.0)
  --bass-gain-db FLOAT        Gain for bass in dB (default: 0.0)
  --other-gain-db FLOAT       Gain for other/melody in dB (default: 0.0)
  --master-target-lufs FLOAT  Target LUFS for loudness normalization (default: -10)
  --sample-rate INTEGER       Output sample rate (default: 44100)
  --help                      Show this message and exit.
```

Tips:
- If you only want to replace vocals, provide `--replace-vocals` and leave the rest as is.
- If you want to modernize without replacing anything, skip both replace flags; you’ll still get a mastered bounce.

## Notes and limitations

- Demucs downloads model weights on first run. This may take a while.
- FFmpeg is required by `pydub` and for the mastering stage.
- Time alignment of replacement tracks is not automatic; provide replacements already aligned to your song, or trim/pad beforehand.
- The mastering chain here is intentionally simple. For professional results, export stems to a DAW and finish with your preferred plugins.

## Legal

Use this software responsibly and only with content you are authorized to process.

