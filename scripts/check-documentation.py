#!/usr/bin/env python3
"""Audit declared goals and provenance without claiming unproved results."""
from pathlib import Path
import sys

root = Path(__file__).resolve().parent.parent
readme = (root / "README.md").read_text(encoding="utf-8")
required = [
    "## Executive summary",
    "## Mathematical question",
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
]
issues = [f"README missing: {token}" for token in required if token not in readme]
if "LeanAsteroidPairs" in readme:
    issues.append("New project README must be scientifically self-contained")
if issues:
    print("\n".join(issues), file=sys.stderr)
    sys.exit(1)
print("README research scope, uncertainty and provenance verified.")
