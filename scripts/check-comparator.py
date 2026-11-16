#!/usr/bin/env python3
"""Refuse claims of an active independent Comparator with an empty selection."""
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
if config["definition_names"]:
    raise SystemExit("Definitions must not be exempted from kernel comparison")
if "--require-selected" in sys.argv and not config["theorem_names"]:
    raise SystemExit("No selected theorem: independent Comparator is not runnable yet")
if config["theorem_names"]:
    raise SystemExit("Target selected: update the provisional repository and metadata guards before running")
print("Comparator configuration is an unselected, explicitly disabled placeholder.")
