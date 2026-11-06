"""Generates the NostalPlay app icon: a neon-green outline handheld on black.

Outputs: assets/icon/icon.png (1024, opaque, square: iOS + legacy Android) and
assets/icon/icon_foreground.png (1024, transparent: Android adaptive layer;
the artwork is scaled to stay inside the central safe zone).
Run: python3 tools/gen_icon.py   (needs Pillow)
"""
from pathlib import Path
from PIL import Image, ImageDraw

NEON = (102, 255, 0)
BLACK = (0, 0, 0)
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

    t = 22  # stroke
    # Body: square top corners, rounded bottom corners.
    d.rounded_rectangle(
        box(290, 175, 712, 826), radius=62 * k, fill=NEON,
        corners=(False, False, True, True),
    )
    d.rounded_rectangle(
        box(290 + t, 175 + t, 712 - t, 826 - t), radius=40 * k, fill=(0, 0, 0, 0),
        corners=(False, False, True, True),
    )
    # Screen frame with three diagonal stripes.
    d.rectangle(box(360, 241, 641, 491), fill=NEON)
    inner = Image.new("RGBA", img.size, (0, 0, 0, 0))
    idr = ImageDraw.Draw(inner)
    idr.rectangle(box(360 + t, 241 + t, 641 - t, 491 - t), fill=(0, 0, 0, 255))
    stripes = Image.new("RGBA", img.size, (0, 0, 0, 0))
    sd = ImageDraw.Draw(stripes)
    for c in (725, 860, 990):  # lines x + y = c
        a, b = p(c - 200, 200), p(c - 520, 520)
        sd.line([a, b], fill=NEON, width=int(t * 1.25 * k))
    # Clear the screen interior, then paint stripes clipped to it.
    mask = inner.split()[3]
    img.paste((0, 0, 0, 0), mask=mask)
    clipped = Image.new("RGBA", img.size, (0, 0, 0, 0))
    clipped.paste(stripes, mask=mask)
    img = Image.alpha_composite(img, clipped)
    d = ImageDraw.Draw(img)
    # D-pad.
    d.rectangle(box(347, 586, 457, 608), fill=NEON)
    d.rectangle(box(391, 542, 413, 652), fill=NEON)
    # A / B rings.
    for (x, y) in ((616, 597), (553, 672)):
        d.ellipse(box(x - 43, y - 43, x + 43, y + 43), fill=NEON)
        d.ellipse(box(x - 21, y - 21, x + 21, y + 21), fill=(0, 0, 0, 0))
    # Select / Start dashes.
    d.rectangle(box(342, 717, 400, 740), fill=NEON)
    d.rectangle(box(420, 717, 475, 740), fill=NEON)
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
