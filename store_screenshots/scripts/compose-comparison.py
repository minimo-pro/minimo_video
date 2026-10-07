"""Builds public/brand/compare.png: split before/after frame like the in-app VS view."""
from pathlib import Path
from PIL import Image, ImageDraw, ImageFont

ROOT = Path(__file__).resolve().parents[1] / "public"
W, H = 1600, 1200
photo = Image.open(ROOT / "photos/beach.jpg").convert("RGB")
scale = max(W / photo.width, H / photo.height)
photo = photo.resize((round(photo.width * scale), round(photo.height * scale)), Image.LANCZOS)
left = (photo.width - W) // 2
frame = photo.crop((left, 0, left + W, H))

draw = ImageDraw.Draw(frame, "RGBA")
draw.rectangle((W // 2 - 4, 0, W // 2 + 4, H), fill=(255, 255, 255, 255))
font = ImageFont.truetype(str(ROOT / "fonts/Pangolin-Regular.ttf"), 64)

def pill(text, x, y, anchor_right=False):
    box = draw.textbbox((0, 0), text, font=font)
    tw, th = box[2] - box[0], box[3] - box[1]
    pw, ph = tw + 64, th + 44
    x0 = x - pw if anchor_right else x
    draw.rounded_rectangle((x0, y, x0 + pw, y + ph), radius=ph // 2, fill=(0, 0, 0, 150))
    draw.text((x0 + 32 - box[0], y + 22 - box[1]), text, font=font, fill="white")

pill("before · 612 mb", 40, 40)
pill("after · 153 mb", W - 40, 40, anchor_right=True)

r = 92
cx, cy = W // 2, H // 2
draw.ellipse((cx - r, cy - r, cx + r, cy + r), fill=(252, 54, 54, 255), outline="white", width=8)
vs = ImageFont.truetype(str(ROOT / "fonts/Pangolin-Regular.ttf"), 92)
b = draw.textbbox((0, 0), "VS", font=vs)
draw.text((cx - (b[2] + b[0]) / 2, cy - (b[3] + b[1]) / 2), "VS", font=vs, fill="white")
frame.save(ROOT / "brand/compare.png")
print("ok", frame.size)
