#!/usr/bin/env python3
"""
extract_colors.py — Extract N dominant colors from an image.
Usage: python3 extract_colors.py <image_path> [count=4]
Prints one hex color per line, e.g. #a3c4bc
"""

import sys
import math
from PIL import Image


def rgb_to_hex(r, g, b):
    return "#{:02x}{:02x}{:02x}".format(r, g, b)


def color_distance(c1, c2):
    return math.sqrt(sum((a - b) ** 2 for a, b in zip(c1, c2)))


def kmeans(pixels, k=4, iterations=10):
    import random
    # seed centroids from spread-out pixels
    centroids = random.sample(pixels, k)
    for _ in range(iterations):
        clusters = [[] for _ in range(k)]
        for p in pixels:
            idx = min(range(k), key=lambda i: color_distance(p, centroids[i]))
            clusters[idx].append(p)
        new_centroids = []
        for i, cluster in enumerate(clusters):
            if cluster:
                avg = tuple(int(sum(c[ch] for c in cluster) / len(cluster)) for ch in range(3))
                new_centroids.append(avg)
            else:
                new_centroids.append(centroids[i])
        if new_centroids == centroids:
            break
        centroids = new_centroids
    # sort by cluster size (most dominant first)
    sizes = [len(c) for c in clusters]
    order = sorted(range(k), key=lambda i: sizes[i], reverse=True)
    return [centroids[i] for i in order]


def main():
    if len(sys.argv) < 2:
        print("Usage: extract_colors.py <image> [count]", file=sys.stderr)
        sys.exit(1)

    path = sys.argv[1]
    count = int(sys.argv[2]) if len(sys.argv) > 2 else 4

    img = Image.open(path).convert("RGB")
    # downsample for speed
    img.thumbnail((150, 150), Image.LANCZOS)
    pixels = list(img.getdata())

    # filter near-black and near-white
    filtered = [
        p for p in pixels
        if not (p[0] < 20 and p[1] < 20 and p[2] < 20)
        and not (p[0] > 235 and p[1] > 235 and p[2] > 235)
    ]
    if len(filtered) < count:
        filtered = pixels

    colors = kmeans(filtered, k=count)
    for c in colors:
        print(rgb_to_hex(*c))


if __name__ == "__main__":
    main()