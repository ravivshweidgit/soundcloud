"""Move Viki (with her shadow) a few steps forward along the path in the end frame.
usage: python move_viki.py frame.png clean.png out.png
"""
import sys
import cv2
import numpy as np

from rescale_animals import feather

BOX = (500, 1850, 1300, 2600)
SHIFT = (-200, 70)


def main(src, clean, out):
    a, c = cv2.imread(src), cv2.imread(clean)
    print("diff outside box:", round(float(np.abs(a.astype(int) - c.astype(int))[:1700].mean()), 2))
    x0, y0, x1, y1 = BOX
    d = np.abs(a[y0:y1, x0:x1].astype(int) - c[y0:y1, x0:x1].astype(int)).max(axis=2)
    m = (d > 28).astype(np.uint8)
    m = cv2.morphologyEx(m, cv2.MORPH_OPEN, np.ones((3, 3), np.uint8))
    m = cv2.morphologyEx(m, cv2.MORPH_CLOSE, np.ones((15, 15), np.uint8))
    n, lab, stats, _ = cv2.connectedComponentsWithStats(m)
    keep = np.zeros_like(m)
    for i in 1 + np.argsort(stats[1:, cv2.CC_STAT_AREA])[::-1][:3]:
        if stats[i, cv2.CC_STAT_AREA] > 2000:
            keep[lab == i] = 1
    alpha = feather(keep, 2.0)

    res = c.astype(np.float32)
    dx, dy = SHIFT
    tgt = res[y0 + dy:y1 + dy, x0 + dx:x1 + dx]
    roi = a[y0:y1, x0:x1].astype(np.float32)
    res[y0 + dy:y1 + dy, x0 + dx:x1 + dx] = tgt * (1 - alpha[..., None]) + roi * alpha[..., None]
    cv2.imwrite(out.replace(".png", "-mask.png"), (alpha * 255).astype(np.uint8))
    if not cv2.imwrite(out, np.clip(res, 0, 255).astype(np.uint8)):
        sys.exit(f"could not write {out}")
    print("saved", out)


if __name__ == "__main__":
    main(*sys.argv[1:4])
