"""Image-to-video and video editing with Gemini Omni Flash (Interactions API).

usage:
  python gemini_video.py --prompt prompt.txt --first start.png --out out.mp4 [--ref face.jpg ...] [--aspect 9:16] [--resolution 720p]
  python gemini_video.py --prompt prompt.txt --edit clip.mp4 --out out.mp4 [--ref face.jpg]

With --ref, the prompt should declare roles, e.g.
[# Sources <FIRST_FRAME>@Image1] [# References <IMAGE_REF_0>@Image2 <IMAGE_REF_1>@Image3] ...
--edit takes a clip of 10 s or less.
"""
import argparse
import base64
import mimetypes
import os
import threading
import time

from google import genai

from gemini_image import api_key


def upload_video(client, path):
    f = client.files.upload(file=path)
    while f.state == "PROCESSING":
        time.sleep(3)
        f = client.files.get(name=f.name)
    if f.state == "FAILED":
        raise SystemExit(f"upload failed: {path}")
    return {"type": "video", "uri": f.uri}


def main():
    p = argparse.ArgumentParser()
    p.add_argument("--prompt", required=True)
    src = p.add_mutually_exclusive_group(required=True)
    src.add_argument("--first")
    src.add_argument("--edit")
    p.add_argument("--out", required=True)
    p.add_argument("--ref", action="append", default=[])
    p.add_argument("--model", default="gemini-omni-1.1-flash")
    p.add_argument("--aspect", default="9:16")
    p.add_argument("--resolution", default="720p")
    p.add_argument("--timeout", type=int, default=300, help="seconds before giving up on the request")
    a = p.parse_args()

    def give_up():
        print(f"no answer from {a.model} after {a.timeout} s, giving up", flush=True)
        os._exit(2)

    threading.Timer(a.timeout, give_up).start()
    client = genai.Client(api_key=api_key(), http_options={"timeout": a.timeout * 1000})
    media = [upload_video(client, a.edit)] if a.edit else []
    for path in ([a.first] if a.first else []) + a.ref:
        with open(path, "rb") as f:
            data = base64.b64encode(f.read()).decode()
        media.append({"type": "image", "data": data, "mime_type": mimetypes.guess_type(path)[0] or "image/png"})

    interaction = client.interactions.create(
        model=a.model,
        input=[*media, {"type": "text", "text": open(a.prompt, encoding="utf-8").read().strip()}],
        generation_config={"video_config": {"task": "edit" if a.edit else "image_to_video"}},
        response_format={"type": "video", "resolution": a.resolution} if a.edit
        else {"type": "video", "aspect_ratio": a.aspect, "resolution": a.resolution},
    )
    with open(a.out, "wb") as f:
        f.write(base64.b64decode(interaction.output_video.data))
    print("saved", a.out)
    os._exit(0)


if __name__ == "__main__":
    main()
