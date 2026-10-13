"""Image-to-video with Veo 3.1.

usage:
  python veo_video.py --prompt prompt.txt --first start.png --out out.mp4 [--last end.png] [--aspect 9:16] [--resolution 720p] [--seconds 4]
"""
import argparse
import mimetypes
import time

from google import genai
from google.genai import types

from gemini_image import api_key


def image(path):
    with open(path, "rb") as f:
        return types.Image(image_bytes=f.read(), mime_type=mimetypes.guess_type(path)[0] or "image/png")


def main():
    p = argparse.ArgumentParser()
    p.add_argument("--prompt", required=True)
    p.add_argument("--first", required=True)
    p.add_argument("--last")
    p.add_argument("--out", required=True)
    p.add_argument("--model", default="veo-3.1-generate-preview")
    p.add_argument("--aspect", default="9:16")
    p.add_argument("--resolution", default="720p")
    p.add_argument("--seconds", type=int, default=4)
    a = p.parse_args()

    client = genai.Client(api_key=api_key())
    op = client.models.generate_videos(
        model=a.model,
        prompt=open(a.prompt, encoding="utf-8").read().strip(),
        image=image(a.first),
        config=types.GenerateVideosConfig(
            aspect_ratio=a.aspect,
            resolution=a.resolution,
            duration_seconds=a.seconds,
            last_frame=image(a.last) if a.last else None,
        ),
    )
    while not op.done:
        time.sleep(10)
        op = client.operations.get(op)
    if not op.response or not op.response.generated_videos:
        raise SystemExit(f"no video: {op.error or op.response}")
    video = op.response.generated_videos[0].video
    client.files.download(file=video)
    video.save(a.out)
    print("saved", a.out)


if __name__ == "__main__":
    main()
