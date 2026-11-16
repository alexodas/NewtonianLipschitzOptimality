# NewtonianLipschitzOptimality — Palomar preparation

This is **not a submitted formalization**. The project is preparing a
Lean-verified mathematical result on the optimal universal supremum-norm
Lipschitz coefficient of the exact three-dimensional Newtonian point-source
field. The [README](README.md) explains the current goal and research protocol.

**Selection status:** No theorem is currently selected in
[`comparator.json`](comparator.json). [`Challenge.lean`](Challenge.lean)
and [`Solution.lean`](Solution.lean) are reserved standalone entrypoints
only; the independent Comparator has **not** been run for this project.
The [`formalization.yaml`](formalization.yaml) is a draft, minimal
metadata skeleton without a formalization source or submission claim.

**Potential importance and audience:** A proved sharp Cartesian-supremum-norm
sensitivity coefficient for the Newtonian field may help control enclosure
overestimation in rigorous numerical calculations. Potential readers include
researchers in validated dynamics and interval/Taylor-model methods (CAPD,
VNODE-LP, COSY Infinity), planetary defense and asteroid impact monitoring,
aerospace engineering and space situational awareness, and certified
Cartesian-grid \(N\)-body algorithms (Octree / Barnes–Hut variants).
These are **prospective uses**, not demonstrated software integrations,
validated orbital propagations, certified satellite collision probabilities,
or achieved applications. All require further assumptions and analysis;
see the [audience discussion in the README](README.md#why-the-result-may-matter--intended-audience).

**Provenance and review:** The project is initiated and directed by
**Alessandro Odasso**, a non-mathematician investigating the capabilities and
limits of LLMs in scientific research; GPT-6 assists with the mathematics,
Lean work and infrastructure. No mathematical originality, optimality,
peer-review acceptance or Registry endorsement is asserted.

The two different questions — optimal constants on convex noncollision
regions and a global bound across a nonconvex exterior — will be kept
distinct. Successful source compilation will not be presented as an
independent kernel comparison or proof of a proposed sharp coefficient.
