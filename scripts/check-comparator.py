#!/usr/bin/env python3
"""Validate the exact two-theorem Palomar Comparator declaration surface."""
from pathlib import Path
import json
import sys

root = Path(__file__).resolve().parent.parent
config = json.loads((root / "comparator.json").read_text(encoding="utf-8"))
required = {"challenge_module", "solution_module", "theorem_names", "definition_names", "permitted_axioms"}
if set(config) != required:
    raise SystemExit(f"Unexpected Comparator configuration keys: {sorted(set(config) ^ required)}")
if config["challenge_module"] != "Challenge" or config["solution_module"] != "Solution":
    raise SystemExit("Invalid Comparator source modules")
if config["permitted_axioms"] != ["propext", "Quot.sound", "Classical.choice"]:
    raise SystemExit("Unexpected Comparator axioms")
if config["definition_names"] != []:
    raise SystemExit("All compared targets must be theorem declarations")
expected = [
    "PalomarNewtonian.scalarMaximum",
    "PalomarNewtonian.globalCubicSensitivityAndOptimality",
]
if config["theorem_names"] != expected:
    raise SystemExit("Comparator must select exactly the scalar and physical global theorems")
for path in ("Challenge.lean", "Solution.lean"):
    text = (root / path).read_text(encoding="utf-8")
    for name in expected:
        if f"theorem {name}" not in text:
            raise SystemExit(f"{path}: missing selected declaration {name}")
challenge = (root / "Challenge.lean").read_text(encoding="utf-8")
if "import Mathlib" not in challenge or "import NewtonianLipschitz" in challenge:
    raise SystemExit("The Challenge must import Mathlib without project-specific imports")
solution = (root / "Solution.lean").read_text(encoding="utf-8")
if "sorry" in solution or "admit" in solution:
    raise SystemExit("The Solution must have no proof holes")
print("Comparator configuration selects exactly two independently stated theorems.")
