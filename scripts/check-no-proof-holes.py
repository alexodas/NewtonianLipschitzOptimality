#!/usr/bin/env python3
"""Static substantive-source guard; not a substitute for the Lean kernel."""
from pathlib import Path
import re
import sys

root = Path(__file__).resolve().parent.parent
files = [root / "NewtonianLipschitz.lean", *sorted((root / "NewtonianLipschitz").rglob("*.lean"))]
prohibited = re.compile(r"\b(?:sorry|admit|axiom)\b")
issues = []
for file in files:
    for number, line in enumerate(file.read_text(encoding="utf-8").splitlines(), 1):
        if prohibited.search(line):
            issues.append(f"{file.relative_to(root)}:{number}: prohibited proof token")
if issues:
    print("\n".join(issues), file=sys.stderr)
    sys.exit(1)
print(f"No proof holes found in {len(files)} Lean source files.")
