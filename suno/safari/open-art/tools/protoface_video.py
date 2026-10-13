"""Image-to-video through the Protoface API (LTX 2.5, Seedance, Kling, ...).

usage:
  python protoface_video.py models [--filter ltx]
  python protoface_video.py model lightricks/ltx-2.5-fast
  python protoface_video.py run MODEL_ID --prompt prompt.txt --first start.png --out out.mp4 [--last end.png] [--param duration_seconds=6 ...]
"""
import argparse
import base64
import json
import mimetypes
import os
import sys
import time
import urllib.error
import urllib.request
import winreg

API = os.environ.get("PROTOFACE_API_URL", "https://api.protoface.com")


def api_key():
    key = os.environ.get("PROTOFACE_API_KEY")
    if key:
        return key
    try:
        with winreg.OpenKey(winreg.HKEY_CURRENT_USER, "Environment") as k:
            return winreg.QueryValueEx(k, "PROTOFACE_API_KEY")[0]
    except OSError:
        sys.exit("PROTOFACE_API_KEY is not set (run: setx PROTOFACE_API_KEY \"...\")")


def call(method, path, body=None):
    req = urllib.request.Request(
        API + path,
        method=method,
        data=json.dumps(body).encode() if body is not None else None,
        headers={"Authorization": f"Bearer {api_key()}", "Content-Type": "application/json"},
    )
    try:
        with urllib.request.urlopen(req, timeout=120) as r:
            return json.load(r)
    except urllib.error.HTTPError as e:
        sys.exit(f"{e.code} {method} {path}: {e.read().decode(errors='replace')}")


def data_uri(path):
    mime = mimetypes.guess_type(path)[0] or "image/png"
    with open(path, "rb") as f:
        return f"data:{mime};base64,{base64.b64encode(f.read()).decode()}"


def parse_value(v):
    try:
        return json.loads(v)
    except ValueError:
        return v


def main():
    sys.stdout.reconfigure(line_buffering=True)
    p = argparse.ArgumentParser()
    sub = p.add_subparsers(dest="cmd", required=True)
    m = sub.add_parser("models")
    m.add_argument("--filter", default="")
    one = sub.add_parser("model")
    one.add_argument("model_id")
    r = sub.add_parser("run")
    r.add_argument("model_id")
    r.add_argument("--prompt", required=True)
    r.add_argument("--first", required=True)
    r.add_argument("--last")
    r.add_argument("--out", required=True)
    r.add_argument("--first-field", default="image_url", help="LTX: image_url, Seedance/MiniMax: first_frame")
    r.add_argument("--last-field", default="last_image_url")
    r.add_argument("--param", action="append", default=[], help="key=value, value parsed as JSON when possible")
    a = p.parse_args()

    if a.cmd == "models":
        for md in call("GET", "/v1/models").get("data", []):
            if a.filter.lower() in json.dumps(md).lower():
                print(md["id"], "|", md.get("display_name", ""), "|", ",".join(md.get("output_modalities", [])))
        return
    if a.cmd == "model":
        print(json.dumps(call("GET", f"/v1/models/{a.model_id}"), indent=2))
        return

    body = {"prompt": open(a.prompt, encoding="utf-8").read().strip(), a.first_field: data_uri(a.first)}
    if a.last:
        body[a.last_field] = data_uri(a.last)
    for kv in a.param:
        k, v = kv.split("=", 1)
        body[k] = parse_value(v)

    run = call("POST", f"/v1/run/{a.model_id}", body)
    print("run", run["id"], run.get("status"))
    while run.get("status") not in ("completed", "failed", "canceled", "cancelled"):
        time.sleep(5)
        run = call("GET", f"/v1/runs/{run['id']}")
        print(" ", run.get("status"))
    if run["status"] != "completed":
        sys.exit(f"run {run['status']}: {json.dumps(run.get('error'))}")

    urllib.request.urlretrieve(run["video"]["url"], a.out)
    print("saved", a.out, "credits", json.dumps(run.get("credits")))


if __name__ == "__main__":
    main()
