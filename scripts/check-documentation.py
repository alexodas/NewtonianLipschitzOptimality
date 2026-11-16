#!/usr/bin/env python3
"""Audit declared goals and provenance without claiming unproved results."""
from pathlib import Path
import sys

root = Path(__file__).resolve().parent.parent
readme = (root / "README.md").read_text(encoding="utf-8")
required = [
    "## Executive summary",
    "## Mathematical question",
    "## Why the result may matter — intended audience",
    "CAPD", "VNODE-LP", "COSY Infinity",
    "Planetary defense", "space situational awareness",
    "Barnes–Hut", "does not itself certify a collision probability",
    "## Results acquired and verification status",
    "## Roadmap",
    "## Repository structure and reproducibility",
    "## Methodology",
    "Alessandro Odasso",
    "not a mathematician",
    "large language models (LLMs)",
    "not yet Lean-verified theorems",
    "nonconvex exterior of a cube",
    "independently kernel-checked",
    "Palomar files are placeholders",
]
issues = [f"README missing: {token}" for token in required if token not in readme]
palomar_notes = (root / "PALOMAR.md").read_text(encoding="utf-8")
if "not a submitted formalization" not in palomar_notes:
    issues.append("PALOMAR.md must explicitly disclose placeholder status")
description = __import__("json").loads(
    (root / "formalization.yaml").read_text(encoding="utf-8")
)["project"]["description"]
for audience in ("rigorous dynamics", "planetary-defense", "space situational awareness", "Cartesian N-body"):
    if audience not in description:
        issues.append(f"Metadata description missing potential audience: {audience}")
for audience in ("CAPD", "planetary defense", "space situational awareness", "Barnes–Hut"):
    if audience not in palomar_notes:
        issues.append(f"PALOMAR.md missing potential audience: {audience}")
if "LeanAsteroidPairs" in readme:
    issues.append("New project README must be scientifically self-contained")
if issues:
    print("\n".join(issues), file=sys.stderr)
    sys.exit(1)
print("README research scope, uncertainty and provenance verified.")
