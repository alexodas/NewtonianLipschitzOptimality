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
pointwise derivative-norm coefficient. R033 constructs
an attaining direction; R034 certifies an outward
orientation whose forward ray stays outside the unit
safety cube. R035 proves distinct admissible secant
pairs with exact Cartesian step length. R036 proves the
right-hand limit of **physical** finite-difference quotients
along that admissible direction. R037 proves that every
coefficient valid for all unit-cube-safe two-point
differences of the unit source must be at least C3.
R038 proves the C3 upper estimate for safe endpoints
separated by at least the clearance d without requiring
a safe segment. R039 proves it for any two endpoints
in a common positive or negative safe supporting
halfspace, and combines these two cases. R040 gives
a constructive safe two-hop path for endpoints on
different active axes and a verified **nonsharp
2*C3** two-point bound in that case. R041 verifies
the **conditional** deduction of the exact finite-source
bound with coefficient `N*M*C3/d³` from the still-open
one-source global C3 proposition
`oneSourceGlobalCandidateBound`. R042 certifies
exact scalar radial-denominator and tangential
row-numerator inequalities supporting a proposed
5/4 derivative factor, and proves **C3 > 5/2**
without decimal approximations. The link to the
actual physical Jacobian and the nonconvex **C3
upper bound** remain unproved for short cross-face
pairs. R043 proves, **conditionally on** the explicit
unproved `oneSourceSafePlaneFiveFourthBound` finite-difference
estimate on fixed safe coordinate planes, the unrestricted
one-source global sharp C3 proposition
`oneSourceGlobalCandidateBound`. This covers
all endpoint configurations using R038–R040, but
does not prove its safe-plane premise.
R044 proves the actual physical Newtonian
Jacobian tangent-column 5/4 bound and the
corresponding Frechet directional inequality
at (1,u,v), u,v >= 0, h0 = 0. The transfer
to arbitrary axes, coordinate signs and scale
is outstanding; no unrestricted derivative
or safe-plane finite-difference estimate follows.

**Outstanding evidence:** The sharp global upper
bound (or a rigorous refutation) for **short
one-source cross-face pairs** without any shared safe
coordinate halfspace. R037 supplies the necessary
two-point lower bound, R038–R039 the proved sharp
upper subcases, and R040 only a nonsharp 2*C3
estimate. R042 supplies only the algebraic certificates
for a proposed tangential 5/4 estimate; R044
now transfers them to the **actual physical
Jacobian at normalized nonnegative points**.
The unrestricted signed-axis/scale derivative
and integration on safe planes remain outstanding. R043 now verifies the complete
conditional reduction from the explicit safe-plane 5/4
finite-difference premise to the one-source global C3
estimate; the premise remains unproved. R041 already
proves that a valid one-source
global C3 estimate *would imply* the exact finite-source
N*M*C3/d³ bound for the existing nonlinear differential
acceleration model. The single-source premise is still
unproved; the full physical-source parametrization,
matching Palomar declarations and independent
Comparator verification remain outstanding.

**Repository stage:** R001–R044 have passed complete
Lean builds, and the permanent README ledger records
their exact statements and limitations. R041 and R043
are **conditional implications**; R042 establishes
scalar inequalities, and R044 proves the physical
tangential estimate **only in normalized nonnegative
coordinates**. The safe-plane proposition
`oneSourceSafePlaneFiveFourthBound` and the one-source
global C3 proposition `oneSourceGlobalCandidateBound`
remain unproved. This description does not depend
on the transient state of a pull request.
Neither compilation nor merge constitutes independent
Comparator validation or a Palomar submission.

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

Compared with more elaborate polyhedral enclosures,
the Cartesian coefficient may offer a practical
parameter substitution for compatible certified
box-based codes without changing grid data structures.
More refined polyhedra may yield other, tighter
bounds, but this comparison has not been established.
Neither improved numerical accuracy, unchanged code
stability, speedup, reduced cell subdivision nor
prevention of floating-point overflow is guaranteed
or demonstrated. Using this estimate does
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
