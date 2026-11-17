# NewtonianLipschitzOptimality — Palomar preparation

This is **not a submitted formalization**. The project is preparing a
Lean-verified mathematical result on the optimal universal supremum-norm
Lipschitz coefficient of the exact three-dimensional Newtonian point-source
field. The [README](README.md) explains the current goal and research protocol.

**Comparator status:** No theorems are selected in
[`comparator.json`](comparator.json). The current
[`Challenge.lean`](Challenge.lean) and
[`Solution.lean`](Solution.lean) are reserved entrypoints.
Comparator has not been run. This is a **plan**, not a
completed Palomar formalization or submission.

## Planned Palomar theorem pair

Both declarations are intended for **one Comparator configuration**
and hence one Palomar entry. They will only be selected once
the two formal statements and proofs are complete and audited.

### Theorem 1 — Exact C3 formula and scalar maximum (proved)

There is a unique real parameter `t_star` in `[9/50, 1/5]`
satisfying

```text
2*t_star^3 - 8*t_star^2 - 4*t_star + 1 = 0.
```

For `0 <= t <= 1`, define

```text
f(t) = (2 + 6*t - 2*t^2) / (1 + 2*t^2)^(5/2).
C3 = f(t_star) = max { f(t) : 0 <= t <= 1 }.
```

Here `C3` is the exact Lean value `candidateMaximum`.
The approximation `2.5775644212` is informative but
is not yet certified as a numerical interval in Lean.

**Verified evidence:** R016 proves existence and uniqueness
of the root; R017 proves exact scalar maximality.
A standalone two-target Challenge/Solution interface
has not yet been assembled or independently compared.

### Theorem 2 — Optimal global cubical-clearance constant (open)

For `N >= 1` point masses `0 <= m_k <= Mmax` at
positions `a_k`, take `G > 0` and safety half-side
`d > 0`. For every pair of points `P,Q` with

```text
norm_inf(P-a_k) >= d, norm_inf(Q-a_k) >= d
for each source k,
```

the theorem must prove **both**:

1. **Global upper bound**, with no assumption that
   the segment from P to Q avoids the forbidden cubes:

   `norm_inf(g(P)-g(Q)) <=
   C3 * G * Mmax * N * norm_inf(P-Q) / d^3`.

2. **Minimality:** Every strictly smaller universal
   coefficient fails for at least one admissible
   configuration. A single-source example is sufficient
   to prove this lower-bound part.

**Verified progress:** R027 proves the pointwise
operator-norm bound; R028–R029 prove exact attainment
of the physical derivative operator norm at C3.
R030 establishes the candidate finite-difference
bound on convex domains with positive Cartesian
clearance. R031 verifies the Cartesian-box center-margin
corollary. R032 proves C3 is the least universal
pointwise derivative-norm coefficient. An explicit
saturating direction is proposed in
`DerivativeAttainingDirection.lean`, pending CI.

**Outstanding evidence:** An admissible finite-difference
minimality witness, a global two-point bound across
nonconvex forbidden cubes and the complete universal
optimality theorem are not yet proved.

## Conditions before actual submission

Prepare matching, human-auditable Challenge and Solution
declarations for both theorems; configure and run
Comparator; update the provenance and limitations in
`formalization.yaml`; and arrange mathematical review.

Palomar requires a **public repository pinned to a full
40-character commit SHA**. No change to private repository
visibility, submission, or merge to `main` is authorized
by this planning document.

**Potential importance and audience:** The mathematical
scope is especially relevant to Cartesian boxes and validated
computations involving inverse-square point-source forces.
Prospective readers include computational astrophysicists
working with N-body tree codes (Octree / Barnes–Hut) and FMM;
computational chemists and biophysicists working with Coulomb
interactions; interval and Taylor-model specialists using
CAPD, VNODE-LP or COSY Infinity; AMR and adaptive numerical
analysts; GPU/HPC developers; and researchers in
planetary defense, aerospace and space situational awareness.

The constant can be precomputed, but neither speedup nor
reduced cell subdivision nor prevention of floating-point
overflow has been demonstrated. Using this estimate does
not change the Euclidean denominators of the physical law.
Coulomb charge signs, periodic models, screening, software
error budgets and nonconvex geometries need explicit
hypotheses and additional analyses. No validated orbital
propagation, collision probability or integration is claimed.
See [the README](README.md#why-the-result-may-matter--intended-audience).

**Provenance and review:** The project is initiated and directed by
**Alessandro Odasso**, a non-mathematician investigating the capabilities and
limits of LLMs in scientific research; GPT-6 assists with the mathematics,
Lean work and infrastructure. No mathematical originality, optimality,
peer-review acceptance or Registry endorsement is asserted.

The two different questions — optimal constants on convex noncollision
regions and a global bound across a nonconvex exterior — will be kept
distinct. Successful source compilation will not be presented as an
independent kernel comparison or proof of a proposed sharp coefficient.
