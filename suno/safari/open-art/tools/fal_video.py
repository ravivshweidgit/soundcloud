"""Image-to-video on fal.ai (Kling 3.0 Pro by default), with an optional end frame.

usage:
  python fal_video.py --prompt prompt.txt --first start.png --out out.mp4 [--last end.png] [--duration 3] [--model ...]

Needs FAL_KEY (run once: setx FAL_KEY "...").
"""
import argparse
import os
import sys
import threading
import urllib.request
import winreg

import fal_client


def fal_key():
    key = os.environ.get("FAL_KEY")
    if not key:
        try:
            with winreg.OpenKey(winreg.HKEY_CURRENT_USER, "Environment") as k:
                key = winreg.QueryValueEx(k, "FAL_KEY")[0]
        except OSError:
            sys.exit("FAL_KEY is not set (run: setx FAL_KEY \"...\")")
    os.environ["FAL_KEY"] = key


def main():
    p = argparse.ArgumentParser()
    p.add_argument("--prompt", required=True)
    p.add_argument("--first", required=True)
    p.add_argument("--last")
    p.add_argument("--out", required=True)
    p.add_argument("--duration", default="3")
    p.add_argument("--model", default="fal-ai/kling-video/v3/pro/image-to-video")
    p.add_argument("--negative", default="blur, distort, low quality, extra people, extra animals, cut, scene change")
    p.add_argument("--no-audio", action="store_true")
    p.add_argument("--timeout", type=int, default=600, help="seconds before giving up on the request")
    a = p.parse_args()

    def give_up():
        print(f"no answer from {a.model} after {a.timeout} s, giving up", flush=True)
        os._exit(2)

    threading.Timer(a.timeout, give_up).start()
    fal_key()
    args = {
        "prompt": open(a.prompt, encoding="utf-8").read().strip(),
        "start_image_url": fal_client.upload_file(a.first),
        "duration": str(a.duration),
        "generate_audio": not a.no_audio,
        "negative_prompt": a.negative,
    }
    if a.last:
        args["end_image_url"] = fal_client.upload_file(a.last)

    def log(update):
        if isinstance(update, fal_client.InProgress):
            for entry in update.logs or []:
                print(entry["message"], flush=True)

    result = fal_client.subscribe(a.model, arguments=args, with_logs=True, on_queue_update=log)
    urllib.request.urlretrieve(result["video"]["url"], a.out)
    print("saved", a.out)
    os._exit(0)


if __name__ == "__main__":
    main()
