"""Subtle face slimming and chin tuck on a video, frame by frame (MediaPipe face landmarks + smooth warp).

usage: python face_slim.py in.mp4 out.mp4 [--roi x0,y0,x1,y1] [--slim 0.05] [--chin 0.04] [--preview frame_no preview.jpg]

--slim  jaw sides move toward the face centre by this fraction of face width
--chin  chin moves up by this fraction of face height
Only the largest face is changed. Audio is copied from the input.
"""
import argparse
import os
import subprocess

import cv2
import mediapipe as mp
import numpy as np
from mediapipe.tasks.python import BaseOptions, vision

MODEL = os.path.join(os.path.dirname(__file__), "models", "face_landmarker.task")

JAW_LEFT = [234, 93, 132, 58, 172, 136, 150, 149]
JAW_RIGHT = [454, 323, 361, 288, 397, 365, 379, 378]
CHIN = [176, 148, 152, 377, 400]
ANCHORS = [33, 133, 362, 263, 1, 4, 13, 14, 61, 291, 10, 109, 338, 67, 297]


def probe(path):
    out = subprocess.check_output(
        ["ffprobe", "-v", "error", "-select_streams", "v:0", "-show_entries", "stream=width,height,r_frame_rate",
         "-of", "csv=p=0", path], text=True).strip().split(",")
    num, den = out[2].split("/")
    return int(out[0]), int(out[1]), float(num) / float(den), out[2]


def displacements(pts, slim, chin):
    oval = pts[JAW_LEFT + JAW_RIGHT + CHIN]
    x0, y0 = oval.min(0)
    x1, y1 = oval.max(0)
    w, h = x1 - x0, y1 - pts[10][1]
    cx = pts[[1, 4, 152, 10]][:, 0].mean()
    src, dst = [], []
    for i in JAW_LEFT + JAW_RIGHT:
        p = pts[i]
        depth = np.clip((p[1] - pts[1][1]) / max(h * 0.5, 1), 0.3, 1.0)
        src.append(p)
        dst.append([p[0] + (cx - p[0]) / max(abs(cx - p[0]), 1) * slim * w * depth, p[1]])
    for i in CHIN:
        p = pts[i]
        src.append(p)
        dst.append([p[0] + (cx - p[0]) * slim, p[1] - chin * h])
    for i in ANCHORS:
        src.append(pts[i])
        dst.append(pts[i])
    return np.float32(src), np.float32(dst), max(w, h)


def warp(frame, src, dst, size, strength):
    if strength <= 0:
        return frame
    H, W = frame.shape[:2]
    r = size * 0.28
    x0 = int(max(src[:, 0].min() - 2 * r, 0)); x1 = int(min(src[:, 0].max() + 2 * r, W))
    y0 = int(max(src[:, 1].min() - 2 * r, 0)); y1 = int(min(src[:, 1].max() + 2 * r, H))
    gx, gy = np.meshgrid(np.arange(x0, x1, dtype=np.float32), np.arange(y0, y1, dtype=np.float32))
    dx = np.zeros_like(gx); dy = np.zeros_like(gy); wsum = np.zeros_like(gx)
    for (sx, sy), (tx, ty) in zip(src, dst):
        wgt = np.exp(-((gx - tx) ** 2 + (gy - ty) ** 2) / (r * r))
        dx += wgt * (sx - tx); dy += wgt * (sy - ty); wsum += wgt
    norm = np.maximum(wsum, 1.0)
    mapx = gx + strength * dx / norm
    mapy = gy + strength * dy / norm
    out = frame.copy()
    out[y0:y1, x0:x1] = cv2.remap(frame, mapx, mapy, cv2.INTER_CUBIC, borderMode=cv2.BORDER_REFLECT)
    return out


def main():
    p = argparse.ArgumentParser()
    p.add_argument("inp"); p.add_argument("out")
    p.add_argument("--slim", type=float, default=0.05)
    p.add_argument("--chin", type=float, default=0.04)
    p.add_argument("--roi", default="0,0,1,1", help="x0,y0,x1,y1 fractions of the frame where her face is")
    p.add_argument("--preview", nargs=2, metavar=("FRAME", "JPG"))
    a = p.parse_args()

    W, H, fps, rate = probe(a.inp)
    fx0, fy0, fx1, fy1 = (float(v) for v in a.roi.split(","))
    rx0, ry0, rx1, ry1 = int(fx0 * W), int(fy0 * H), int(fx1 * W), int(fy1 * H)
    scale = 640 / max(rx1 - rx0, ry1 - ry0)
    landmarker = vision.FaceLandmarker.create_from_options(vision.FaceLandmarkerOptions(
        base_options=BaseOptions(model_asset_path=MODEL), running_mode=vision.RunningMode.VIDEO,
        num_faces=2, min_face_detection_confidence=0.4, min_tracking_confidence=0.4))
    reader = subprocess.Popen(["ffmpeg", "-v", "error", "-i", a.inp, "-f", "rawvideo", "-pix_fmt", "bgr24", "-"],
                              stdout=subprocess.PIPE)
    writer = None
    if not a.preview:
        writer = subprocess.Popen(
            ["ffmpeg", "-v", "error", "-y", "-f", "rawvideo", "-pix_fmt", "bgr24", "-s", f"{W}x{H}", "-r", rate,
             "-i", "-", "-i", a.inp, "-map", "0:v", "-map", "1:a?", "-c:v", "libx264", "-crf", "15", "-preset", "slow",
             "-pix_fmt", "yuv420p", "-c:a", "copy", a.out], stdin=subprocess.PIPE)

    smooth, strength, n, hits = None, 0.0, 0, 0
    while True:
        buf = reader.stdout.read(W * H * 3)
        if len(buf) < W * H * 3:
            break
        frame = np.frombuffer(buf, np.uint8).reshape(H, W, 3)
        crop = cv2.resize(frame[ry0:ry1, rx0:rx1], None, fx=scale, fy=scale, interpolation=cv2.INTER_CUBIC)
        res = landmarker.detect_for_video(
            mp.Image(image_format=mp.ImageFormat.SRGB, data=np.ascontiguousarray(cv2.cvtColor(crop, cv2.COLOR_BGR2RGB))),
            int(n * 1000 / fps))
        if res.face_landmarks:
            face = max(res.face_landmarks, key=lambda lm: np.ptp([q.x for q in lm]))
            cw, ch = crop.shape[1], crop.shape[0]
            pts = np.float32([[rx0 + q.x * cw / scale, ry0 + q.y * ch / scale] for q in face])
            smooth = pts if smooth is None else 0.55 * smooth + 0.45 * pts
            strength = min(1.0, strength + 0.25)
            hits += 1
        else:
            strength = max(0.0, strength - 0.25)
        out = frame
        if smooth is not None and strength > 0:
            src, dst, size = displacements(smooth, a.slim, a.chin)
            out = warp(frame, src, dst, size, strength)
        if a.preview and n == int(a.preview[0]):
            cv2.imwrite(a.preview[1], np.hstack([frame, out]))
            break
        if writer:
            writer.stdin.write(np.ascontiguousarray(out).tobytes())
        n += 1
    reader.stdout.close(); reader.terminate()
    if writer:
        writer.stdin.close(); writer.wait()
    print(f"{a.inp}: {n} frames, face found in {hits}")


if __name__ == "__main__":
    main()
