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

**Outstanding evidence:** The pointwise derivative
operator-norm upper bound is verified (R027), but the
global two-point upper bound on the nonconvex exterior
is not. An exact diagonal Jacobian row-sum witness is
proposed in `JacobianSharpWitness.lean`, pending CI.
An admissible finite-difference witness and the full
global theorem still require Lean proofs.

## Conditions before actual submission

Prepare matching, human-auditable Challenge and Solution
declarations for both theorems; configure and run
Comparator; update the provenance and limitations in
`formalization.yaml`; and arrange mathematical review.

Palomar requires a **public repository pinned to a full
40-character commit SHA**. No change to private repository
visibility, submission, or merge to `main` is authorized
by this planning document.

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
see [the README](README.md#why-the-result-may-matter--intended-audience).

**Provenance and review:** The project is initiated and directed by
**Alessandro Odasso**, a non-mathematician investigating the capabilities and
limits of LLMs in scientific research; GPT-6 assists with the mathematics,
Lean work and infrastructure. No mathematical originality, optimality,
peer-review acceptance or Registry endorsement is asserted.

The two different questions — optimal constants on convex noncollision
regions and a global bound across a nonconvex exterior — will be kept
distinct. Successful source compilation will not be presented as an
independent kernel comparison or proof of a proposed sharp coefficient.
