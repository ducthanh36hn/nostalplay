#!/usr/bin/env python3
"""Generates the 8-bit sound effects in assets/audio/ (original, no samples).

Run from the repo root:  python3 tools/gen_sfx.py
"""
import math
import struct
import wave
from pathlib import Path

RATE = 22050
OUT = Path(__file__).resolve().parent.parent / "assets" / "audio"


def tone(freq, ms, volume=0.28, duty=0.5):
    """Square wave with a short linear decay so notes do not click."""
    n = int(RATE * ms / 1000)
    samples = []
    for i in range(n):
        phase = (i * freq / RATE) % 1.0
        v = volume if phase < duty else -volume
        fade = min(1.0, (n - i) / (RATE * 0.012))  # 12 ms release
        samples.append(v * fade)
    return samples


def rest(ms):
    return [0.0] * int(RATE * ms / 1000)


def save(name, parts):
    data = [s for p in parts for s in p]
    path = OUT / name
    with wave.open(str(path), "wb") as w:
        w.setnchannels(1)
        w.setsampwidth(2)
        w.setframerate(RATE)
        w.writeframes(b"".join(struct.pack("<h", int(max(-1, min(1, s)) * 32767)) for s in data))
    print(path.name, f"{len(data) / RATE * 1000:.0f} ms")


def main():
    OUT.mkdir(parents=True, exist_ok=True)
    # Eat: quick rising blip.
    save("eat.wav", [tone(880, 45), tone(1320, 70)])
    # Game over: falling four notes.
    save("game_over.wav", [tone(392, 130, duty=0.25), tone(330, 130, duty=0.25),
                           tone(262, 130, duty=0.25), tone(196, 320, duty=0.25)])
    # New record: rising arpeggio with a held top note.
    save("new_record.wav", [tone(523, 90), tone(659, 90), tone(784, 90),
                            tone(1047, 90), rest(30), tone(1047, 260)])


if __name__ == "__main__":
    main()
