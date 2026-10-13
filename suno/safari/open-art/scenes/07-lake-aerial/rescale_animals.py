"""Shrink the animals in an edited frame to true scale.
Cuts each animal out of `src` with GrabCut, fills its old area from the clean plate, pastes it back scaled.
usage: python rescale_animals.py src.png clean.png out.png
"""
import sys
import cv2
import numpy as np

# name: (x0, y0, x1, y1) box around the animal, scale, anchor ("feet" = bottom centre stays, "right" = right end stays)
ANIMALS = {
    "monkey-sitting": ((1050, 2100, 1250, 2345), 0.5, "feet"),
    "monkey-walking": ((1240, 1990, 1440, 2290), 0.5, "feet"),
    "monitor": ((0, 2230, 660, 2740), 0.5, "right"),
}
OUTLINES = {
    "monitor": [(595, 90), (610, 150), (530, 205), (490, 300), (340, 360), (150, 345), (0, 425),
                (0, 330), (110, 245), (250, 175), (420, 125), (520, 88)],
}
PAD = 40


def feather(mask, r):
    return cv2.GaussianBlur(mask.astype(np.float32), (0, 0), r)


def outline_cutout(img, box, poly):
    """Animal that runs off the frame edge: GrabCut seeded with a rough outline (box-relative points)."""
    x0, y0, x1, y1 = box
    roi = img[y0:y1, x0:x1].copy()
    m = np.full(roi.shape[:2], cv2.GC_BGD, np.uint8)
    cv2.fillPoly(m, [np.array(poly, np.int32)], cv2.GC_PR_FGD)
    bg, fg = np.zeros((1, 65), np.float64), np.zeros((1, 65), np.float64)
    cv2.grabCut(roi, m, None, bg, fg, 8, cv2.GC_INIT_WITH_MASK)
    alpha = np.where((m == cv2.GC_FGD) | (m == cv2.GC_PR_FGD), 1, 0).astype(np.uint8)
    alpha = cv2.morphologyEx(alpha, cv2.MORPH_OPEN, np.ones((5, 5), np.uint8))
    n, lab, stats, _ = cv2.connectedComponentsWithStats(alpha)
    alpha = (lab == 1 + np.argmax(stats[1:, cv2.CC_STAT_AREA])).astype(np.float32)
    return roi, feather(alpha, 1.2)


def cutout(img, box):
    x0, y0, x1, y1 = box
    roi = img[y0:y1, x0:x1].copy()
    m = np.zeros(roi.shape[:2], np.uint8)
    bg, fg = np.zeros((1, 65), np.float64), np.zeros((1, 65), np.float64)
    cv2.grabCut(roi, m, (6, 6, roi.shape[1] - 12, roi.shape[0] - 12), bg, fg, 8, cv2.GC_INIT_WITH_RECT)
    alpha = np.where((m == cv2.GC_FGD) | (m == cv2.GC_PR_FGD), 1.0, 0.0).astype(np.float32)
    alpha = cv2.morphologyEx(alpha, cv2.MORPH_OPEN, np.ones((5, 5), np.uint8))
    n, lab, stats, _ = cv2.connectedComponentsWithStats((alpha > 0).astype(np.uint8))
    if n > 1:
        keep = 1 + np.argmax(stats[1:, cv2.CC_STAT_AREA])
        alpha = (lab == keep).astype(np.float32)
    return roi, feather(alpha, 1.2)


def main(src, clean, out):
    a, c = cv2.imread(src).astype(np.float32), cv2.imread(clean).astype(np.float32)
    h, w = a.shape[:2]
    res = a.copy()
    cuts = []
    for name, (box, s, anchor) in ANIMALS.items():
        if name in OUTLINES:
            roi, alpha = outline_cutout(a.astype(np.uint8), box, OUTLINES[name])
        else:
            roi, alpha = cutout(a.astype(np.uint8), box)
        cuts.append((box, s, anchor, roi.astype(np.float32), alpha))
        x0, y0, x1, y1 = box
        hole = np.zeros((h, w), np.float32)
        hole[max(0, y0 - PAD):y1 + PAD, max(0, x0 - PAD):x1 + PAD + 60] = 1
        hole = feather(hole, 18)[..., None]
        res = res * (1 - hole) + c * hole
    for (x0, y0, x1, y1), s, anchor, roi, alpha in cuts:
        rw, rh = int(roi.shape[1] * s), int(roi.shape[0] * s)
        roi_s = cv2.resize(roi, (rw, rh), interpolation=cv2.INTER_AREA)
        al_s = cv2.resize(alpha, (rw, rh), interpolation=cv2.INTER_AREA)
        if anchor == "feet":
            px, py = (x0 + x1) // 2 - rw // 2, y1 - rh
        else:
            px, py = x1 - rw, (y0 + y1) // 2 - rh // 2
        shadow = cv2.GaussianBlur(al_s, (0, 0), 4) * 0.45
        sy, sx = py + 6, px + 14
        reg = res[sy:sy + rh, sx:sx + rw]
        reg *= (1 - shadow[:reg.shape[0], :reg.shape[1], None])
        reg = res[py:py + rh, px:px + rw]
        al = al_s[..., None]
        res[py:py + rh, px:px + rw] = reg * (1 - al) + roi_s * al
    cv2.imwrite(out, np.clip(res, 0, 255).astype(np.uint8))
    print("saved", out)


if __name__ == "__main__":
    main(*sys.argv[1:4])
