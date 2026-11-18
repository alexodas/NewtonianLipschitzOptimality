# NewtonianLipschitzOptimality

Lean 4 formalization of the exact Newtonian gravitational field in 3D
and its Lipschitz bounds in the Cartesian supremum norm.

## Executive summary

This project proves sharp Lipschitz estimates for the **exact
three-dimensional Newtonian gravitational field**. The gravitational
law uses **Euclidean distance**, whereas excluded regions and the
sensitivity inequality use the **Cartesian supremum norm**.

There are two principal mathematical results.

1. The exact coefficient \(C_3\) is determined by the unique root
   of a cubic polynomial in a rational interval; an associated
   one-variable function attains its maximum there.
2. The **same coefficient** is the optimal universal global
   Lipschitz factor for Newtonian point-source gravity outside
   source-centered Cartesian safety cubes, even though the allowed
   region is generally **nonconvex**. A corresponding upper bound
   holds for any finite collection of nonnegative masses.

The sharp global upper bound for one source was formally proved in
R047, and R048 established exact one-source optimality and an
unconditional finite-source estimate. The standalone Palomar
Challenge and Solution express the two principal results without
depending on the project's definitions in the Challenge; their
independent Comparator check is a separate verification step.

Alessandro Odasso directs the research and the mathematical questions.
GPT-6 assisted with analysis and Lean proof authoring. Kernel
compilation, independent comparison, scholarly novelty and external
review are distinct matters.

## Main theorem target — gravitational variation outside cubes

### Plain-language statement

Imagine any finite number \(N\) of point masses at arbitrary positions
in three-dimensional space. Around each mass draw a cube whose sides
are parallel to the X, Y and Z axes, with half-side length \(d>0\).
The interior of each cube is excluded, but the boundary is allowed.

Choose any two observation points \(P,Q\) **outside every excluded
cube**. The straight line from \(P\) to \(Q\) need not stay outside:
it may pass through a forbidden region.

The first theorem answers a local optimization problem. It determines
the exact dimensionless coefficient \(C_3\) from a cubic equation,
not merely from a decimal numerical search. The physical Newtonian
derivative attains this coefficient in the Cartesian supremum norm,
so no smaller universal local bound is possible.

The second theorem answers the stronger **global** question. For a
single mass, the force difference between *any* such two safe points
obeys the same \(C_3\) coefficient, even if their joining segment is
unsafe. This is a proved result, not a conjecture. For multiple
masses the exact force differences add, and the coefficient becomes
\(N G M C_3/d^3\) when the gravitational constant is \(G\) and each
mass is between zero and \(M\).

The constant is **universally optimal**: a smaller dimensionless
coefficient would already fail for a suitable pair of safe points
with one unit source. This does **not** assert that a fixed
many-body arrangement, or every value of \(N\), attains the bound.

The central idea behind the nonconvex theorem is geometric. On any
plane where one Cartesian coordinate is fixed outside its safety
interval, the physical field has a stronger tangential derivative
bound \(5/4\). Integrating along a safe planar segment gives a
real two-point force bound. When the two endpoints lie on
different safe faces, a two-step bridge yields coefficient \(5/2\),
which is strictly below \(C_3\). Other endpoint configurations are
handled by safe halfspaces or by a long-separation estimate.
The construction **never differentiates across a forbidden region**.

### Formal mathematical statements

For \(v=(v_X,v_Y,v_Z)\), distinguish

\[
\|v\|_2=\sqrt{v_X^2+v_Y^2+v_Z^2},
\qquad
\|v\|_\infty=\max(|v_X|,|v_Y|,|v_Z|).
\]

The **first theorem**, the exact scalar maximization, takes the
unique \(t_*\in[9/50,1/5]\) solving

\[
2t_*^3-8t_*^2-4t_*+1=0.
\]

Then, for
\[
f(t)=\frac{2+6t-2t^2}{(1+2t^2)^{5/2}},
\]
the exact coefficient is
\[
C_3=f(t_*)=\max_{0\leq t\leq1} f(t)
\approx 2.5775644212.
\]
The decimal is illustrative; the Lean theorem specifies the
coefficient exactly and does not certify a decimal interval.

For the **second theorem**, let the masses \(m_k\) satisfy
\(0\leq m_k\leq M\), with source centers \(a_k\), \(G\geq0\),
\(M\geq0\), and \(d>0\). Write
\[
g(P)=-G\sum_{k=1}^{N}
  \frac{m_k(P-a_k)}{\|P-a_k\|_2^3}.
\]
Require for every source \(k\)
\[
\|P-a_k\|_\infty\geq d,\qquad
\|Q-a_k\|_\infty\geq d.
\]
The exact **global** estimate is
\[
\boxed{\displaystyle
\|g(P)-g(Q)\|_\infty
\le \frac{N G M C_3}{d^3}\|P-Q\|_\infty.}
\]
There is **no assumption** that \([P,Q]\) avoids the cubes.

For the unit source (\(N=G=M=d=1\), centered at zero),
a real number \(K\) bounds all admissible two-point
force differences precisely when \(K\geq C_3\).
Thus \(C_3\) is the least coefficient valid
**universally across the stated family**, already
forced by the one-source case.

The formal Challenge states both the scalar result
and the global finite-source bound with this exact
one-source minimality claim. Positivity and clearance
hypotheses are explicit. It does not claim a fixed
many-source configuration achieves the coefficient.

## Mathematical question

A pointwise derivative bound on a **nonconvex** domain does not,
by itself, control arbitrary two-point differences with the same
coefficient: the connecting segment could cross the excluded cube.
The proof therefore must exploit the structure of Newtonian gravity,
not simply apply a convex-domain mean-value theorem.

The formal development derives the exact Cartesian Jacobian,
optimizes its row sums, proves an admissible secant lower bound,
establishes the tangential \(5/4\) estimate on all safe coordinate
planes, and integrates it along safe segments. These arguments
combine to identify the sharp global coefficient.

## Why the result may matter — intended audience

The estimate is relevant to mathematical analysis of singular
inverse-square fields and to **validated numerical calculations**
using Cartesian boxes or octrees, including rigorous gravitational
N-body bounds. It can supply a physically exact, dimensionless
sensitivity coefficient when source clearance is certified.
It does not, by itself, verify any particular integrator, tree
approximation, collision probability, convergence rate, or
computational speedup.

## Status

**Lean-verified mathematical results:** R016–R017 prove exact
existence, uniqueness and scalar maximality of \(C_3\).
R024–R032 establish physical derivative bounds and sharpness.
R033–R037 prove admissible secants and the necessary global
lower bound. R038–R046 provide safe-pair geometry and the
tangential physical derivative estimate. R047 proves the
unconditional global one-source bound, and R048 proves an
exact one-source optimality equivalence and unconditional
finite-source bounds for the physical nonlinear sum model.

**Independent comparison:** The two statements selected
in `comparator.json` have passed the dedicated Comparator
check: the exact Solution was accepted by con-ron, NanoDa
and Lean's default kernel. The Challenge imports Mathlib only;
the Solution connects its physical statement to the substantive
development. This verification is separate from Palomar
registration and external mathematical peer review.

**Scope and limitations:** \(G\geq0\) and nonnegative masses
are used. The coefficient is optimal over the whole
family of admissible configurations, not asserted as attained
for every individual multi-source configuration. No
literature-wide priority, external mathematical peer review,
application-level benchmark or Palomar registration is claimed.

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
**Limit:** This algebraic lemma alone is not an operator-norm
bound; later R024–R027 establish the sharp derivative bound.

**Lean:** `lateralRowNumerator_le_dominant`,
`lateralRowNumerator_swapped_le_dominant`,
`dominantRowNumerator_le_diagonal`.
**Source:** [JacobianRows.lean](NewtonianLipschitz/JacobianRows.lean).

### R012 — Candidate stationary cubic

For `p(t)=2*t^3-8*t^2-4*t+1`, the cubic is strictly decreasing
on `[0,1]`, positive at `9/50`, negative at `1/5`, and has
at most one zero in that interval.

**Why useful:** Exact information about a possible maximizer.
**Limit:** These cubic properties alone do not prove the
maximizer; existence and scalar maximality follow in R016–R017.

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
**Limit:** This first-row identity alone gives neither
the other rows (R019) nor the global norm bound (R024–R027).

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
**Limit:** This first-row reduction alone is not a
global operator-norm or optimality theorem; later results
address the derivative, not the full nonconvex domain.

**Lean:** `newtonianJacobianMatrix_normalized_firstRow_le_diagonal`.
**Source:** [JacobianMatrix.lean](NewtonianLipschitz/JacobianMatrix.lean).

### R016 — Exact existence and uniqueness of the critical cubic root

Lean proves that there is exactly one real number
$t_* \in [9/50,1/5]$ satisfying the equation

$
2t_*^3 - 8t_*^2 - 4t_* + 1 = 0.
$

This number is the **critical parameter** for the proposed
sharp coefficient. In Lean it is called
`candidateCriticalPoint`. The interval gives a rigorous
rational enclosure, without using any floating-point value.

For orientation, $t_* \approx 0.1848316796$. This decimal
is a numerical approximation, **not a Lean-certified
decimal enclosure**; the exact root and its uniqueness
are what Lean formally verifies.

**Why useful:** Identifies the precise algebraic parameter
that R017 proves maximizes the candidate coefficient.
**Limit:** A unique stationary root does not by itself
prove maximality or any global gravitational Lipschitz
inequality; these are separate mathematical obligations.

**Lean:** `stationaryCubic_exists_root_bracket`,
`stationaryCubic_existsUnique_root_bracket`,
`candidateCriticalPoint_spec`.
**Source:** [CubicCandidate.lean](NewtonianLipschitz/CubicCandidate.lean).

### R017 — Exact maximum of the scalar candidate coefficient

Define the following dimensionless scalar function:

$
f(t) = \frac{2+6t-2t^2}{(1+2t^2)^{5/2}},
\qquad 0 \le t \le 1.
$

Let $t_*$ be the **unique root** specified in R016.
Lean proves that $f(t) \le f(t_*)$ for every $t \in [0,1]$.
Thus the exact candidate gravitational coefficient is

$
\boxed{C_3 = f(t_*) =
\frac{2+6t_*-2t_*^2}{(1+2t_*^2)^{5/2}}}.
$

Numerically, $C_3 \approx 2.5775644212$. This decimal
is **not yet certified as an interval in Lean**: the
Lean-verified result is the exact formula and the proof
that it is the maximum of $f$ on $[0,1]$.

In Lean the function is `candidateCoefficient` and the
exact maximum is `candidateMaximum`. The proof computes
the derivative of $f$, analyzes the stationary cubic from
R016, and establishes the maximum without assuming any
numerical approximation.

**Why useful:** Determines $C_3$ by an exact equation
rather than merely proposing a numerical constant.
Later results R018–R027 apply it to the physical Jacobian
and the pointwise directional derivative upper bound.
**Limit:** Maximizing $f$ does not establish that $C_3$
is the smallest coefficient for the global two-point
gravitational inequality outside nonconvex safety cubes.
R037 later proves the necessary global two-point
coefficient lower bound, and R047 subsequently proves
the matching nonconvex global upper bound.

**Lean:** `candidateCoefficient_hasDerivAt`,
`candidateCoefficient_le_at_criticalPoint`,
`candidateMaximum`, `candidateMaximum_eq`.
**Source:** [ScalarMaximum.lean](NewtonianLipschitz/ScalarMaximum.lean).


### R018 — Candidate maximum bounds the normalized first Jacobian row

For `mu >= 0` and `0 <= u,v <= 1`, the absolute
first-row sum of the physical Jacobian at `(1,u,v)`
is at most `mu*candidateMaximum`, with the exact scalar
maximum defined and proved in R017.

**Why useful:** Applies the scalar maximum to the actual
Jacobian of the Newtonian field.
**Limit:** This first-row lemma alone does not cover the
other rows and arbitrary signed/scaled points; R019–R027
provide those derivative estimates.

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
**Limit:** This normalized-octant statement alone omits
arbitrary signs and non-unit scales, handled later in
R020–R027.

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
**Limit:** This symmetry result alone does not establish
the unrestricted Jacobian bound (R024–R027) or any
global nonconvex two-point inequality.

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
**Limit:** The permutation identities alone do not prove
the unrestricted sharp derivative bound (R024–R027)
or the nonconvex global two-point theorem.

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
**Limit:** This positive-X case alone does not cover
dominant Y/Z coordinates (R023), signs (R024), or
the resulting Cartesian derivative-norm bound (R027).

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
**Limit:** This nonnegative-orthant case alone does not
cover signed coordinates (R024) or the sharp operator
bound (R027). Global nonconvex differences remain open.

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

### R025 — Sharp Cartesian Jacobian bound at positive clearance

Lean verifies that the norm of a Cartesian displacement
is exactly `max(|X|,|Y|,|Z|)`. Thus, for `x != 0`,
each absolute row sum of the physical Jacobian is bounded by

`mu*candidateMaximum / norm_inf(x)^3`.

When `d > 0` and `norm_inf(x) >= d`, the bound is
`mu*candidateMaximum / d^3`. Lean also verifies that
the exact scalar candidate maximum is nonnegative.

**Why useful:** States the previously proved sharp row
estimate in the actual Cartesian norm and under the cube
clearance hypothesis used in the proposed theorem.
**Limit:** A row-sum bound does not by itself certify the
Frechet operator norm, a global two-point inequality on
nonconvex domains, or optimality.

**Lean:** `cartesian_norm_eq_max_abs`,
`newtonianJacobianMatrix_rowSum_le_candidateMaximum_norm`,
`candidateMaximum_nonneg`,
`newtonianJacobianMatrix_rowSum_le_candidateMaximum_clearance`.
**Source:**
[JacobianCartesianBound.lean](NewtonianLipschitz/JacobianCartesianBound.lean).

### R026 — Candidate bound on the actual Frechet derivative action

For nonzero Cartesian separation x, any direction h and
nonnegative gravitational parameter mu, Lean proves

`norm_inf((fderiv accelerationField x) h)
  <= mu*candidateMaximum*norm_inf(h)/norm_inf(x)^3`.

The derivative here is the genuine Frechet derivative of
the physical Newtonian point-source acceleration field.
The proof bounds each matrix-vector coordinate through its
corresponding absolute Jacobian row sum.

**Why useful:** Supplies the directional estimate from
which an induced operator-norm bound can be proved.
**Limit:** This action estimate alone is not the
operator-norm theorem (R027) or the global two-point
estimate. R037 later proves the necessary lower bound.

**Lean:** `matrix3_mulVec_coordinate_abs_le_rowSum`,
`newtonianJacobianMatrix_mulVec_norm_le_candidateMaximum`,
`NewtonianPointSource.accelerationField_fderiv_norm_le_candidateMaximum`.
**Source:**
[JacobianOperatorAction.lean](NewtonianLipschitz/JacobianOperatorAction.lean).

### R027 — Candidate bound for the true Frechet operator norm

Lean proves the candidate upper bound on the **induced
Cartesian supremum operator norm** of the actual point-source
Frechet derivative, for every nonzero source displacement x:

```text
norm(fderiv accelerationField x)
  <= mu*candidateMaximum / norm_inf(x)^3.
```

Under positive Cartesian clearance `norm_inf(x) >= d > 0`,
the same norm is at most `mu*candidateMaximum/d^3`.
The gravitational parameter `mu` is nonnegative.

**Why useful:** Completes the rigorous passage from the
physical Jacobian's row estimates (R024–R025) through its
directional action (R026) to the derivative operator norm.
**Limit:** An upper bound alone does not prove optimality.
It also does not imply a two-point Lipschitz bound for
arbitrary points outside the nonconvex safety cubes.

**Lean:**
`NewtonianPointSource.accelerationField_fderiv_opNorm_le_candidateMaximum`,
`NewtonianPointSource.accelerationField_fderiv_opNorm_le_clearance`.
**Source:**
[JacobianOperatorNorm.lean](NewtonianLipschitz/JacobianOperatorNorm.lean).

### R028 — Exact attainment of the candidate Jacobian row bound

At the Cartesian displacement `x = (1,t_star,t_star)`,
where `t_star` is the exact critical root of R016,
Lean proves

```text
norm_inf(x) = 1
sum_j abs(J(1,x)[X,j]) = C3.
```

Here `J(1,x)` is the physical Newtonian Jacobian with
unit gravitational parameter, and `C3` is the exact
candidate maximum defined and maximized in R017.
The proof first establishes the row-sum identity at
every diagonal displacement `(1,t,t)` for `0 <= t <= 1`.

**Why useful:** Provides a concrete exact equality
witness, showing that the universal Jacobian row-sum
upper bound cannot be improved.
**Limit:** The row witness alone does not establish
the operator-norm equality (R029), nor the global
two-point estimate, subsequently proved in R047.

**Lean:** `normalized_diagonal_radius`,
`newtonianJacobianMatrix_diagonal_firstRow_eq_coefficient`,
`criticalDiagonal_cartesian_norm_eq_one`,
`newtonianJacobianMatrix_critical_firstRow_eq_candidateMaximum`.
**Source:**
[JacobianSharpWitness.lean](NewtonianLipschitz/JacobianSharpWitness.lean).

### R029 — Exact attainment of the Frechet operator norm C3

For the unit-parameter Newtonian source and the critical
Cartesian displacement `x = (1,t_star,t_star)`, Lean proves

```text
norm_inf(x) = 1
norm_operator(fderiv accelerationField x) = C3.
```

The proof chooses a Cartesian direction whose components
match the signs of the first Jacobian row. Its matrix
action then equals the exact row sum established in R028.
The verified operator-norm upper bound of R027 supplies
the reverse inequality.

**Why useful:** Shows that C3 is the smallest universal
coefficient for the **pointwise Cartesian derivative
operator-norm estimate** at unit clearance. The bound
is attained by an actual physical Newtonian field.
**Limit:** Derivative-norm equality does not automatically
prove a matching admissible two-point difference quotient
or a global Lipschitz bound across nonconvex safety cubes.

**Lean:** `matrix3_exists_rowSum_attaining_direction`,
`NewtonianPointSource.unitAxis_fderiv_opNorm_ge_candidateMaximum`,
`NewtonianPointSource.unitAxis_fderiv_opNorm_eq_candidateMaximum`.
**Source:**
[JacobianOperatorWitness.lean](NewtonianLipschitz/JacobianOperatorWitness.lean).

### R030 — Candidate finite-difference bound on convex safe domains

Lean proves an actual **two-point** sensitivity estimate
for the Newtonian acceleration of one point source on
every convex set `S` with positive Cartesian clearance:

```text
d > 0 and norm_inf(z) >= d for every z in S;
x, y in S imply
norm_inf(g(x)-g(y))
  <= (mu*C3/d^3) * norm_inf(x-y).
```

Here `mu >= 0` is the source gravitational parameter.
The proof uses the verified Frechet operator-norm
upper bound (R027) and the mean-value inequality on
convex sets; it bounds physical finite differences.

**Why useful:** Bridges the exact pointwise derivative
estimate to genuine Lipschitz control on convex
Cartesian-safe domains, with the same coefficient C3.
**Limit:** Two safe endpoints do not imply their joining
segment is safe. The exterior of an open safety cube is
nonconvex, so no unrestricted two-point claim follows.
R037 later proves the necessary two-point lower bound
and R047 the full nonconvex C3 upper estimate.

**Lean:**
`NewtonianPointSource.accelerationField_norm_sub_le_candidateMaximum_convex`.
**Source:**
[ConvexSharp.lean](NewtonianLipschitz/ConvexSharp.lean).

### R031 — Sharp two-point bound on a certified Cartesian box

Let `B = ball_inf(anchor,rho)` be an open Cartesian
box, namely a metric ball for the supremum norm.
For `d > 0`, suppose the center-margin condition holds:

```text
d + rho <= norm_inf(anchor).
```

Lean proves `norm_inf(z) >= d` for every `z in B`.
Consequently, the actual Newtonian point-source field
satisfies for every `x,y in B`:

```text
norm_inf(g(x)-g(y))
  <= (mu*C3/d^3) * norm_inf(x-y).
```

**Why useful:** Converts the verified convex-domain
estimate R030 into an explicit, checkable Cartesian
box certificate applicable to spatial enclosures.
**Limit:** The claim concerns two points within the
same certified convex box and one point source.
It does not extend automatically to arbitrary safe
points separated by a nonconvex forbidden region.

**Lean:** `cartesianBox_clearance_of_center_margin`,
`NewtonianPointSource.accelerationField_norm_sub_le_candidateMaximum_box`.
**Source:**
[CartesianBoxSharp.lean](NewtonianLipschitz/CartesianBoxSharp.lean).

### R032 — Least universal Cartesian derivative-norm coefficient

For any real `K`, Lean proves that if, for all Newtonian
point sources with nonnegative gravitational parameter
`mu` and every nonzero Cartesian displacement `x`,

```text
norm_operator(fderiv accelerationField x)
  <= mu*K/norm_inf(x)^3,
```

then necessarily `C3 <= K`. In particular, every
`K < C3` fails as a universal pointwise bound.
The proof evaluates the assumed estimate at the
unit-parameter critical diagonal witness of R029.

**Why useful:** Establishes the quantified **minimality**
of C3 for all universal Cartesian derivative-norm
estimates, rather than just displaying equality.
**Limit:** This is derivative minimality, not two-point
minimality; R037 later proves the necessary coefficient
lower bound for admissible pairs. The upper bound is open.

**Lean:** `candidateMaximum_le_of_universal_fderiv_opNorm_bound`,
`candidateMaximum_no_smaller_universal_fderiv_bound`.
**Source:**
[DerivativeCoefficientMinimality.lean][derivative-minimality].

### R033 — A direction attaining the physical derivative action

At the exact critical displacement
`x_star = (1,t_star,t_star)` for a unit-parameter
Newtonian point source, Lean proves the existence of
a Cartesian direction `h` with `norm_inf(h) <= 1`
such that

```text
norm_inf((fderiv accelerationField x_star) h) = C3.
```

This is an **actual action of the physical derivative**,
not merely an abstract operator-norm equality.
The proof chooses signs matching the critical
Jacobian row and compares with the R029 upper bound.

**Why useful:** Supplies a precise directional witness
for a future local difference-quotient argument and
a route toward optimality of finite-difference bounds.
**Limit:** R033 alone gives no clearance certificate;
R034–R035 supply that geometry and distinct safe pairs.
R033 alone does not give two-point minimality; R036–R037
establish its lower-bound implication.

**Lean:**
`NewtonianPointSource.unitAxis_fderiv_exists_attaining_direction`.
**Source:**
[DerivativeAttainingDirection.lean][derivative-direction].

### R034 — Admissible outward ray attaining the derivative norm

At the unit-Cartesian-norm critical displacement
`x_star = (1,t_star,t_star)`, Lean proves that an
attaining derivative direction can be oriented
outward, with `norm_inf(h) <= 1` and

```text
norm_inf((fderiv accelerationField x_star) h) = C3.
norm_inf(x_star + s*h) >= 1 for every s >= 0.
```

The proof uses the invariance of derivative-action
norm under `h -> -h` and chooses the sign with
nonnegative first Cartesian component. Since
`(x_star)_X = 1`, the forward ray cannot enter
the forbidden open unit cube around the source.

**Why useful:** Connects the pointwise sharpness
witness (R033) to the actual cubical clearance
geometry required by the global theorem.
**Limit:** This ray alone does not establish the
secant quotient limit (proved later in R036) or
the global C3 upper bound (proved later in R047).

**Lean:**
`NewtonianPointSource.unitAxis_exists_outward_attaining_direction`,
`criticalDiagonal_outward_ray_cartesian_clearance`,
`NewtonianPointSource.unitAxis_exists_safe_sharp_outward_ray`.
**Source:**
[AdmissibleCriticalDirection.lean][admissible-critical].

### R035 — Distinct safe secant pairs of exact Cartesian step length

Let `x_star = (1,t_star,t_star)` denote the critical
unit-clearance displacement for the unit-parameter
Newtonian field. Lean proves that there is a direction
`h` with `norm_inf(h) = 1` and

```text
norm_inf((fderiv accelerationField x_star) h) = C3.
```

For every `s > 0`, the perturbed point
`y_s = x_star + s*h` satisfies

```text
norm_inf(y_s) >= 1,
norm_inf(y_s - x_star) = s,
y_s != x_star.
```

Together with `norm_inf(x_star) = 1` (R028), this
gives two distinct admissible endpoints outside
the open unit safety cube, with known separation.
The proof also certifies `C3 > 0`, forcing an
attaining direction of norm at most one to have
norm exactly one.

**Why useful:** Supplies admissible secant pairs in
the same critical direction that saturates the
derivative bound, preparing a rigorous limiting
finite-difference quotient argument.
**Limit:** Neither the limit of the secant quotient
nor global optimality of the nonconvex two-point
bound is established by these geometric witnesses.

**Lean:** `candidateMaximum_pos`,
`NewtonianPointSource.unitAxis_exists_safe_distinct_secant_pairs`.
**Source:**
[AdmissibleSecantPairs.lean][admissible-secant].


### R036 — Exact right-hand limit of admissible Newtonian secants

At the critical displacement `x_star=(1,t_star,t_star)`
for the unit Newtonian source, Lean proves the existence
of a unit Cartesian direction `h` such that, for every
`s>0`, the endpoints `x_star` and `x_star+s*h`
remain outside the forbidden unit cube, are distinct,
and are exactly `s` apart in the supremum norm.

Along these **actual physical finite differences**, Lean proves

```text
lim_(s -> 0+) norm_inf((g(x_star+s*h)-g(x_star))/s) = C3.
```

The proof uses the noncollision differentiability of the
Newtonian field and the sharp derivative-action witness.

**Why useful:** Supplies the admissible finite-difference
limit required for a universal coefficient lower bound.
**Limit:** This limit does not give an upper estimate
for arbitrary pairs whose connecting segments are unsafe.

**Lean:**
`NewtonianPointSource.unitAxis_exists_safe_secant_quotient_limit`.
**Source:** [AdmissibleSecantPairs.lean][admissible-secant].

### R037 — Minimality necessary for any global two-point coefficient

Lean proves that if `K` satisfies, for **every**
`x,y : Vec3` with `norm_inf(x)>=1` and `norm_inf(y)>=1`,

```text
norm_inf(g_unit(x)-g_unit(y)) <= K * norm_inf(x-y),
```

then `C3<=K`. Consequently a strictly smaller
`K<C3` cannot satisfy this universal two-point
inequality even for the single unit-parameter source.
The proof bounds R036's secants by `K`, and passes
to their right-hand limit.

**Why useful:** Closes the missing lower-bound side of
the unit-source two-point optimality problem.
**Limit:** The **global upper bound with C3** is not
established; neither the arbitrary-clearance multi-source
upper theorem nor Comparator is complete.

**Lean:**
`candidateMaximum_le_of_universal_safe_secant_bound`,
`candidateMaximum_no_smaller_universal_safe_secant_bound`.
**Source:** [AdmissibleSecantPairs.lean][admissible-secant].

### R038 — Sharp global upper estimate for long safe separations

For a single Newtonian point source with
gravitational parameter μ ≥ 0 and any positive Cartesian
clearance d, Lean proves that admissible points x,y with

```text
d <= norm_inf(x),  d <= norm_inf(y),
d <= norm_inf(x-y)
```

satisfy the physical finite-difference inequality

```text
norm_inf(g(x)-g(y))
  <= (μ*C3/d^3)*norm_inf(x-y).
```

The proof shows `norm_inf(g(z)) <= μ/d²` at each
safe endpoint, uses `C3 >= 2`, and applies the
triangle inequality. The connecting segment may
cross the forbidden cube.

**Why useful:** Handles all sufficiently far safe pairs
without convexity, and isolates smaller separations.
**Limit:** This does not treat pairs with
`norm_inf(x-y)<d` merely from endpoint clearance.

**Lean:**
`candidateMaximum_ge_two`,
`NewtonianPointSource.accelerationField_norm_le_of_cartesian_clearance`,
`NewtonianPointSource.accelerationField_norm_sub_le_candidateMaximum_long`.
**Source:** [LongSeparation.lean][long-separation].

### R039 — Common safe supporting face and far-or-face reduction

For positive clearance d, Lean proves that the
positive and negative coordinate supporting halfspaces

```text
{z | d <= z_i},    {z | z_i <= -d}
```

are convex, and every point in either halfspace has
Cartesian clearance at least d. Applying R030 gives
the same physical C3 finite-difference inequality
whenever two endpoints share one such halfspace.

An additional Lean theorem combines R038 and R039:
the bound holds if **either** `d <= norm_inf(x-y)`
**or** there exists a coordinate i such that
`d <= x_i,y_i` or `x_i,y_i <= -d`.

**Why useful:** Certifies another nonconvex-domain case
for arbitrarily close pairs and isolates the
short cross-face configuration later resolved by R047.
**Limit:** R039 alone does not cover the residual
cross-face case; R047 supplies the global solution.
The full Palomar comparison remains independent
of these individual lemmas.

**Lean:**
`cartesianPositiveSafeHalfspace_convex`,
`cartesianNegativeSafeHalfspace_convex`,
`NewtonianPointSource.accelerationField_norm_sub_le_candidateMaximum_common_face`,
`NewtonianPointSource.accelerationField_norm_sub_le_candidateMaximum_far_or_common_face`.
**Source:** [CommonSafeFace.lean][common-safe-face].

### R040 — Safe coordinate bridge and nonsharp cross-face estimate

For two points `x,y : Vec3` with positive clearance
`d`, suppose `x` has a safe coordinate on axis `i`
and `y` has a safe coordinate on another axis `j`:

```text
i != j,
(x_i >= d or x_i <= -d),
(y_j >= d or y_j <= -d).
```

Lean constructs a point `w` whose i-th coordinate
equals `x_i` and j-th coordinate equals `y_j`,
such that both hops satisfy

```text
norm_inf(x-w) <= norm_inf(x-y),
norm_inf(w-y) <= norm_inf(x-y).
```

The first hop stays in the supporting halfspace of
`x` and the second in that of `y`. R039 bounds
each field difference with C3; the triangle
inequality then proves the actual physical
finite-difference bound

```text
norm_inf(g(x)-g(y))
  <= (2*C3*μ/d^3)*norm_inf(x-y).
```

No assumption on clearance of the direct segment
or a minimum separation is required.

**Why useful:** Supplies a constructive safe piecewise
path for different-axis endpoint pairs and a fully
verified nonsharp global-scale estimate on that case.
**Limit:** The factor 2 is **not sharp** and does not
establish the desired C3 estimate for short cross-face
pairs. No full one-source or N-source sharp theorem
follows from R040, and Comparator remains inactive.

**Lean:**
`cartesian_different_axes_two_hop_bridge`,
`NewtonianPointSource.accelerationField_norm_sub_le_two_candidateMaximum_different_axes`.
**Source:** [CrossFaceTwoHop.lean][cross-face-two-hop].

### R041 — Conditional sharp finite-source lifting from one source

Lean defines `oneSourceGlobalCandidateBound : Prop`
as the then-open assertion that **every** admissible
two-point Newtonian force difference for a single source
satisfies the global C3 estimate, without requiring the
connecting segment to remain outside the forbidden cube.
This is a proposition, **not** a proof of that assertion.

**Assuming that proposition**, Lean proves for the
existing exact finite-source differential acceleration
sum and positive clearance d at both observation points:

```text
norm_inf(sum_k (g_k(a_k+q)-g_k(a_k)))
  <= (C3/d^3) * (sum_k mu_k) * norm_inf(q).
```

Here `a_k` is each source's initial displacement and
`q` is the common observation-point difference. If
each source gravitational parameter satisfies
`mu_k <= M`, the same verified implication gives

```text
norm_inf(total differential acceleration)
  <= (N*M*C3/d^3) * norm_inf(q),
N = sources.length.
```

The proof uses induction over the source list,
exact nonlinear field differences, the triangle
inequality and the cap on the sum of source parameters.
No force linearization is introduced.

**Why useful:** Removes the finite-source summation
step as an additional analytic obstacle for the proposed
second Palomar theorem. Once the one-source sharp upper
bound is proved, the corresponding N-source inequality
follows through this formalized reduction.
**Limit:** R041 is a conditional implication, not
by itself a proof of its premise. R047 subsequently
proves `oneSourceGlobalCandidateBound`, and R048
packages the resulting unconditional finite-source
estimates. Comparator is a separate check.

**Lean:**
`oneSourceGlobalCandidateBound`,
`NewtonianPointSource.finiteDifferentialAcceleration_norm_le_of_oneSourceGlobal`,
`sourceGravitationalParameter_sum_le_length_mul`,
`NewtonianPointSource.finiteDifferentialAcceleration_norm_le_length_mul_of_oneSourceGlobal`.
**Source:** [ConditionalFiniteSource.lean][conditional-finite-source].

### R042 — Safe-plane tangential algebra and exact C3 margin

For arbitrary real normalized coordinates u,v, put
t = u²+v² ≥ 0. Lean verifies the exact denominator
certificate

```text
12*t <= (1+t)^5.
```

Its proof expands the difference into a sum of
nonnegative square and power terms. Lean also proves
the squared first-row numerator estimate

```text
(3*(u+v))^2 <= (5/4)^2 * (1+t)^5
```

and, for u,v ≥ 0, the lateral tangential numerator estimate

```text
abs(2*u^2-1-v^2) + 3*u*v <= (5/4)*(1+t)^2.
```

The third lateral row follows from exchanging u and v.
Finally, **C3 > 5/2** is proved without decimal estimates,
by evaluating the previously verified exact candidate
coefficient at t = 1/5 and bounding its square root using
a rational comparison.

**Why useful:** Supplies Lean-checked scalar inequalities
for a prospective **5/4 bound on the physical Newtonian
derivative restricted to directions parallel to a safe
coordinate plane**. A two-hop argument with this
tangential factor would yield a cross-face coefficient
5/2, strictly below C3.

**Limit:** The result is **algebraic only**: it does
not yet establish the 5/4 bound for the actual physical
Jacobian, integrate that bound along safe planes, or
prove an unrestricted one-source/N-source global C3
inequality at the stage of R042. The later results
R044–R048 supply the physical and global conclusions.

**Lean:**
`tangential_denominator_fifth_power_ge_twelve`,
`tangential_first_row_squared_le_five_four`,
`tangential_lateral_row_le_five_four_quadratic`,
`candidateMaximum_gt_five_halves`.
**Source:** [TangentialAlgebra.lean][tangential-algebra].

### R043 — Conditional global C3 bound from safe-plane 5/4 estimates

Lean defines `oneSourceSafePlaneFiveFourthBound : Prop`
as an explicit premise, subsequently proved in R047,
that the exact Newtonian acceleration difference between any two points
sharing a fixed signed-safe coordinate (absolute coordinate
at least d > 0) is bounded by

```text
norm_inf(g(x)-g(y)) <= (5/4)*(mu/d^3)*norm_inf(x-y).
```

R043 proves that every endpoint outside the cube has a
signed-safe coordinate, then formally reduces **every**
pair of admissible endpoints to the following cases:

- **Same axis, same side:** R039 supplies the existing
  verified C3 estimate on their common safe halfspace.
- **Same axis, opposite sides:** the endpoints are far
  enough apart for R038's verified C3 bound.
- **Different safe axes:** R040's verified two-hop bridge
  retains a fixed safe coordinate along each hop. Assuming
  the safe-plane 5/4 proposition, the two hops give
  5/2 times the normalized coefficient, and R042 has
  already certified the strict inequality 5/2 < C3.

Consequently Lean proves the formal implication

```text
oneSourceSafePlaneFiveFourthBound
  -> oneSourceGlobalCandidateBound.
```

R041 then provides the existing separate **conditional**
lifting from the one-source global proposition to finite
source sums.

**Why useful:** Reduces the entire missing nonconvex
one-source global sharp upper bound to **one explicit
physical safe-plane finite-difference estimate**. The
geometric exhaustion, including opposite-face and
different-axis pairs, is now independently checked
by Lean under that premise.

**Limit:** The safe-plane 5/4 proposition is **not
proved** here. R042 proves algebraic ingredients,
not yet their application to the physical derivative
or integration along safe planes. Therefore neither
the unconditional one-source sharp global C3 bound
nor the final N-source Palomar theorem is yet proved.
No independent Comparator verification is claimed.

**Lean:**
`oneSourceSafePlaneFiveFourthBound`,
`cartesian_exists_signed_safe_coordinate`,
`NewtonianPointSource.accelerationField_norm_sub_le_candidateMaximum_different_axes_of_safePlane`,
`cartesian_opposite_safe_sides_separated`,
`oneSourceGlobalCandidateBound_of_safePlaneFiveFourth`.
**Source:** [SafePlaneReduction.lean][safe-plane-reduction].

### R044 — Physical Newtonian tangential derivative at a normalized safe plane

At the normalized displacement
`x = (1,u,v)`, with `u,v >= 0` (no upper
bounds on u or v), the first coordinate x0=1
is held fixed. Lean proves for **every row** of
the actual physical Newtonian Jacobian matrix

```text
abs(J(row,1)) + abs(J(row,2)) <= (5/4)*mu,
mu >= 0.
```

The exact physical Euclidean radius is used; the
proof invokes the scalar radial and tangential
numerator estimates from R042, then the existing
verified Cartesian Jacobian-entry formulas.
A generic restricted-column matrix inequality
bounds the matrix action on directions with first
component zero. Finally, the existing identity
between the physical Newtonian Frechet derivative
and this matrix gives

```text
norm_inf(Dg_mu(1,u,v) * h)
    <= (5/4)*mu*norm_inf(h),
u >= 0, v >= 0, h_0 = 0.
```

**Why useful:** Establishes the previously missing
link from scalar tangential algebra to the **real
physical Newtonian derivative**, with no replacement
field, no linearized force difference, and no numerical
value for C3. It is the normalized, nonnegative-coordinate
core for the single safe-plane physical 5/4 estimate.

**Limit:** The theorem is only for normalized points
(1,u,v), u,v >= 0, with tangential directions h_0=0.
It does **not**, on its own, establish the all-axis
safe-plane derivative, finite differences or global
C3 inequality. The succeeding R045–R047 theorems
discharge those obligations, followed by R048.

**Lean:**
`tangential_normalized_radius_bounds`,
`tangential_normalized_first_numerator_le_radius`,
`tangential_normalized_lateral_numerator_le_radius`,
`newtonianJacobianMatrix_normalized_tangent_columns_le`,
`matrix3_mulVec_tangent_zero_norm_le`,
`NewtonianPointSource.accelerationField_fderiv_normalized_tangent_le`.
**Source:** [PhysicalTangentialNormalized.lean][physical-tangential-normalized].

### R045 — Physical tangential derivative for arbitrary signs and first-axis clearance

Lean extends R044's genuine physical Newtonian
Jacobian restriction from the normalized nonnegative
point (1,u,v) to **every signed displacement** x
satisfying

```text
d > 0, d <= abs(x_0), mu >= 0.
```

For every row of the exact Cartesian Jacobian, the
sum of the two columns tangential to the first-axis
safe plane satisfies

```text
abs(J(row,1)) + abs(J(row,2))
    <= (5/4)*mu/d^3.
```

The proof uses the previously verified invariance
of the *actual* Jacobian's absolute entries under
coordinate sign changes and its exact inverse-cube
scaling under positive spatial dilation. It then
applies R044's normalized physical matrix estimate.
Consequently, for the actual Frechet derivative and
any direction h with h_0=0, Lean proves

```text
norm_inf(Dg_mu(x)*h)
    <= (5/4)*(mu/d^3)*norm_inf(h).
```

**Why useful:** Removes the normalized-coordinate
and nonnegative-octant restrictions for one fixed
safe Cartesian axis while retaining the exact physical
Euclidean radius and factor 5/4. This is a direct
step toward the plane premise isolated in R043.

**Limit:** It covers only **axis 0 as the fixed safe
coordinate**, not axes 1 or 2. It bounds true derivatives,
not yet two-point force differences on a safe plane.
This single-axis lemma alone does not yield the
global estimate; R046 and R047 subsequently complete
the derivative and finite-difference steps.

**Lean:**
`newtonianJacobianMatrix_first_safe_axis_tangent_columns_le`,
`NewtonianPointSource.accelerationField_fderiv_first_safe_axis_tangent_le`.
**Source:** [PhysicalTangentialFirstAxis.lean][physical-tangential-first-axis].

### R046 — Physical 5/4 tangential derivative on every safe Cartesian axis

For any Cartesian coordinate i, any signed physical
displacement x, positive clearance d, nonnegative
gravitational parameter mu and direction h satisfying

```text
d > 0, d <= abs(x_i), h_i = 0,
```

Lean proves the true physical Newtonian Fréchet
derivative estimate

```text
norm_inf(Dg_mu(x)*h)
    <= (5/4)*(mu/d^3)*norm_inf(h).
```

The proof **does not** re-maximize the physical
Jacobian. It uses R045 and the existing verified
cyclic permutation identity for exact Newtonian
Jacobian entries. The second- and third-axis
restricted column-sum bounds and the corresponding
matrix-vector action bounds are then proved
without restricting the signs of any coordinate.

**Why useful:** Completes the pointwise physical
tangential derivative estimate on **all three
signed-safe coordinate planes**. In a fixed safe
plane, the displacement between any two points
has zero component on the corresponding axis.
R046 therefore supplies the needed directional
derivative bound at every point of that segment.

**Limit:** R046 is still a **pointwise derivative**
result, not an actual two-point safe-plane inequality.
The theorem itself is pointwise, not yet a
two-point inequality; R047 subsequently proves the
safe-plane integral estimate and the global one-source
bound, with R048 covering the finite-source model.

**Lean:**
`newtonianJacobianMatrix_second_safe_axis_tangent_columns_le`,
`newtonianJacobianMatrix_third_safe_axis_tangent_columns_le`,
`matrix3_mulVec_tangent_one_norm_le`,
`matrix3_mulVec_tangent_two_norm_le`,
`newtonianJacobianMatrix_any_safe_axis_tangent_columns_le`,
`NewtonianPointSource.accelerationField_fderiv_any_safe_axis_tangent_le`.
**Source:** [PhysicalTangentialAllAxes.lean][physical-tangential-all-axes].

### R047 — Safe-plane finite differences and unconditional global single-source C3

Lean proves for the exact physical Newtonian
acceleration `g_mu`, any `d>0` and points x,y
with one identical signed-safe coordinate i,

```text
x_i = y_i,  d <= x_i or x_i <= -d
  =>
norm_inf(g_mu(x)-g_mu(y))
  <= (5/4)*(mu/d^3)*norm_inf(x-y).
```

It parametrizes the entire safe segment by
`z(t) = x + t*(y-x)`, `0 <= t <= 1`.
The fixed coordinate remains signed-safe,
so every `z(t)` avoids the Newtonian source.
The derivative of the **actual acceleration
composed with this path** follows by the
Fréchet/ordinary derivative chain rule. R046
bounds that true path derivative by
`(5/4)*(mu/d^3)*norm_inf(y-x)`.
A Mathlib mean-value norm inequality on
`[0,1]` yields the finite-difference result.

This resolves the explicit R043 proposition
`oneSourceSafePlaneFiveFourthBound`
**unconditionally**, and Lean then invokes
R043's already verified exhaustive geometric
case split to prove the proposition

```text
oneSourceGlobalCandidateBound
```

without additional assumptions. In other
words, for **every pair of points** outside
the open safety cube of one Newtonian source,
even when their direct chord is unsafe,

```text
norm_inf(g_mu(x)-g_mu(y))
  <= (mu*C3/d^3)*norm_inf(x-y).
```

**Why useful:** Resolves the previously open
sharp **one-source nonconvex global upper bound**.
R037 independently proves that a universal
coefficient strictly below C3 cannot work.
Combining their mathematical content establishes
the exact optimal universal global one-source
coefficient C3. R041's previously conditional
finite-source lifting now has a proved premise.

**Limit:** R047 does **not** yet package the
complete N-source physical mass/position
parametrization and universal optimality
as the second final Palomar declaration.
The first Palomar target, Challenge/Solution
interface and independent Comparator checking
remain to be assembled and validated.
No originality, review or submission is claimed.

**Lean:**
`NewtonianPointSource.accelerationField_norm_sub_le_fiveFourth_safePlane`,
`oneSourceSafePlaneFiveFourthBound_proved`,
`oneSourceGlobalCandidateBound_proved`.
**Source:** [SafePlaneFiniteDifference.lean][safe-plane-finite-difference].

### R048 — Exact one-source global optimality iff and unconditional finite-source bounds

Lean combines the R047 global upper bound with R037's
necessary lower bound in a single exact equivalence:
for the unit Newtonian source and the **closed
unit-cube exterior**, a real coefficient K satisfies

```text
for all safe x,y:
  norm_inf(g(x)-g(y)) <= K*norm_inf(x-y)
```

**if and only if** `C3 <= K`. This proves
optimality of C3 for genuine two-point differences,
not just for the derivative or convex subsets.

R048 also discharges the explicitly conditional
one-source hypothesis in R041, proving directly
for its existing exact finite-source nonlinear
differential-acceleration sum

```text
norm_inf(total differential acceleration)
  <= (sum_k(mu_k)*C3/d^3)*norm_inf(q)
  <= (N*M*C3/d^3)*norm_inf(q).
```

Here `mu_k >= 0` is each true Newtonian
gravitational parameter, `mu_k <= M`,
`N = sources.length`, and both observation
positions have clearance at least `d > 0`
from each source. The finite sum uses the
**exact force difference**, not a linearization.

**Why useful:** Formally closes the sharp
one-source theorem with an if-and-only-if
optimality statement and proves the expected
unconditional N-dependent upper bound for
the existing nonlinear finite-source model.
The theorem no longer assumes any unproved
global one-source premise.

**Limit:** The final planned Palomar statement
still requires the explicit physical G, masses
and source-position translation interface,
a matching N-source universal optimality
statement with clear assumptions, and
independent Comparator verification.
No external validation, publication or
submission is claimed.

**Lean:**
`unitSource_safe_global_bound_iff_candidateMaximum_le`,
`NewtonianPointSource.finiteDifferentialAcceleration_norm_le_sum_global`,
`NewtonianPointSource.finiteDifferentialAcceleration_norm_le_length_mul_global`.
**Source:** [UnconditionalFiniteSource.lean][unconditional-finite-source].

## Mathematical proof architecture

The sharp coefficient is obtained from the exact cubic-root
maximization, then transferred to the true Newtonian Jacobian
and Fréchet derivative. An admissible outward secant supplies
the optimality lower bound (R033–R037). On a fixed signed-safe
coordinate plane the stronger derivative constant \(5/4\) is
proved for the true physical force (R042–R046), and integrated
along a safe line segment (R047). A geometric case split then
extends the estimate to all admissible endpoint pairs on the
nonconvex cube exterior. The finite-source triangle inequality
and mass cap yield the \(N M\) factor (R041, R048).

The standalone Palomar theorem 1 states the exact cubic-root
maximization. Theorem 2 states the physical bound using actual
source positions \(a_k\), masses \(m_k\), \(G\), clearance \(d\)
and the exact Euclidean force law, together with universal
coefficient minimality from the unit-source case.

No mathematical result here establishes priority over the
existing literature or predicts an algorithmic speedup.

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
  [JacobianCartesianBound](NewtonianLipschitz/JacobianCartesianBound.lean),
  [JacobianOperatorAction](NewtonianLipschitz/JacobianOperatorAction.lean),
  [JacobianOperatorNorm](NewtonianLipschitz/JacobianOperatorNorm.lean),
  [JacobianSharpWitness](NewtonianLipschitz/JacobianSharpWitness.lean),
  [JacobianOperatorWitness](NewtonianLipschitz/JacobianOperatorWitness.lean),
  [ConvexSharp](NewtonianLipschitz/ConvexSharp.lean),
  [CartesianBoxSharp](NewtonianLipschitz/CartesianBoxSharp.lean),
  [DerivativeCoefficientMinimality][derivative-minimality],
  [DerivativeAttainingDirection][derivative-direction],
  [AdmissibleCriticalDirection][admissible-critical],
  [AdmissibleSecantPairs][admissible-secant],
  [LongSeparation][long-separation],
  [CommonSafeFace][common-safe-face],
  [CrossFaceTwoHop][cross-face-two-hop],
  [ConditionalFiniteSource][conditional-finite-source],
  [TangentialAlgebra][tangential-algebra],
  [SafePlaneReduction][safe-plane-reduction],
  [PhysicalTangentialNormalized][physical-tangential-normalized],
  [PhysicalTangentialFirstAxis][physical-tangential-first-axis],
  [PhysicalTangentialAllAxes][physical-tangential-all-axes],
  [SafePlaneFiniteDifference][safe-plane-finite-difference],
  [UnconditionalFiniteSource][unconditional-finite-source].
- Multiple sources: [FiniteSources](NewtonianLipschitz/FiniteSources.lean).

[derivative-minimality]: NewtonianLipschitz/DerivativeCoefficientMinimality.lean
[derivative-direction]: NewtonianLipschitz/DerivativeAttainingDirection.lean
[admissible-critical]: NewtonianLipschitz/AdmissibleCriticalDirection.lean
[admissible-secant]: NewtonianLipschitz/AdmissibleSecantPairs.lean
[long-separation]: NewtonianLipschitz/LongSeparation.lean
[common-safe-face]: NewtonianLipschitz/CommonSafeFace.lean
[cross-face-two-hop]: NewtonianLipschitz/CrossFaceTwoHop.lean
[conditional-finite-source]: NewtonianLipschitz/ConditionalFiniteSource.lean
[tangential-algebra]: NewtonianLipschitz/TangentialAlgebra.lean
[safe-plane-reduction]: NewtonianLipschitz/SafePlaneReduction.lean
[physical-tangential-normalized]: NewtonianLipschitz/PhysicalTangentialNormalized.lean
[physical-tangential-first-axis]: NewtonianLipschitz/PhysicalTangentialFirstAxis.lean
[physical-tangential-all-axes]: NewtonianLipschitz/PhysicalTangentialAllAxes.lean
[safe-plane-finite-difference]: NewtonianLipschitz/SafePlaneFiniteDifference.lean
[unconditional-finite-source]: NewtonianLipschitz/UnconditionalFiniteSource.lean

[NewtonianLipschitz.lean](NewtonianLipschitz.lean) is the library entry point.
The Lean 4 toolchain and Mathlib revision are pinned.

To reproduce the project, run in sequence:

1. `lake exe cache get`
2. `python3 scripts/check-repository.py`
3. `python3 scripts/check-documentation.py`
4. `python3 scripts/check-no-proof-holes.py`
5. `python3 scripts/check-comparator.py --require-selected`
6. `lake build NewtonianLipschitz Challenge Solution`
7. `bash scripts/verify-comparator.sh` (requires Bubblewrap
   and the bundled Lean independent kernels)

`Challenge.lean`, `Solution.lean` and `comparator.json`
select exactly the scalar theorem and the explicit
physical global Newtonian theorem. The selected comparison
has passed the independent con-ron, NanoDa and default
Lean kernels. This is not a Palomar registration or
external mathematical review.

## Methodology — transparent LLM-assisted research

The human research director sets the questions. AI-generated proofs
and text require verification. No `sorry`, `admit`, or unreviewed
axioms are allowed in substantive proofs.

A complete Lean build checks the formal statements as encoded.
It is different from **independent kernel checking**, scientific
peer review, physical validation, and proof of originality.

The exact root and scalar maximum, sharp nonconvex
single-source coefficient, and unconditional finite-source
bound are Lean-verified. The explicit physical
G/mass/center declarations are now compared as the
two standalone mathematical statements and have also
passed independent Comparator kernel checking.

This does not establish mathematical originality,
peer-reviewed publication, validated software performance
or Palomar acceptance. Preserve exact assumptions,
norms and source links. The cumulative mathematical
ledger documents proof content rather than software
activity. No novelty, priority or publication-readiness
claim is made.

## License

Apache License, Version 2.0 (Apache-2.0).
See [LICENSE](LICENSE).
