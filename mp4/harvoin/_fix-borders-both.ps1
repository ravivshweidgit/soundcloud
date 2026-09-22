$ErrorActionPreference = "Stop"
Set-Location "c:\projects\SoundCloud\mp4"

$src = "Harvoin-yhtehen-yhymme.mp4"
$out = "Harvoin-yhtehen-yhymme-fixed.mp4"
$tmp = "Harvoin-yhtehen-yhymme-fixed-tmp.mp4"

# Surgery 1 (perfect): start 11.8, end one frame before scene at 23.0
$a0 = 11.8
$a1 = [math]::Round(23.0 - (1.0 / 30.0), 4)

# Surgery 2: start spot-on 117.80, end one frame later than prior (= on cut 126.77)
$b0 = 117.80
$b1 = 126.77

Write-Output "window1 $a0 -> $a1"
Write-Output "window2 $b0 -> $b1"

# crop widths: first artifact needed ~20px/side; second softer ~10px/side
$fc = @"
[0:v]trim=0:${a0},setpts=PTS-STARTPTS[v0];
[0:v]trim=${a0}:${a1},setpts=PTS-STARTPTS,crop=iw-40:ih:20:0,scale=1280:720:flags=lanczos,setsar=1[v1];
[0:v]trim=${a1}:${b0},setpts=PTS-STARTPTS[v2];
[0:v]trim=${b0}:${b1},setpts=PTS-STARTPTS,crop=iw-20:ih:10:0,scale=1280:720:flags=lanczos,setsar=1[v3];
[0:v]trim=${b1},setpts=PTS-STARTPTS[v4];
[v0][v1][v2][v3][v4]concat=n=5:v=1:a=0[v]
"@

ffmpeg -y -hide_banner -loglevel error -i $src -filter_complex $fc `
  -map "[v]" -map 0:a `
  -c:v libx264 -crf 17 -preset slow -pix_fmt yuv420p `
  -c:a aac -b:a 320k -shortest -movflags +faststart $tmp

Move-Item -Force $tmp $out

ffprobe -v error -show_entries format=duration -of default=noprint_wrappers=1 $out
Write-Output "MB_decimal=$([math]::Round((Get-Item $out).Length / 1000000, 1))"
Write-Output "done"
