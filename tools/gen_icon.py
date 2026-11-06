"""Generates the NostalPlay app icon: a bold outline handheld in the app's
lime green on its dark ground.

Outputs: assets/icon/icon.png (1024, opaque, square: iOS + legacy Android) and
assets/icon/icon_foreground.png (1024, transparent: Android adaptive layer;
the artwork is scaled to stay inside the central safe zone).
Run: python3 tools/gen_icon.py   (needs Pillow)
"""
from pathlib import Path
from PIL import Image, ImageDraw

NEON = (177, 212, 61)  # app primary #B1D43D
BLACK = (30, 36, 32)  # app ground #1E2420
SS = 4  # supersampling for smooth edges
REF = 1001.0  # artwork coordinates below are in a 1001 px design space


def artwork(scale: float, cx: float, cy: float) -> Image.Image:
    """Returns an RGBA 1024 canvas (transparent) with the handheld drawn.

    `scale` maps design units to output pixels; (cx, cy) is where the design
    centre (500, 500) lands.
    """
    size = 1024 * SS
    img = Image.new("RGBA", (size, size), (0, 0, 0, 0))
    d = ImageDraw.Draw(img)
    k = scale * SS

    def p(x, y):
        return ((cx + (x - 500) * scale) * SS, (cy + (y - 500) * scale) * SS)

    def box(x0, y0, x1, y1):
        a, b = p(x0, y0), p(x1, y1)
        return [a[0], a[1], b[0], b[1]]

    t = 34  # stroke
    # Body: square top corners, rounded bottom corners.
    d.rounded_rectangle(
        box(290, 175, 712, 826), radius=70 * k, fill=NEON,
        corners=(False, False, True, True),
    )
    d.rounded_rectangle(
        box(290 + t, 175 + t, 712 - t, 826 - t), radius=30 * k, fill=(0, 0, 0, 0),
        corners=(False, False, True, True),
    )
    # Screen frame with three diagonal stripes.
    d.rectangle(box(355, 236, 646, 496), fill=NEON)
    inner = Image.new("RGBA", img.size, (0, 0, 0, 0))
    idr = ImageDraw.Draw(inner)
    idr.rectangle(box(355 + t, 236 + t, 646 - t, 496 - t), fill=(0, 0, 0, 255))
    stripes = Image.new("RGBA", img.size, (0, 0, 0, 0))
    sd = ImageDraw.Draw(stripes)
    for c in (745, 870, 995):  # lines x + y = c
        a, b = p(c - 200, 200), p(c - 520, 520)
        sd.line([a, b], fill=NEON, width=int(t * 0.95 * k))
    # Clear the screen interior, then paint stripes clipped to it.
    mask = inner.split()[3]
    img.paste((0, 0, 0, 0), mask=mask)
    clipped = Image.new("RGBA", img.size, (0, 0, 0, 0))
    clipped.paste(stripes, mask=mask)
    img = Image.alpha_composite(img, clipped)
    d = ImageDraw.Draw(img)
    # D-pad.
    d.rectangle(box(340, 577, 466, 577 + t), fill=NEON)
    d.rectangle(box(383, 534, 383 + t, 660), fill=NEON)
    # A / B rings.
    for (x, y) in ((612, 584), (544, 676)):
        r = 54
        d.ellipse(box(x - r, y - r, x + r, y + r), fill=NEON)
        d.ellipse(box(x - r + t, y - r + t, x + r - t, y + r - t), fill=(0, 0, 0, 0))
    # Select / Start dashes.
    d.rectangle(box(338, 712, 394, 712 + t), fill=NEON)
    d.rectangle(box(414, 712, 470, 712 + t), fill=NEON)
    return img.resize((1024, 1024), Image.LANCZOS)


out = Path(__file__).resolve().parent.parent / "assets" / "icon"
out.mkdir(parents=True, exist_ok=True)

s = 1024 / REF
full = Image.new("RGBA", (1024, 1024), BLACK + (255,))
full = Image.alpha_composite(full, artwork(s * 0.98, 512, 512))
full.convert("RGB").save(out / "icon.png")

# Adaptive layer: ~0.86 scale keeps all artwork within the 66% safe zone.
fg = artwork(s * 0.8, 512, 512)
fg.save(out / "icon_foreground.png")
