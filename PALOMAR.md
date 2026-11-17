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

**Verified progress:** R016–R017 prove the exact scalar C3
formula and maximality. R024–R032 establish the actual
Newtonian derivative's sharp Cartesian operator-norm
bound and its attainment. R033–R037 exhibit admissible
safe secants approaching C3 and prove that no smaller
universal one-source global coefficient can work.
R035 constructs exact-step admissible secant pairs;
R036 proves their right-hand quotient limit.
R038 handles long admissible pairs, R039 handles
common supporting safe halfspaces, and R040 builds
a safe two-hop bridge for different-axis endpoints.
R045 proves the signed-safe first-axis physical
tangential derivative bound, later extended to
all three axes in R046.

R042 certifies exact scalar inequalities supporting a
stronger tangential coefficient 5/4, and proves the
strict exact comparison **5/2 < C3**. R044–R046
transfer the tangential estimate to the true
Newtonian Fréchet derivative for every signed-safe
coordinate axis and positive clearance.

**R047 now proves the previously missing one-source
global upper bound, without convexity of the entire
domain.** Using the one-dimensional mean-value
inequality on a fixed safe coordinate plane,
it obtains the genuine **5/4 finite-difference
bound**, proves the earlier explicit proposition
`oneSourceSafePlaneFiveFourthBound`, and applies
R043's already verified geometric case split to
prove `oneSourceGlobalCandidateBound`
**unconditionally**. Together with R037, this
identifies C3 as the sharp universal coefficient
for the one-source nonconvex cube-exterior problem.

R048 now formally packages the one-source sharp
global **if and only if**: a real coefficient K
bounds every admissible pair outside the unit cube
exactly when `C3 <= K`, combining the R037 lower
bound and R047 upper bound.

R041 had established the **conditional** lifting
of the one-source C3 inequality to a finite-source
exact nonlinear differential-acceleration sum.
**R048 discharges that hypothesis**, providing
direct **unconditional** inequalities with sharp
one-source factor C3 and overall coefficients
`sum(mu_k)*C3/d³` and `N*M*C3/d³` for source
gravitational parameters `mu_k <= M`.

The intended final physical Palomar statement
still needs an explicit source-position and
`mu_k = G*m_k` interface and universal
minimality under precisely stated N-source
admissibility assumptions. The existing proof
is for the repository's exact nonlinear sum,
not yet the final Comparator declaration.

**Outstanding evidence:** Finish the explicit
physical-source parameterization, the final
N-source upper/minimality statement with all
necessary positivity and multiplicity assumptions,
and matching auditable Challenge/Solution
declarations for both planned Palomar theorems.
Configure and run independent Comparator, then
seek mathematical review. This repository is not
yet a submission or externally reviewed result.

**Repository stage:** R001–R048 have passed complete
Lean builds, and the README's cumulative ledger
records the exact mathematical statements and
limitations. R041 and R043 remain valid historical
conditional implications. R047 proves their missing
one-source/safe-plane premises; R048 packages the
unconditional finite-source bound and exact
one-source optimality iff. Compilation and merge
are not independent Comparator validation or
Palomar submission.

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
