#!/usr/bin/env python3
"""Check mathematical statements, exact scope and cumulative provenance."""
from pathlib import Path
import json
import re
import sys

root = Path(__file__).resolve().parent.parent
readme = (root / "README.md").read_text(encoding="utf-8")
palomar = (root / "PALOMAR.md").read_text(encoding="utf-8")
challenge = (root / "Challenge.lean").read_text(encoding="utf-8")
solution = (root / "Solution.lean").read_text(encoding="utf-8")
metadata_text = (root / "formalization.yaml").read_text(encoding="utf-8")
metadata = json.loads(metadata_text)
config_text = (root / "comparator.json").read_text(encoding="utf-8")
config = json.loads(config_text)

issues = []
# Registry-facing scientific statements and metadata do not carry
# repository-development or CI chronology.
history = re.compile(
    r"\b(?:pull requests?|PR\s*#\s*\d+|commits?|branches?|"
    r"GitHub Actions|workflow(?:s)?|CI\s+(?:build|check|run|failure|attempt))\b",
    re.I,
)
for path, content in (
    ("PALOMAR.md", palomar),
    ("formalization.yaml", metadata_text),
    ("Challenge.lean", challenge),
    ("Solution.lean", solution),
    ("comparator.json", config_text),
):
    if history.search(content):
        issues.append(f"{path} contains non-scientific development or CI history")
if "\\`" in palomar:
    issues.append("PALOMAR.md must use unescaped inline code delimiters")
if "this private repository" in palomar.lower():
    issues.append("PALOMAR.md contains stale repository visibility wording")
if "still requires the explicit physical G" in readme:
    issues.append("README contains obsolete final-theorem status")
readme_headers = [
    "## Executive summary",
    "### Plain-language statement",
    "### Formal mathematical statements",
    "## Mathematical question",
    "## Why the result may matter",
    "## Status",
    "## Results acquired — cumulative mathematical ledger",
    "## Mathematical proof architecture",
    "## Repository structure and reproducibility",
    "## Methodology",
]
for item in readme_headers:
    if item not in readme:
        issues.append(f"README is missing {item}")

math_markers = [
    "2t_*^3-8t_*^2-4t_*+1=0",
    "C_3=f(t_*)",
    "nonconvex",
    "Euclidean",
    "Cartesian",
    "5/2",
    "one-source",
    "finite-source",
]
for marker in math_markers:
    if marker not in readme and marker not in palomar:
        issues.append(f"Mathematical narrative missing {marker}")

if re.search(r"Main conjecture.{0,100}not yet proved", readme, re.I | re.S):
    issues.append("README still describes the proved global inequality as a conjecture")
if "Palomar files are placeholders" in readme:
    issues.append("README retains obsolete unselected-Comparator disclaimer")
if re.search(r"\b(?:current|present|active).{0,45}\bPR\s*#\d+", readme + palomar, re.I):
    issues.append("Mathematical documentation must not depend on current PR status")

names = [
    "PalomarNewtonian.scalarMaximum",
    "PalomarNewtonian.globalCubicSensitivityAndOptimality",
]
if config.get("theorem_names") != names:
    issues.append("Comparator must select the exact two principal theorems")
for name in names:
    if f"theorem {name}" not in challenge or f"theorem {name}" not in solution:
        issues.append(f"Challenge/Solution declaration missing: {name}")
    if name not in palomar:
        issues.append(f"Palomar account does not identify {name}")

if not challenge.startswith("module\n") or "public import Mathlib\n" not in challenge:
    issues.append("Challenge must be a Mathlib-only Lean module")
if "import NewtonianLipschitz" in challenge:
    issues.append("Challenge must not import project-specific proofs")
if not solution.startswith("module\n") or "public import NewtonianLipschitz" not in solution:
    issues.append("Solution must import the proof development")
if re.search(r"\b(?:sorry|admit|axiom)\b", solution):
    issues.append("Solution contains a prohibited proof hole or custom axiom")

if metadata.get("version") != "v0.4":
    issues.append("Metadata must use formalization.yaml v0.4")
for field in ("authors", "responsible_maintainers", "description", "license"):
    if not metadata.get("project", {}).get(field):
        issues.append(f"Missing project.{field}")
if not metadata.get("classification", {}).get("arxiv"):
    issues.append("Missing mathematical arXiv classification")
if not metadata.get("sources"):
    issues.append("Missing mathematically grounded result origin")
if metadata.get("review", {}).get("status") not in ("self-assessed", "unchecked", "author-verified"):
    issues.append("Review metadata must reflect actual review status")
if "originality" not in metadata["fidelity"]["divergences"] and "priority" not in metadata["fidelity"]["divergences"]:
    # The origin note and Palomar account may disclose this elsewhere.
    if "priority" not in palomar:
        issues.append("No explicit caution on mathematical priority")

section_start = "## Results acquired — cumulative mathematical ledger"
section_end = "## Mathematical proof architecture"
if section_start in readme and section_end in readme:
    catalog = readme.split(section_start, 1)[1].split(section_end, 1)[0]
    matches = list(re.finditer(r"^### R(\d{3}) — ", catalog, re.M))
    numbers = [int(x.group(1)) for x in matches]
    if numbers != list(range(1, len(numbers) + 1)) or len(numbers) < 48:
        issues.append("Historical mathematical ledger must retain R001–R048 consecutively")
    for idx, match in enumerate(matches):
        nxt = matches[idx + 1].start() if idx + 1 < len(matches) else len(catalog)
        block = catalog[match.end():nxt]
        if not all(tag in block for tag in ("**Why useful:**", "**Limit:**", "**Lean:**")):
            issues.append(f"R{numbers[idx]:03d} missing mathematical scope or evidence")
        if not ("**Source:**" in block or "**Sources:**" in block):
            issues.append(f"R{numbers[idx]:03d} missing source citation")
    if re.search(r"Action\s*#\s*\d+|workflow run|CI failure|CI attempt", catalog, re.I):
        issues.append("Mathematical ledger must not include CI/task chronology")

if issues:
    print("\n".join(issues), file=sys.stderr)
    sys.exit(1)
print("Two mathematical statements, source provenance and R001–R048 ledger audited.")
