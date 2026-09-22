$ErrorActionPreference = "Stop"
Set-Location "c:\projects\SoundCloud\mp4"

$src = "Harvoin-yhtehen-yhymme.mp4"
$out = "Harvoin-yhtehen-yhymme-fixed.mp4"
$start = 11.8
# next scene at 23.0; one frame at 30fps = 1/30 — pull back one frame before cut
$end = [math]::Round(23.0 - (1.0 / 30.0), 4)

Write-Output "window $start -> $end (one frame before next scene)"

$fc = @"
[0:v]trim=0:${start},setpts=PTS-STARTPTS[v0];
[0:v]trim=${start}:${end},setpts=PTS-STARTPTS,crop=iw-40:ih:20:0,scale=1280:720:flags=lanczos,setsar=1[v1];
[0:v]trim=${end},setpts=PTS-STARTPTS[v2];
[v0][v1][v2]concat=n=3:v=1:a=0[v]
"@

ffmpeg -y -hide_banner -loglevel error -i $src -filter_complex $fc `
  -map "[v]" -map 0:a `
  -c:v libx264 -crf 17 -preset slow -pix_fmt yuv420p `
  -c:a aac -b:a 320k -shortest -movflags +faststart $out

ffprobe -v error -show_entries format=duration -of default=noprint_wrappers=1 $out
Write-Output "MB_decimal=$([math]::Round((Get-Item $out).Length / 1000000, 1))"
Write-Output "done"
