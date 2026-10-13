"""Move the monitor lizard from the left bank (near Viki) to the right bank under the trees.
usage: python move_monitor.py src.png clean.png out.png
"""
import sys
import cv2
import numpy as np

from rescale_animals import feather

BOX = (120, 2270, 600, 2510)
OUTLINE = [(0, 235), (110, 165), (225, 110), (290, 60), (370, 20), (440, 5), (480, 20), (470, 50),
           (425, 70), (410, 100), (330, 150), (290, 170), (250, 185), (150, 210), (20, 250)]
SCALE = 0.62
HEAD_AT = (1285, 1875)


def largest(m):
    n, lab, stats, _ = cv2.connectedComponentsWithStats(m.astype(np.uint8))
    return (lab == 1 + np.argmax(stats[1:, cv2.CC_STAT_AREA])).astype(np.uint8)


def lizard_mask(roi):
    """The lizard is grey/olive and the grass is saturated green: colour seed inside OUTLINE, refined by GrabCut."""
    hsv = cv2.cvtColor(roi, cv2.COLOR_BGR2HSV)
    zone = np.zeros(roi.shape[:2], np.uint8)
    cv2.fillPoly(zone, [np.array(OUTLINE, np.int32)], 1)
    seed = (((hsv[..., 1] < 110) | (hsv[..., 2] < 60)) & (zone > 0)).astype(np.uint8)
    seed = cv2.morphologyEx(seed, cv2.MORPH_CLOSE, np.ones((9, 9), np.uint8))
    g = np.full(seed.shape, cv2.GC_BGD, np.uint8)
    g[zone > 0] = cv2.GC_PR_BGD
    g[seed > 0] = cv2.GC_PR_FGD
    g[cv2.erode(seed, np.ones((9, 9), np.uint8)) > 0] = cv2.GC_FGD
    cv2.grabCut(roi, g, None, np.zeros((1, 65)), np.zeros((1, 65)), 10, cv2.GC_INIT_WITH_MASK)
    m = (g == cv2.GC_FGD) | (g == cv2.GC_PR_FGD)
    grass = (hsv[..., 0] >= 33) & (hsv[..., 0] <= 90) & (hsv[..., 1] > 70)
    m = largest(cv2.morphologyEx((m & ~grass).astype(np.uint8), cv2.MORPH_OPEN, np.ones((5, 5), np.uint8)))
    m = cv2.morphologyEx(m, cv2.MORPH_CLOSE, np.ones((7, 7), np.uint8))
    return feather(m, 1.2)


def main(src, clean, out):
    a, c = cv2.imread(src), cv2.imread(clean)
    x0, y0, x1, y1 = BOX
    roi = a[y0:y1, x0:x1].copy()
    alpha = lizard_mask(roi)
    res = a.astype(np.float32)
    hole = np.zeros(a.shape[:2], np.float32)
    hole[y0 - 30:y1 + 30, max(0, x0 - 40):x1 + 40] = 1
    hole = feather(hole, 14)[..., None]
    res = res * (1 - hole) + c.astype(np.float32) * hole

    roi, alpha = cv2.flip(roi, 1), cv2.flip(alpha, 1)
    rw, rh = int(roi.shape[1] * SCALE), int(roi.shape[0] * SCALE)
    roi = cv2.resize(roi, (rw, rh), interpolation=cv2.INTER_AREA).astype(np.float32)
    alpha = cv2.resize(alpha, (rw, rh), interpolation=cv2.INTER_AREA)
    ys, xs = np.nonzero(alpha > 0.5)
    hx, hy = xs.min(), ys[xs == xs.min()].mean()
    px, py = int(HEAD_AT[0] - hx), int(HEAD_AT[1] - hy)
    pw = min(rw, res.shape[1] - px)
    roi, alpha = roi[:, :pw], alpha[:, :pw]

    shadow = cv2.GaussianBlur(alpha, (0, 0), 3) * 0.4
    reg = res[py + 4:py + 4 + rh, px + 8:px + 8 + pw]
    reg *= 1 - shadow[:reg.shape[0], :reg.shape[1], None]
    reg = res[py:py + rh, px:px + pw]
    res[py:py + rh, px:px + pw] = reg * (1 - alpha[..., None]) + roi * alpha[..., None]
    if not cv2.imwrite(out, np.clip(res, 0, 255).astype(np.uint8)):
        sys.exit(f"could not write {out}")
    print("saved", out)


if __name__ == "__main__":
    main(*sys.argv[1:4])
