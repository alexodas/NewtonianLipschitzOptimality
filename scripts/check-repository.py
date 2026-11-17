#!/usr/bin/env python3
"""Check pinned dependencies and source layout; Lean build is authoritative."""
from pathlib import Path
import json
import re
import sys
import tomllib

root = Path(__file__).resolve().parent.parent
issues = []
needed = [
    "lean-toolchain", "lakefile.toml", "lake-manifest.json", "LICENSE",
    "README.md", "NewtonianLipschitz.lean",
    "NewtonianLipschitz/Basic.lean", "NewtonianLipschitz/Field.lean",
    "NewtonianLipschitz/Smoothness.lean", "NewtonianLipschitz/Norms.lean",
    "NewtonianLipschitz/Derivative.lean", "NewtonianLipschitz/FiniteSources.lean",
    "NewtonianLipschitz/Clearance.lean", "NewtonianLipschitz/CubicCandidate.lean",
    "NewtonianLipschitz/ScalarMaximum.lean",
    "NewtonianLipschitz/NormalizedSharpBound.lean",
    "NewtonianLipschitz/JacobianSymmetries.lean",
    "NewtonianLipschitz/JacobianPermutations.lean",
    "NewtonianLipschitz/JacobianNormalization.lean",
    "NewtonianLipschitz/JacobianAxisBounds.lean",
    "NewtonianLipschitz/JacobianSignedBounds.lean",
    "NewtonianLipschitz/JacobianCartesianBound.lean",
    "NewtonianLipschitz/JacobianOperatorAction.lean",
    "NewtonianLipschitz/JacobianOperatorNorm.lean",
    "NewtonianLipschitz/JacobianSharpWitness.lean",
    "NewtonianLipschitz/JacobianOperatorWitness.lean",
    "NewtonianLipschitz/ConvexSharp.lean",
    "NewtonianLipschitz/CartesianBoxSharp.lean",
    "NewtonianLipschitz/DerivativeCoefficientMinimality.lean",
    "NewtonianLipschitz/DerivativeAttainingDirection.lean",
    "NewtonianLipschitz/AdmissibleCriticalDirection.lean",
    "NewtonianLipschitz/AdmissibleSecantPairs.lean",
    "NewtonianLipschitz/LongSeparation.lean",
    "NewtonianLipschitz/CommonSafeFace.lean",
    "NewtonianLipschitz/CrossFaceTwoHop.lean",
    "NewtonianLipschitz/TangentialAlgebra.lean",
    "NewtonianLipschitz/ConditionalFiniteSource.lean",
    "NewtonianLipschitz/SafePlaneReduction.lean",
    "NewtonianLipschitz/PhysicalTangentialNormalized.lean",
    "NewtonianLipschitz/PhysicalTangentialFirstAxis.lean",
    "NewtonianLipschitz/PhysicalTangentialAllAxes.lean",
    "NewtonianLipschitz/SafePlaneFiniteDifference.lean",
    "NewtonianLipschitz/UnconditionalFiniteSource.lean",
    "NewtonianLipschitz/BaselineBounds.lean", "NewtonianLipschitz/ConvexBaseline.lean",
    "NewtonianLipschitz/ImprovedBounds.lean", "NewtonianLipschitz/ConvexImproved.lean",
    "NewtonianLipschitz/JacobianRows.lean",
    "NewtonianLipschitz/JacobianMatrix.lean",
    "Challenge.lean", "Solution.lean", "comparator.json",
    "formalization.yaml", "PALOMAR.md", ".github/workflows/comparator.yml",
    "scripts/verify-comparator.sh", "scripts/check-comparator.py",
    ".github/workflows/lean.yml",
]
for rel in needed:
    if not (root / rel).is_file():
        issues.append(f"Missing required file: {rel}")

if (root / "lean-toolchain").read_text(encoding="utf-8").strip() != "leanprover/lean4:v4.35.0":
    issues.append("Unexpected Lean version")

with (root / "lakefile.toml").open("rb") as file:
    config = tomllib.load(file)
manifest = json.loads((root / "lake-manifest.json").read_text(encoding="utf-8"))
if config.get("name") != "NewtonianLipschitzOptimality":
    issues.append("Unexpected Lake package name")
if config.get("defaultTargets") != ["NewtonianLipschitz"]:
    issues.append("Unexpected default build target")
libraries = config.get("lean_lib", [])
if [lib.get("name") for lib in libraries] != ["NewtonianLipschitz", "Challenge", "Solution"]:
    issues.append("Unexpected Lean libraries")
req = [pkg for pkg in config.get("require", []) if pkg.get("name") == "mathlib"]
locked = [pkg for pkg in manifest.get("packages", []) if pkg.get("name") == "mathlib"]
if len(req) != 1 or len(locked) != 1 or req[0].get("rev") != locked[0].get("rev"):
    issues.append("Mathlib revision mismatch between Lake and manifest")
if manifest.get("name") != config.get("name"):
    issues.append("Manifest package name mismatch")

expected_imports = {
    "NewtonianLipschitz.lean": [
        "NewtonianLipschitz.Derivative", "NewtonianLipschitz.Clearance",
        "NewtonianLipschitz.FiniteSources", "NewtonianLipschitz.CubicCandidate", "NewtonianLipschitz.ScalarMaximum", "NewtonianLipschitz.NormalizedSharpBound", "NewtonianLipschitz.JacobianSymmetries", "NewtonianLipschitz.JacobianPermutations", "NewtonianLipschitz.JacobianNormalization", "NewtonianLipschitz.JacobianAxisBounds", "NewtonianLipschitz.JacobianSignedBounds", "NewtonianLipschitz.JacobianCartesianBound", "NewtonianLipschitz.JacobianOperatorAction", "NewtonianLipschitz.JacobianOperatorNorm", "NewtonianLipschitz.JacobianSharpWitness", "NewtonianLipschitz.JacobianOperatorWitness", "NewtonianLipschitz.ConvexSharp", "NewtonianLipschitz.CartesianBoxSharp", "NewtonianLipschitz.DerivativeCoefficientMinimality", "NewtonianLipschitz.DerivativeAttainingDirection", "NewtonianLipschitz.AdmissibleCriticalDirection", "NewtonianLipschitz.AdmissibleSecantPairs", "NewtonianLipschitz.LongSeparation", "NewtonianLipschitz.CommonSafeFace", "NewtonianLipschitz.CrossFaceTwoHop", "NewtonianLipschitz.TangentialAlgebra", "NewtonianLipschitz.ConditionalFiniteSource", "NewtonianLipschitz.SafePlaneReduction", "NewtonianLipschitz.PhysicalTangentialNormalized", "NewtonianLipschitz.PhysicalTangentialFirstAxis", "NewtonianLipschitz.PhysicalTangentialAllAxes", "NewtonianLipschitz.SafePlaneFiniteDifference", "NewtonianLipschitz.UnconditionalFiniteSource", "NewtonianLipschitz.ConvexBaseline",
        "NewtonianLipschitz.ConvexImproved", "NewtonianLipschitz.JacobianRows",
        "NewtonianLipschitz.JacobianMatrix",
    ],
    "NewtonianLipschitz/Basic.lean": ["Mathlib"],
    "NewtonianLipschitz/Field.lean": ["NewtonianLipschitz.Basic"],
    "NewtonianLipschitz/Smoothness.lean": ["NewtonianLipschitz.Field"],
    "NewtonianLipschitz/Norms.lean": ["NewtonianLipschitz.Basic"],
    "NewtonianLipschitz/Derivative.lean": [
        "NewtonianLipschitz.Smoothness", "NewtonianLipschitz.Norms"
    ],
    "NewtonianLipschitz/Clearance.lean": ["NewtonianLipschitz.Norms"],
    "NewtonianLipschitz/FiniteSources.lean": ["NewtonianLipschitz.Field"],
    "NewtonianLipschitz/CubicCandidate.lean": ["Mathlib"],
    "NewtonianLipschitz/ScalarMaximum.lean": ["NewtonianLipschitz.CubicCandidate"],
    "NewtonianLipschitz/NormalizedSharpBound.lean": [
        "NewtonianLipschitz.JacobianMatrix", "NewtonianLipschitz.ScalarMaximum"
    ],
    "NewtonianLipschitz/JacobianSymmetries.lean": [
        "NewtonianLipschitz.NormalizedSharpBound"
    ],
    "NewtonianLipschitz/JacobianPermutations.lean": [
        "NewtonianLipschitz.JacobianSymmetries"
    ],
    "NewtonianLipschitz/JacobianNormalization.lean": [
        "NewtonianLipschitz.JacobianPermutations"
    ],
    "NewtonianLipschitz/JacobianAxisBounds.lean": [
        "NewtonianLipschitz.JacobianNormalization"
    ],
    "NewtonianLipschitz/JacobianSignedBounds.lean": [
        "NewtonianLipschitz.JacobianAxisBounds"
    ],
    "NewtonianLipschitz/JacobianCartesianBound.lean": [
        "NewtonianLipschitz.JacobianSignedBounds"
    ],
    "NewtonianLipschitz/JacobianOperatorAction.lean": [
        "NewtonianLipschitz.JacobianCartesianBound"
    ],
    "NewtonianLipschitz/JacobianOperatorNorm.lean": [
        "NewtonianLipschitz.JacobianOperatorAction"
    ],
    "NewtonianLipschitz/JacobianSharpWitness.lean": [
        "NewtonianLipschitz.JacobianOperatorNorm"
    ],
    "NewtonianLipschitz/JacobianOperatorWitness.lean": [
        "NewtonianLipschitz.JacobianSharpWitness"
    ],
    "NewtonianLipschitz/ConvexSharp.lean": [
        "NewtonianLipschitz.JacobianOperatorWitness",
        "NewtonianLipschitz.ConvexBaseline"
    ],
    "NewtonianLipschitz/CartesianBoxSharp.lean": [
        "NewtonianLipschitz.ConvexSharp"
    ],
    "NewtonianLipschitz/DerivativeCoefficientMinimality.lean": [
        "NewtonianLipschitz.CartesianBoxSharp"
    ],
    "NewtonianLipschitz/DerivativeAttainingDirection.lean": [
        "NewtonianLipschitz.DerivativeCoefficientMinimality"
    ],
    "NewtonianLipschitz/AdmissibleCriticalDirection.lean": [
        "NewtonianLipschitz.DerivativeAttainingDirection"
    ],
    "NewtonianLipschitz/AdmissibleSecantPairs.lean": [
        "NewtonianLipschitz.AdmissibleCriticalDirection"
    ],
    "NewtonianLipschitz/LongSeparation.lean": [
        "NewtonianLipschitz.AdmissibleSecantPairs"
    ],
    "NewtonianLipschitz/CommonSafeFace.lean": [
        "NewtonianLipschitz.LongSeparation"
    ],
    "NewtonianLipschitz/CrossFaceTwoHop.lean": [
        "NewtonianLipschitz.CommonSafeFace"
    ],
    "NewtonianLipschitz/TangentialAlgebra.lean": [
        "NewtonianLipschitz.CrossFaceTwoHop"
    ],
    "NewtonianLipschitz/ConditionalFiniteSource.lean": [
        "NewtonianLipschitz.CrossFaceTwoHop",
        "NewtonianLipschitz.FiniteSources"
    ],
    "NewtonianLipschitz/SafePlaneReduction.lean": [
        "NewtonianLipschitz.ConditionalFiniteSource",
        "NewtonianLipschitz.TangentialAlgebra"
    ],
    "NewtonianLipschitz/PhysicalTangentialNormalized.lean": [
        "NewtonianLipschitz.SafePlaneReduction"
    ],
    "NewtonianLipschitz/PhysicalTangentialFirstAxis.lean": [
        "NewtonianLipschitz.PhysicalTangentialNormalized"
    ],
    "NewtonianLipschitz/PhysicalTangentialAllAxes.lean": [
        "NewtonianLipschitz.PhysicalTangentialFirstAxis"
    ],
    "NewtonianLipschitz/SafePlaneFiniteDifference.lean": [
        "NewtonianLipschitz.PhysicalTangentialAllAxes"
    ],
    "NewtonianLipschitz/UnconditionalFiniteSource.lean": [
        "NewtonianLipschitz.SafePlaneFiniteDifference"
    ],
    "NewtonianLipschitz/BaselineBounds.lean": ["NewtonianLipschitz.Derivative"],
    "NewtonianLipschitz/ConvexBaseline.lean": ["NewtonianLipschitz.BaselineBounds", "NewtonianLipschitz.Clearance"],
    "NewtonianLipschitz/ImprovedBounds.lean": ["NewtonianLipschitz.BaselineBounds"],
    "NewtonianLipschitz/ConvexImproved.lean": ["NewtonianLipschitz.ImprovedBounds", "NewtonianLipschitz.Clearance"],
    "NewtonianLipschitz/JacobianRows.lean": ["Mathlib"],
    "NewtonianLipschitz/JacobianMatrix.lean": ["NewtonianLipschitz.Derivative", "NewtonianLipschitz.JacobianRows"],
    "Challenge.lean": ["Mathlib"],
    "Solution.lean": ["NewtonianLipschitz"],
}

for rel, imports in expected_imports.items():
    file = root / rel
    if not file.is_file():
        continue
    source = file.read_text(encoding="utf-8")
    if not source.startswith("module\n"):
        issues.append(f"{rel} missing the Lean module header")
    found = re.findall(r"^\s*(?:public\s+)?import\s+(\S+)", source, re.M)
    if found != imports:
        issues.append(f"{rel}: expected imports {imports}, got {found}")
    if len(source.splitlines()) > 10000:
        issues.append(f"{rel}: source exceeds 10,000 lines")
# No independent proof is selected at initialization; forbid any
# silent claim that the empty Comparator configuration verified a theorem.
comparison = json.loads((root / "comparator.json").read_text(encoding="utf-8"))
if comparison.get("theorem_names") != [] or comparison.get("definition_names") != []:
    issues.append("A selected Comparator theorem requires updating the readiness and CI policy")
if comparison.get("permitted_axioms") != ["propext", "Quot.sound", "Classical.choice"]:
    issues.append("Invalid Comparator axiom allowance")
metadata = json.loads((root / "formalization.yaml").read_text(encoding="utf-8"))
if metadata.get("version") != "v0.4" or metadata.get("sources") != []:
    issues.append("The current Palomar file is a draft with no selected proof source")
if issues:
    print("\n".join(issues), file=sys.stderr)
    sys.exit(1)
print("Pinned dependencies and Lean source layout verified.")
