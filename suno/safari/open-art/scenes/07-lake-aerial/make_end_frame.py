"""End frame for the right-bank dive: lizard gone, ripples where it dived, heron further left.
usage: python make_end_frame.py start.png no_lizard_right.png old_end.png out.png
"""
import sys
import cv2
import numpy as np

from rescale_animals import feather

BANK = (1230, 1780, 1536, 1990)
HERON = (90, 1430, 720, 1910)
RIPPLES = (120, 1930, 620, 2200)
RIPPLE_SCALE = 0.5
RIPPLE_CENTRE = (1235, 1880)


def paste_region(res, src, box, r):
    x0, y0, x1, y1 = box
    m = np.zeros(res.shape[:2], np.float32)
    m[y0:y1, x0:x1] = 1
    m = feather(m, r)[..., None]
    return res * (1 - m) + src * m


def main(start, no_lizard, old_end, out):
    res = cv2.imread(start).astype(np.float32)
    res = paste_region(res, cv2.imread(no_lizard).astype(np.float32), BANK, 10)
    end = cv2.imread(old_end).astype(np.float32)
    res = paste_region(res, end, HERON, 12)

    x0, y0, x1, y1 = RIPPLES
    patch = end[y0:y1, x0:x1]
    detail = patch - cv2.GaussianBlur(patch, (0, 0), 12)
    w, h = int((x1 - x0) * RIPPLE_SCALE), int((y1 - y0) * RIPPLE_SCALE)
    detail = cv2.resize(detail, (w, h), interpolation=cv2.INTER_AREA)
    ell = np.zeros((h, w), np.float32)
    cv2.ellipse(ell, (w // 2, h // 2), (w // 2 - 6, h // 2 - 6), 0, 0, 360, 1, -1)
    ell = feather(ell, 6)
    px, py = RIPPLE_CENTRE[0] - w // 2, RIPPLE_CENTRE[1] - h // 2
    region = res[py:py + h, px:px + w]
    hsv = cv2.cvtColor(np.clip(region, 0, 255).astype(np.uint8), cv2.COLOR_BGR2HSV)
    water = feather(~((hsv[..., 0] >= 25) & (hsv[..., 0] <= 90) & (hsv[..., 1] > 90)), 3)
    a = (ell * water)[..., None]
    res[py:py + h, px:px + w] = region + detail * a * 1.3

    if not cv2.imwrite(out, np.clip(res, 0, 255).astype(np.uint8)):
        sys.exit(f"could not write {out}")
    print("saved", out)


if __name__ == "__main__":
    main(*sys.argv[1:5])
