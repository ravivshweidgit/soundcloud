$ErrorActionPreference = "Stop"
Set-Location "c:\projects\SoundCloud\mp4"

# Work from already-fixed master (keeps first border surgery)
$src = "Harvoin-yhtehen-yhymme-fixed.mp4"
$out = "Harvoin-yhtehen-yhymme-fixed.mp4"
$tmp = "Harvoin-yhtehen-yhymme-fixed-tmp.mp4"

# Spot-on: artifact scene starts 117.80 (after artistic white frame)
# Next clean scene at 126.77 — end exactly on that cut (one frame later than prior pull-back)
$start = 117.80
$end = 126.77

Write-Output "window2 $start -> $end (spot-on scene cut)"

$fc = @"
[0:v]trim=0:${start},setpts=PTS-STARTPTS[v0];
[0:v]trim=${start}:${end},setpts=PTS-STARTPTS,crop=iw-20:ih:10:0,scale=1280:720:flags=lanczos,setsar=1[v1];
[0:v]trim=${end},setpts=PTS-STARTPTS[v2];
[v0][v1][v2]concat=n=3:v=1:a=0[v]
"@

ffmpeg -y -hide_banner -loglevel error -i $src -filter_complex $fc `
  -map "[v]" -map 0:a `
  -c:v libx264 -crf 17 -preset slow -pix_fmt yuv420p `
  -c:a aac -b:a 320k -shortest -movflags +faststart $tmp

Move-Item -Force $tmp $out

ffprobe -v error -show_entries format=duration -of default=noprint_wrappers=1 $out
Write-Output "MB_decimal=$([math]::Round((Get-Item $out).Length / 1000000, 1))"

# verify: artistic frame untouched, artifact gone, next scene no squeeze
New-Item -ItemType Directory -Force -Path "harvoin\_border-fixed2" | Out-Null
foreach ($t in @(117.7,117.8,120,124,126.7,126.77,127)) {
  $n = "t" + ($t.ToString("0.00").Replace('.','_'))
  ffmpeg -y -hide_banner -loglevel error -ss $t -i $out -frames:v 1 "harvoin\_border-fixed2\$n.png"
}

python -c @"
from PIL import Image
import os, numpy as np
base=r'harvoin/_border-fixed2'
for fn in sorted(os.listdir(base), key=lambda x: float(x[1:-4].replace('_','.'))):
    Y=np.asarray(Image.open(os.path.join(base,fn)).convert('RGB')).astype(float).mean(axis=2)
    h,w=Y.shape
    Ld=Y[:,0:6].mean()-Y[:,15:40].mean()
    Rd=Y[:,-6:].mean()-Y[:,-40:-15].mean()
    T=Y[0:8,:].mean(); B=Y[-8:,:].mean()
    artistic = T>200 and B>200
    artifact = (not artistic) and (Ld>40 or Rd>40)
    kind='ARTISTIC' if artistic else ('ARTIFACT' if artifact else 'ok')
    t=float(fn[1:-4].replace('_','.'))
    print(f'{t:7.2f} {kind:8} Ld={Ld:6.1f} Rd={Rd:6.1f} T={T:5.1f} B={B:5.1f}')
"@

Write-Output "done"
