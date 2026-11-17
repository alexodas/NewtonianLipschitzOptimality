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
    "## Results acquired — cumulative mathematical ledger",
    "### R001 —",
    "### R008 —",
    "### R009 —", "### R010 —",
    "### R011 —", "### R012 —",
    "### R013 —",
    "### R014 —", "### R015 —", "### R016 —", "### R017 —",
    "## Direct proof strategy",
    "M01 — Foundation", "M02 — Jacobian reduction", "M03 — Sharp upper bound",
    "M04 — Optimality", "M05 — Domain theorem", "M06 — Scientific and archival validation",
    "## Roadmap",
    "## Repository structure and reproducibility",
    "## Methodology",
    "Alessandro Odasso",
    "not a mathematician",
    "large language models (LLMs)",
    "not yet Lean-verified theorems",
    "nonconvex exterior of a cube",
    "independent kernel checking",
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
# The acquired-results section is a cumulative mathematical catalog.
# It must never be turned into an activity log or silently renumbered.
import re
section_start = "## Results acquired — cumulative mathematical ledger"
section_end = "## Direct proof strategy"
if section_start in readme and section_end in readme:
    catalog = readme.split(section_start, 1)[1].split(section_end, 1)[0]
    matches = list(re.finditer(r"^### R(\d{3}) — ", catalog, re.M))
    numbers = [int(m.group(1)) for m in matches]
    if numbers != list(range(1, len(numbers) + 1)) or len(numbers) < 17:
        issues.append("Results must be cumulative, contiguous, and retain R001–R017")
    for idx, match in enumerate(matches):
        block = catalog[match.end():matches[idx+1].start() if idx+1 < len(matches) else len(catalog)]
        if not all(tag in block for tag in ("**Why useful:**", "**Limit:**", "**Lean:**")):
            issues.append(f"Result R{numbers[idx]:03d} missing statement/use/limit/Lean evidence")
        if not ("**Source:**" in block or "**Sources:**" in block):
            issues.append(f"Result R{numbers[idx]:03d} missing exact source link")
    if re.search(r"Action\s*#\s*\d+|workflow run|CI failure|CI attempt", catalog, re.I):
        issues.append("Acquired results must not contain build or task chronology")
if "LeanAsteroidPairs" in readme:
    issues.append("New project README must be scientifically self-contained")
if issues:
    print("\n".join(issues), file=sys.stderr)
    sys.exit(1)
print("README research scope, uncertainty and provenance verified.")
