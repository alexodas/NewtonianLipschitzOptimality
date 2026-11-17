# NewtonianLipschitzOptimality

Lean 4 formalization of the exact Newtonian gravitational field in 3D
and its Lipschitz bounds in the Cartesian supremum norm.

## Executive summary

The objective is to prove the smallest universal sensitivity coefficient
under explicit positive-clearance and geometric domain assumptions.

**Already proved:** the exact field and Fréchet derivative,
coefficients 10 and 7, the scalar maximum, normalized Jacobian
row bounds, and sign, scale, and axis-permutation identities.

**Not yet proved:** the sharp coefficient, its optimality, and a global
Lipschitz bound on nonconvex domains.

Alessandro Odasso directs the research. He is not a mathematician and
uses this project to study the capabilities and limits of
large language models (LLMs) in scientific research. GPT-6 assists
with mathematical reasoning, Lean proof development, and verification.

## Main theorem target — gravitational variation outside cubes

### Plain-language statement (research goal)

Consider **N point masses** in three-dimensional space, with
Cartesian axes **X, Y, and Z**. Each body has a mass no greater
than a prescribed maximum. Around each body, imagine an
**axis-aligned safety cube**, centered on that body, with
side length 2d. Its interior is forbidden; its boundary
is allowed.

Choose **any two points P and Q** outside the interiors of
all these cubes, even if the straight segment joining them
passes through a forbidden region.

**The proposed theorem states** that the greatest change in
gravitational acceleration along any one of the X, Y, or Z
axes is bounded by the greatest coordinate displacement
between P and Q, multiplied by a universal factor. That
factor depends on the gravitational constant, maximum body
mass, number of bodies, and inverse cube of the safety
distance.

The **candidate dimensionless constant** is approximately
**2.5775644**. We also seek to prove, separately, that this
constant cannot be reduced.

**This global two-point inequality and its optimality have
not yet been proved.**

### Formal mathematical statement

Each point has three coordinates:
P = (P_X, P_Y, P_Z) and Q = (Q_X, Q_Y, Q_Z).
Here **P and Q are points**, not coordinate axes.

For a vector v = (v_X, v_Y, v_Z), define:

- The **Euclidean norm**, used in Newton's gravitational law:
  norm_2(v) = sqrt(v_X^2 + v_Y^2 + v_Z^2).
- The **Cartesian maximum norm**, used for safety cubes and
  the variation bound:
  norm_inf(v) = max(|v_X|, |v_Y|, |v_Z|).

Let N >= 1 be the number of bodies, G > 0 the gravitational
constant, and d > 0 the cube half-side. The bodies have
positions a_1,...,a_N and masses 0 <= m_k <= Mmax.

The two points are **safe** if, for every body k,

- norm_inf(P-a_k) >= d and norm_inf(Q-a_k) >= d.

Thus P and Q lie outside every open forbidden cube,
with cube boundaries included in the safe region.

Their total gravitational acceleration is

$$
g(P) = -G\sum_{k=1}^{N}
\frac{m_k(P-a_k)}{\|P-a_k\|_2^3},
$$

and analogously for Q.

Write Delta X, Delta Y, Delta Z for the coordinate differences
of P-Q, and Delta g_X, Delta g_Y, Delta g_Z for the components
of g(P)-g(Q).

**Main conjecture (not yet proved in Lean):**

$$
\max\bigl(|\Delta g_X|,|\Delta g_Y|,|\Delta g_Z|\bigr)
\le
C_3\frac{G M_{\max}N}{d^3}
\max\bigl(|\Delta X|,|\Delta Y|,|\Delta Z|\bigr).
$$

Equivalently, in compact notation,

$$
\|g(P)-g(Q)\|_\infty
\le \frac{C_3 G M_{\max}N}{d^3}\|P-Q\|_\infty.
$$

The exact candidate is defined in Lean by
candidateCoefficient(candidateCriticalPoint).
Its numerical value is approximately 2.5775644212.
The critical point is the unique root in [9/50, 1/5]
of 2*t^3 - 8*t^2 - 4*t + 1 = 0.

**Separate optimality conjecture:** No smaller universal
constant can replace C3 for all admissible configurations.

## Mathematical question

Newton's law uses the **Euclidean norm** norm_2, whereas
the proposed sensitivity inequality uses norm_inf to measure
variations along the three Cartesian axes X, Y, and Z.

The previously proved coefficients 10 and 7 require
Euclidean clearance. The sharp candidate C3 instead uses
clearance in the Cartesian maximum norm. These are
different geometric assumptions.

Lean already verifies the scalar maximization, normalized
Jacobian row estimates, and axis symmetries (R016–R023).
The unrestricted three-dimensional derivative estimate
remains open. In addition, the **nonconvex complement**
of the forbidden cubes requires a separate argument for
arbitrary pairs of points, including those whose connecting
segment crosses a forbidden region.

## Why the result may matter — intended audience

These are potential uses, not certified applications:

- **Validated dynamics:** CAPD, VNODE-LP and COSY Infinity may benefit
  from explicit force sensitivity estimates.
- **Planetary defense:** uncertainty propagation during close approaches
  requires rigorous positive separation.
- **Aerospace and space situational awareness:** a deterministic bound
  may contribute to conjunction analyses, but a Lipschitz coefficient
  does not itself certify a collision probability.
- **Cartesian N-body and Barnes–Hut methods:** force sensitivity bounds
  may enter error budgets; tree approximation errors need separate proofs.

No application integration, physical validation, or originality claim
is implied by this list.

## Results acquired — cumulative mathematical ledger

Only mathematical results verified by a successful full Lean build appear
here. Numbering is permanent. Each entry records its meaning, utility,
limits, Lean declarations, and exact source. Work in progress and CI
chronology are kept outside this catalog.

### R001 — Euclidean radius and Cartesian norm

The physical radius is exactly the norm of the Euclidean representation;
the Cartesian supremum norm does not exceed it.

**Why useful:** Distinguishes the physical and sensitivity norms.
**Limit:** It is not a sharp force estimate.

**Lean:** `euclideanRadius_eq_physical_norm`,
`cartesian_norm_le_euclideanRadius`.
**Sources:** [Basic.lean](NewtonianLipschitz/Basic.lean),
[Norms.lean](NewtonianLipschitz/Norms.lean).

### R002 — Differentiability away from collision

The exact Newtonian acceleration is continuously differentiable
at every nonzero source separation.

**Why useful:** Justifies differential estimates.
**Limit:** No result at the collision singularity.

**Lean:** `NewtonianPointSource.accelerationField_contDiffAt`.
**Source:** [Smoothness.lean](NewtonianLipschitz/Smoothness.lean).

### R003 — Exact Fréchet derivative

The complete derivative of the actual inverse-cube field is proved,
using the physical Euclidean inner product.

**Why useful:** Supplies the exact operator to optimize.
**Limit:** Its optimal norm is not determined by the formula alone.

**Lean:** `NewtonianPointSource.accelerationField_fderiv_full`.
**Source:** [Derivative.lean](NewtonianLipschitz/Derivative.lean).

### R004 — Inverse-power estimates from clearance

Positive Euclidean clearance and a parameter cap control the
inverse-power coefficients in the Newtonian derivative.

**Why useful:** Turns geometry into explicit inequalities.
**Limit:** Clearance and the parameter bound are assumptions.

**Lean:** `NewtonianPointSource.inverse_power_parameter_le_of_clearance`,
`NewtonianPointSource.inverse_fifth_derivative_coefficient_le`.
**Source:** [BaselineBounds.lean](NewtonianLipschitz/BaselineBounds.lean).

### R005 — Derivative coefficient 10

The true field satisfies the derivative estimate with coefficient
`10*M/d^3` under positive clearance d and gravitational cap M,
measured using the Cartesian supremum norm.

**Why useful:** Explicit derivative control.
**Limit:** 10 is not optimal.

**Lean:** `NewtonianPointSource.accelerationField_fderiv_norm_le_ten_of_clearance`.
**Source:** [BaselineBounds.lean](NewtonianLipschitz/BaselineBounds.lean).

### R006 — Convex Lipschitz coefficient 10

On convex sets with uniform positive Euclidean clearance,
the exact field has Lipschitz coefficient `10*M/d^3`.

**Why useful:** Controls finite differences.
**Limit:** Convexity is required; 10 is not sharp.

**Lean:** `NewtonianPointSource.accelerationField_lipschitzOnWith_of_clearance`.
**Source:** [ConvexBaseline.lean](NewtonianLipschitz/ConvexBaseline.lean).

### R007 — Anchor-ball clearance

A suitably separated anchor yields positive Euclidean clearance
throughout a specified Cartesian supremum-norm ball.

**Why useful:** Supplies geometric certificates.
**Limit:** The separation margin must be established independently.

**Lean:** `clearance_on_anchor_ball`.
**Source:** [Clearance.lean](NewtonianLipschitz/Clearance.lean).

### R008 — Finite-source exact force algebra

Finite sums of exact nonlinear differential forces satisfy the
empty-list and cons-list identities.

**Why useful:** Foundation for multiple point sources.
**Limit:** No aggregate Lipschitz bound follows from algebra alone.

**Lean:** `NewtonianPointSource.finiteDifferentialAcceleration_nil`,
`NewtonianPointSource.finiteDifferentialAcceleration_cons`.
**Source:** [FiniteSources.lean](NewtonianLipschitz/FiniteSources.lean).

### R009 — Improved derivative coefficient 7

The inequality `norm_2 h <= 2*norm_inf h` yields the derivative
coefficient `7*M/d^3` for the true field.

**Why useful:** Improves R005 without assuming an unknown derivative cap.
**Limit:** 7 is still not optimal.

**Lean:** `euclideanRadius_le_two_mul_cartesian_norm`,
`NewtonianPointSource.accelerationField_fderiv_norm_le_seven_of_clearance`.
**Sources:** [Norms.lean](NewtonianLipschitz/Norms.lean),
[ImprovedBounds.lean](NewtonianLipschitz/ImprovedBounds.lean).

### R010 — Improved convex Lipschitz coefficient 7

The exact field has coefficient `7*M/d^3` on convex domains
with uniform positive Euclidean clearance. An anchor-ball form
is also proved.

**Why useful:** Improves R006 for finite force differences.
**Limit:** Requires convexity and is not sharp.

**Lean:** `NewtonianPointSource.accelerationField_lipschitzOnWith_seven`,
`NewtonianPointSource.unitAxis_lipschitzOnWith_anchor_seven`.
**Source:** [ConvexImproved.lean](NewtonianLipschitz/ConvexImproved.lean).

### R011 — Dominant-row and diagonal algebra

For normalized `(1,u,v)`, with `0 <= u,v <= 1`, the proposed
maximal-row numerator dominates both lateral numerators.
For fixed `u^2+v^2`, its maximum is on the diagonal `u=v`.

**Why useful:** Reduces the algebraic optimization to one variable.
**Limit:** Does not yet bound the full physical operator globally.

**Lean:** `lateralRowNumerator_le_dominant`,
`lateralRowNumerator_swapped_le_dominant`,
`dominantRowNumerator_le_diagonal`.
**Source:** [JacobianRows.lean](NewtonianLipschitz/JacobianRows.lean).

### R012 — Candidate stationary cubic

For `p(t)=2*t^3-8*t^2-4*t+1`, the cubic is strictly decreasing
on `[0,1]`, positive at `9/50`, negative at `1/5`, and has
at most one zero in that interval.

**Why useful:** Exact information about a possible maximizer.
**Limit:** Existence, maximization, and sharpness remain unproved.

**Lean:** `stationaryCubic_pos_at_nine_fiftieths`,
`stationaryCubic_neg_at_one_fifth`,
`stationaryCubic_strictAntiOn_unitInterval`,
`stationaryCubic_root_unique_on_unitInterval`.
**Source:** [CubicCandidate.lean](NewtonianLipschitz/CubicCandidate.lean).

### R013 — Exact symmetric Cartesian Jacobian

For every nonzero displacement, the actual Fréchet derivative acts
as the symmetric matrix

`J_mu(x)=mu/(norm_2 x)^5 * (3*x*x^T-(norm_2 x)^2*I)`.

**Why useful:** Gives the concrete matrix to optimize in the
Cartesian supremum operator norm.
**Limit:** No global sharp bound or optimality is proved by this alone.

**Lean:** `NewtonianPointSource.accelerationField_fderiv_eq_jacobianMatrix`,
`newtonianJacobianMatrix_symmetric`,
`newtonianJacobianMatrix_mulVec`.
**Source:** [JacobianMatrix.lean](NewtonianLipschitz/JacobianMatrix.lean).

### R014 — Exact normalized first-row Jacobian sum

For a nonnegative normalized displacement `(1,u,v)`,
where `0 <= u,v <= 1` and `mu >= 0`, the absolute sum of
the first row of the **actual** Newtonian Jacobian is

`mu/(norm_2(1,u,v))^5 * (2-u^2-v^2+3*u+3*v)`.

**Why useful:** Connects the physical derivative matrix to the
dominant-row numerator in R011.
**Limit:** The other rows and the global operator-norm maximum
still require proof.

**Lean:** `newtonianJacobianMatrix_normalized_firstRow_abs_sum`,
`newtonianJacobianMatrix_normalized_zero_zero`,
`newtonianJacobianMatrix_normalized_zero_one`,
`newtonianJacobianMatrix_normalized_zero_two`.
**Source:** [JacobianMatrix.lean](NewtonianLipschitz/JacobianMatrix.lean).

### R015 — Diagonal bound for the actual Jacobian's first row

For `mu >= 0` and normalized coordinates `(1,u,v)`
with `0 <= u,v <= 1`, the first absolute-row sum of
the actual Jacobian is bounded using the diagonal parameter
`sqrt((u^2+v^2)/2)`, at the same Euclidean radius.

**Why useful:** Transfers R011's one-variable algebraic
reduction to a genuine row of the derivative matrix.
**Limit:** Does not yet prove the global operator norm,
the sharp coefficient, or its optimality.

**Lean:** `newtonianJacobianMatrix_normalized_firstRow_le_diagonal`.
**Source:** [JacobianMatrix.lean](NewtonianLipschitz/JacobianMatrix.lean).

### R016 — Exact existence and uniqueness of the critical cubic root

The cubic `2*t^3-8*t^2-4*t+1` has exactly one root in
the rational interval `[9/50,1/5]`. Lean defines the exact
real `candidateCriticalPoint` and proves its polynomial
equation and enclosure, without a numerical approximation.

**Why useful:** Defines the candidate maximizing parameter
mathematically instead of assigning a rounded decimal.
**Limit:** Root existence does not itself prove scalar
maximization or the universal Lipschitz coefficient.

**Lean:** `stationaryCubic_exists_root_bracket`,
`stationaryCubic_existsUnique_root_bracket`,
`candidateCriticalPoint_spec`.
**Source:** [CubicCandidate.lean](NewtonianLipschitz/CubicCandidate.lean).

### R017 — Exact maximum of the scalar candidate coefficient

Let `t_star` be the unique real root from R016.
For every `0 <= t <= 1`, Lean proves the exact bound

`candidateCoefficient(t) <= candidateCoefficient(t_star)`.

The proof differentiates the exact square-root expression,
uses the sign of the stationary cubic, and establishes the
maximum without treating a decimal approximation as an axiom.

**Why useful:** Determines the exact maximal value of the
one-variable function arising from the diagonal reduction.
**Limit:** It is not yet a universal bound on the Newtonian
Jacobian over all nonzero three-dimensional displacements.

**Lean:** `candidateCoefficient_hasDerivAt`,
`candidateCoefficient_le_at_criticalPoint`,
`candidateMaximum`.
**Source:** [ScalarMaximum.lean](NewtonianLipschitz/ScalarMaximum.lean).


### R018 — Candidate maximum bounds the normalized first Jacobian row

For `mu >= 0` and `0 <= u,v <= 1`, the absolute
first-row sum of the physical Jacobian at `(1,u,v)`
is at most `mu*candidateMaximum`, with the exact scalar
maximum defined and proved in R017.

**Why useful:** Applies the scalar maximum to the actual
Jacobian of the Newtonian field.
**Limit:** Other rows and arbitrarily signed or scaled
three-dimensional points still require separate proofs.

**Lean:** `newtonianJacobianMatrix_normalized_firstRow_le_candidateMaximum`,
`diagonalParameter_mem_unitInterval`,
`normalizedVector_radius_eq_diagonal`.
**Source:**
[NormalizedSharpBound.lean](NewtonianLipschitz/NormalizedSharpBound.lean).

### R019 — All rows in the normalized positive octant

For `mu >= 0`, `0 <= u,v <= 1`, and each row index
`i` of the exact physical Jacobian at `(1,u,v)`,
Lean proves

`sum_j abs(J_mu(1,u,v)[i,j]) <= mu*candidateMaximum`.

The second and third rows use exact matrix entries,
the lateral-row algebra from R011, and R018.

**Why useful:** Completes all three physical Jacobian row
estimates for the normalized nonnegative configuration.
**Limit:** Arbitrary signs, coordinate permutations and
non-unit spatial scaling are not yet covered.

**Lean:** `newtonianJacobianMatrix_normalized_allRows_le_candidateMaximum`,
`newtonianJacobianMatrix_normalized_secondRow_le_candidateMaximum`,
`newtonianJacobianMatrix_normalized_thirdRow_le_candidateMaximum`.
**Source:**
[NormalizedSharpBound.lean](NewtonianLipschitz/NormalizedSharpBound.lean).

### R020 — Sign invariance and cubic scaling of the Jacobian

For the exact Newtonian Jacobian, replacing each coordinate
by its absolute value leaves every absolute matrix entry,
and hence every absolute row sum, unchanged.

For positive `c` and nonzero `x`, the physical Jacobian
at `c*x` equals `c^(-3)` times the Jacobian at `x`.

**Why useful:** Provides the sign and scale bridges needed
to extend the verified normalized row bound R019.
**Limit:** Coordinate permutations and the unrestricted
Jacobian bound remain to be proved. No global two-point
inequality or optimality follows from this result alone.

**Lean:** `euclideanRadius_coordinateAbs`,
`newtonianJacobianMatrix_rowSum_coordinateAbs`,
`newtonianJacobianMatrix_entry_positive_smul`.
**Source:**
[JacobianSymmetries.lean](NewtonianLipschitz/JacobianSymmetries.lean).

### R021 — Cyclic and Y/Z permutations of Cartesian axes

Lean proves that cyclic relabeling `(X,Y,Z) -> (Y,Z,X)`
and exchanging Y with Z preserve the physical Euclidean
radius. The entries of the actual Newtonian Jacobian are
reindexed accordingly, as are the absolute row sums.

**Why useful:** These two transformations generate the six
permutations of the three axes; they support reducing
arbitrary Cartesian coordinates to normalized form.
**Limit:** A full arbitrary-permutation reduction and the
unrestricted sharp derivative inequality remain open.
They do not imply the nonconvex global theorem.

**Lean:** `euclideanRadius_cycleVec`,
`newtonianJacobianMatrix_cycle_entry`,
`newtonianJacobianMatrix_cycle_rowSum`,
`euclideanRadius_swapYZVec`,
`newtonianJacobianMatrix_swapYZ_entry`,
`newtonianJacobianMatrix_swapYZ_rowSum`.
**Source:**
[JacobianPermutations.lean](NewtonianLipschitz/JacobianPermutations.lean).

### R022 — Sharp row bound with a maximal positive X coordinate

For a nonnegative Cartesian displacement with positive X
coordinate dominating Y and Z, Lean proves that every
absolute Jacobian row sum is at most

`(mu*candidateMaximum)/(X^3)`.

The proof expresses the displacement as X times a normalized
vector and applies the exact inverse-cubic scaling identity.

**Why useful:** Transfers the sharp normalized row bounds
from unit X to a full positive scale.
**Limit:** The verified statement does not yet cover cases
with maximal Y or Z, arbitrary signs, or the universal
Cartesian maximum-norm bound.

**Lean:** `newtonianJacobianMatrix_rowSum_positive_smul`,
`positive_first_coordinate_normalization`,
`newtonianJacobianMatrix_firstMax_le_candidateMaximum`.
**Source:**
[JacobianNormalization.lean](NewtonianLipschitz/JacobianNormalization.lean).

### R023 — Sharp row bounds with maximal Y or Z coordinates

For nonnegative displacements with positive dominant Y
or positive dominant Z, Lean proves the exact candidate
bound for every absolute row sum of the physical Jacobian:

`(mu*candidateMaximum)/(dominant_coordinate^3)`.

Both proofs rotate the Cartesian coordinates and reuse R022.

**Why useful:** Covers every choice of dominant axis
for a nonnegative displacement.
**Limit:** Signed coordinates, the full maximum-norm bound
and global two-point Lipschitz estimates remain separate.

**Lean:** `cycleIndex_three`,
`newtonianJacobianMatrix_secondMax_le_candidateMaximum`,
`newtonianJacobianMatrix_thirdMax_le_candidateMaximum`.
**Sources:**
[JacobianPermutations.lean](NewtonianLipschitz/JacobianPermutations.lean),
[JacobianAxisBounds.lean](NewtonianLipschitz/JacobianAxisBounds.lean).

### R024 — Global signed-coordinate Jacobian row-sum bound

For every nonzero three-dimensional displacement with
arbitrary coordinate signs and for `mu >= 0`, Lean proves
that each absolute row sum of the actual Newtonian Jacobian
is at most

`mu*candidateMaximum / max(|X|,|Y|,|Z|)^3`.

The proof combines all three dominant-axis cases (R022–R023)
with the sign invariance of R020.

**Why useful:** Establishes the candidate row bound at
every nonzero Cartesian displacement, not just a
normalized configuration or one coordinate octant.
**Limit:** Its identification with the ambient Pi norm,
the operator-norm transfer, global two-point bounds
and optimality are separate obligations.

**Lean:** `newtonianJacobianMatrix_nonnegative_max_le_candidateMaximum`,
`newtonianJacobianMatrix_signed_max_le_candidateMaximum`.
**Source:**
[JacobianSignedBounds.lean](NewtonianLipschitz/JacobianSignedBounds.lean).

## Direct proof strategy

The sharp candidate bounds all absolute Jacobian
row sums at arbitrary nonzero signed Cartesian
displacements (R024).

1. Identify the coordinate maximum with the actual Pi norm
   and formalize the bound under positive Cartesian clearance.
2. Transfer the matrix row estimate to the operator norm
   of the physical Fréchet derivative.
3. **Separately prove optimality** using a matching witness
   and a limiting difference quotient.
4. Establish sharp finite-difference bounds on suitable
   convex safe domains.
5. Analyze pairs of points across nonconvex cubical
   exclusions directly. The global `N`-source theorem
   remains a separate mathematical objective.

## Roadmap

- **M01 — Foundation: complete.** Exact field, derivative,
  norm bridges, clearance, and bounds 10 and 7 (R001–R010).
- **M02 — Jacobian reduction: in progress.** Row algebra
  (R011), exact Jacobian (R013), normalized row estimates
  (R014–R015, R018–R019), sign/scale invariances (R020)
  and cyclic/Y-Z axis transformations (R021) are proved.
  Positive X scaling (R022), maximal Y and Z (R023),
  and arbitrary coordinate signs (R024) are verified.
  The complete coordinate row-sum reduction is acquired.
- **M03 — Sharp upper bound: in progress.** Cubic facts
  (R012), exact root (R016), scalar maximum (R017),
  normalized rows (R018–R019) and sign/scale transfer
  (R020), maximal-axis reductions (R022–R023)
  and all signed-coordinate row bounds (R024) are proved.
  The actual Pi-norm and positive-clearance transfer
  is proposed in JacobianCartesianBound.lean.
  Operator, optimality and nonconvex bounds remain open.
- **M04 — Optimality: open.** A matching witness.
- **M05 — Domain theorem: open.** Sharp convex-domain bound
  and separate investigation of nonconvex geometry.
- **M06 — Scientific and archival validation: open.** Proof
  integrity, mathematical references, Palomar metadata,
  independent Comparator, and final review before merge.

## Repository structure and reproducibility

The substantive library is in `NewtonianLipschitz/`:

- Exact physics: [Basic](NewtonianLipschitz/Basic.lean),
  [Field](NewtonianLipschitz/Field.lean),
  [Smoothness](NewtonianLipschitz/Smoothness.lean),
  [Derivative](NewtonianLipschitz/Derivative.lean).
- Norms and geometry: [Norms](NewtonianLipschitz/Norms.lean),
  [Clearance](NewtonianLipschitz/Clearance.lean).
- Conservative bounds: [BaselineBounds](NewtonianLipschitz/BaselineBounds.lean),
  [ConvexBaseline](NewtonianLipschitz/ConvexBaseline.lean),
  [ImprovedBounds](NewtonianLipschitz/ImprovedBounds.lean),
  [ConvexImproved](NewtonianLipschitz/ConvexImproved.lean).
- Sharp-bound work: [JacobianRows](NewtonianLipschitz/JacobianRows.lean),
  [JacobianMatrix](NewtonianLipschitz/JacobianMatrix.lean),
  [CubicCandidate](NewtonianLipschitz/CubicCandidate.lean),
  [ScalarMaximum](NewtonianLipschitz/ScalarMaximum.lean),
  [NormalizedSharpBound](NewtonianLipschitz/NormalizedSharpBound.lean),
  [JacobianSymmetries](NewtonianLipschitz/JacobianSymmetries.lean),
  [JacobianPermutations](NewtonianLipschitz/JacobianPermutations.lean),
  [JacobianNormalization](NewtonianLipschitz/JacobianNormalization.lean),
  [JacobianAxisBounds](NewtonianLipschitz/JacobianAxisBounds.lean),
  [JacobianSignedBounds](NewtonianLipschitz/JacobianSignedBounds.lean),
  [JacobianCartesianBound](NewtonianLipschitz/JacobianCartesianBound.lean).
- Multiple sources: [FiniteSources](NewtonianLipschitz/FiniteSources.lean).

[NewtonianLipschitz.lean](NewtonianLipschitz.lean) is the library entry point.
The Lean 4 toolchain and Mathlib revision are pinned.

To reproduce the project, run in sequence:

1. `lake exe cache get`
2. `python3 scripts/check-repository.py`
3. `python3 scripts/check-documentation.py`
4. `python3 scripts/check-no-proof-holes.py`
5. `lake build NewtonianLipschitz`

The independent Comparator is not yet configured with a selected
theorem; no Comparator pass is claimed.
**Palomar files are placeholders**, not a formalization submission.

## Methodology — transparent LLM-assisted research

The human research director sets the questions. AI-generated proofs
and text require verification. No `sorry`, `admit`, or unreviewed
axioms are allowed in substantive proofs.

A complete Lean build checks the formal statements as encoded.
It is different from **independent kernel checking**, scientific
peer review, physical validation, and proof of originality.

The conjectural sharp coefficient and optimality remain
**not yet Lean-verified theorems**. Preserve exact assumptions,
norms, source links, and uncertainty.

Keep cumulative **mathematical** results here; keep the build and
task chronology in the pull request, not in the results catalog.
Require a green full build and documentation review before merge.
No novelty, priority, or publication-readiness claim is made.

## License

Apache License, Version 2.0 (Apache-2.0).
See [LICENSE](LICENSE).
