"""Generates the NostalPlay app icon (original artwork, no third-party assets).

Outputs: assets/icon/icon.png (1024, opaque, square: iOS + legacy Android) and
assets/icon/icon_foreground.png (1024, transparent: Android adaptive layer).
Run: python3 tools/gen_icon.py   (needs Pillow)
"""
from pathlib import Path
from PIL import Image, ImageDraw

GROUND = (30, 36, 32)
LCD_LIGHT = (155, 188, 15)
LCD_DARK = (15, 56, 15)
LCD_MID = (48, 98, 48)
CRIMSON = (155, 35, 53)
N = 7
SNAKE = [(0, 4), (1, 4), (2, 4), (3, 4), (3, 3), (3, 2), (4, 2), (5, 2)]
APPLE = (6, 4)


def panel(d: ImageDraw.ImageDraw, cx: int, cy: int, size: int) -> None:
    half = size // 2
    x0, y0 = cx - half, cy - half
    border = size // 24
    d.rectangle([x0, y0, x0 + size, y0 + size], fill=LCD_DARK)
    d.rectangle([x0 + border, y0 + border, x0 + size - border, y0 + size - border], fill=LCD_LIGHT)
    inner = size - 2 * border
    cell = inner / N
    gap = max(2, round(cell * 0.08))
    ox, oy = x0 + border, y0 + border

    def block(c, color):
        bx, by = ox + c[0] * cell, oy + c[1] * cell
        d.rectangle([bx + gap, by + gap, bx + cell - gap, by + cell - gap], fill=color)

    for i, c in enumerate(SNAKE):
        block(c, LCD_DARK)
    block(APPLE, CRIMSON)


def make(path: Path, transparent: bool, size: int) -> None:
    img = Image.new("RGBA", (1024, 1024), (0, 0, 0, 0) if transparent else GROUND + (255,))
    panel(ImageDraw.Draw(img), 512, 512, size)
    if not transparent:
        img = img.convert("RGB")
    img.save(path)


out = Path(__file__).resolve().parent.parent / "assets" / "icon"
out.mkdir(parents=True, exist_ok=True)
make(out / "icon.png", False, 640)
# Adaptive layer: keep the artwork inside the central 66% safe zone.
make(out / "icon_foreground.png", True, 560)
