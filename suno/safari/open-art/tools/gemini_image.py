"""Generate images with Gemini (Nano Banana Pro) from reference images and a prompt file.

usage: python gemini_image.py --prompt prompt.txt --out out.png --ref a.jpg --ref b.png [--n 2] [--model ...]
"""
import argparse
import os
import sys
import winreg

from google import genai
from google.genai import types
from PIL import Image


def api_key():
    key = os.environ.get("GEMINI_API_KEY") or os.environ.get("GOOGLE_API_KEY")
    if key:
        return key
    try:
        with winreg.OpenKey(winreg.HKEY_CURRENT_USER, "Environment") as k:
            return winreg.QueryValueEx(k, "GEMINI_API_KEY")[0]
    except OSError:
        sys.exit("GEMINI_API_KEY is not set (run: setx GEMINI_API_KEY \"...\")")


def main():
    p = argparse.ArgumentParser()
    p.add_argument("--prompt", required=True)
    p.add_argument("--out", required=True)
    p.add_argument("--ref", action="append", default=[])
    p.add_argument("--n", type=int, default=1)
    p.add_argument("--model", default="gemini-3-pro-image-preview")
    p.add_argument("--aspect", default="9:16")
    p.add_argument("--size", default="2K")
    a = p.parse_args()

    client = genai.Client(api_key=api_key())
    prompt = open(a.prompt, encoding="utf-8").read()
    refs = [Image.open(r) for r in a.ref]
    cfg = types.GenerateContentConfig(
        response_modalities=["TEXT", "IMAGE"],
        image_config=types.ImageConfig(aspect_ratio=a.aspect, image_size=a.size),
    )

    base, ext = os.path.splitext(a.out)
    for i in range(a.n):
        resp = client.models.generate_content(model=a.model, contents=[*refs, prompt], config=cfg)
        saved = False
        for part in resp.candidates[0].content.parts:
            if part.inline_data:
                path = a.out if a.n == 1 else f"{base}-{i + 1}{ext}"
                with open(path, "wb") as f:
                    f.write(part.inline_data.data)
                print("saved", path, Image.open(path).size)
                saved = True
            elif part.text:
                print("model:", part.text.strip()[:300])
        if not saved:
            print("no image returned, finish_reason:", resp.candidates[0].finish_reason)


if __name__ == "__main__":
    main()
