# NewtonianLipschitzOptimality

Lean 4 formalization of the exact Newtonian gravitational field in 3D
and its Lipschitz bounds in the Cartesian supremum norm.

## Executive summary

The objective is to prove the smallest universal sensitivity coefficient
under explicit positive-clearance and geometric domain assumptions.

The coefficient C3 is defined by an exact scalar
maximization and is attained by the operator norm of
the physical Newtonian derivative. It also gives a
proved finite-difference bound on **convex** domains,
including Cartesian boxes with explicit clearance. The main research
objective is the best universal two-point bound
outside nonconvex source-centered safety cubes.

The [Status](#status) section distinguishes verified
results from current proposals and open problems.
The [mathematical ledger](#results-acquired--cumulative-mathematical-ledger)
contains the complete cumulative proof record.

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

The exact scalar coefficient **C3** is defined and proved
in R016–R017; numerically it is about **2.5775644212**.
R029 proves that C3 is attained by the operator norm of
the physical Newtonian derivative at a critical point.
R030 proves a two-point inequality with C3 on **convex**
domains with uniform Cartesian clearance.

**The global conjecture below is stronger:** it covers
all safe endpoints, even when their connecting segment
passes through a forbidden cube. Its universal **upper
bound is not yet proved**. R036–R037 establish the
separate necessary lower bound for any proposed universal
coefficient, using physically admissible secants.
R038 proves the proposed upper bound for sufficiently separated
safe pairs; R039 proves it for safe pairs that share a supporting
coordinate halfspace. R040 constructs a safe two-hop bridge for
endpoints on distinct active coordinate axes, giving a **nonsharp**
2*C3 bound. R041 proves the exact **conditional**
lifting from a one-source global C3 estimate to a
finite-source bound with coefficient N*M*C3/d^3.
The required sharp one-source C3 inequality for short
cross-face pairs remains open.

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

**Main conjecture — global nonconvex two-point bound
(not yet proved in Lean):**

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

**Exact value of C3 (proved in R016–R017):** In Lean,
`candidateMaximum = candidateCoefficient candidateCriticalPoint`.
The parameter `t_star = candidateCriticalPoint` is the
unique real root in `[9/50, 1/5]` of

```text
2*t_star^3 - 8*t_star^2 - 4*t_star + 1 = 0.
```

The exact coefficient is

$
C_3 = \frac{2+6t_*-2t_*^2}{(1+2t_*^2)^{5/2}}.
$

The approximation `2.5775644212` is **not yet a
Lean-certified decimal enclosure**.

**Two-point lower bound (proved for one source, R036–R037):**
No constant smaller than C3 can bound every pair of
unit-cube-admissible displacements for the unit Newtonian
source. R036 proves the limiting quotient along actual
admissible pairs; R037 forces any universal two-point
coefficient to be at least C3. This does **not** prove
that C3 is itself a global upper bound. Sharpness of a
global bound is conditional on proving that upper bound.

## Mathematical question

Newton's law uses the **Euclidean norm** norm_2, whereas
the proposed sensitivity inequality uses norm_inf to measure
variations along the three Cartesian axes X, Y, and Z.

The previously proved coefficients 10 and 7 require
Euclidean clearance. The sharp candidate C3 instead uses
clearance in the Cartesian maximum norm. These are
different geometric assumptions.

Lean verifies the exact scalar maximum (R016–R017),
a pointwise Cartesian Jacobian bound (R024–R025),
and the induced Frechet derivative norm bound (R026–R027).
The critical diagonal witness attains both the Jacobian
row sum (R028) and the derivative operator norm (R029).
The candidate also controls finite differences on convex
Cartesian-safe domains (R030), including certified
Cartesian boxes (R031).
The **nonconvex complement** of the forbidden cubes
requires a separate argument for arbitrary pairs of points,
including those whose connecting segment crosses a
forbidden region.

## Why the result may matter — intended audience

The intended readers work with Cartesian boxes, adaptive
computations or **certified numerical enclosures** for
inverse-square point-source forces. These are potential
applications, not validated performance or safety claims.

- **Computational astrophysicists and N-body developers:**
  Cartesian tree codes (Barnes–Hut, octrees) and the Fast
  Multipole Method (FMM) could use a tight force-sensitivity
  bound within rigorously justified error budgets. The
  formula alone does not certify fewer subdivisions or
  bound a particular tree or multipole approximation error.
- **Computational chemists and biophysicists:**
  Coulomb point-charge forces share the inverse-square
  vector kernel with Newtonian gravity, up to the source
  coefficients and signs. A mathematically appropriate
  bound may aid electrostatic simulations in 3D boxes.
  Charges, screening, periodic boundaries and softened
  potentials require separate treatment.
- **Interval arithmetic and validated dynamics specialists:**
  CAPD, VNODE-LP and COSY Infinity users could incorporate
  an exact coefficient in interval or Taylor-model
  enclosures with certified separation from singularities.
  Benefits for wrapping, validated orbital trajectories
  or planetary defense require application-level proofs.
- **Numerical analysts and adaptive mesh refinement (AMR)
  developers:** A Cartesian supremum-norm derivative
  bound could support local error control and conservative
  mesh or time-step decisions on suitable safe domains.
  Actual accuracy and runtime gains remain unmeasured.
- **GPU and high-performance-computing developers:**
  The dimensionless constant can be stored once, without
  solving the cubic at runtime. A bound expressed with
  `norm_inf` may suit Cartesian block calculations, but
  the physical force still uses Euclidean radii; no
  elimination of squared-distance overflow or performance
  speedup is established.
- **Planetary defense, aerospace and space situational awareness:**
  Certified sensitivity estimates may contribute to
  conjunction analyses and uncertainty propagation.
  The coefficient does not itself certify a collision probability
  or operational safety.

**Geometry and practical adoption:** More elaborate
polyhedral exclusion regions may offer more tailored
bounds, potentially closer to spherical-clearance models.
For existing Cartesian-box codes, replacing a conservative
parameter with the precomputed C3 may tighten certified
error budgets without changing spatial data structures,
provided the proved domain and clearance conditions apply.
This does not guarantee improved numerical accuracy,
unchanged code stability or any runtime gain; these
require application-level analysis and benchmarking.

**Present limitation:** R027–R029 prove the sharp
pointwise derivative norm and its attainment;
R030–R031 handle convex safe domains and boxes;
R038–R039 handle far or common-face safe pairs;
R040 gives a nonsharp 2*C3 bound for different-axis
pairs. The sharp global C3 estimate across the
nonconvex exterior remains **unproved**.
Reusing a precomputed scalar has negligible arithmetic
overhead, but adopting the bound in real software requires
checking the model, clearance and domain hypotheses.
No measured algorithmic improvement is claimed.

## Status

This section describes the current proof boundary.
Only results that passed the full Lean build are listed
as verified in the permanent mathematical ledger below.

**Verified in Lean:**

- R016–R017 determine the exact critical root and scalar
  candidate C3, including its maximality.
- R024–R027 establish the Cartesian Jacobian row-sum
  and actual Frechet derivative operator-norm bounds.
- R028–R029 exhibit an explicit physical configuration
  where the derivative operator norm **equals C3**.
- R032 proves that **no smaller universal coefficient**
  works for the Newtonian derivative operator norm.
- R033–R035 establish an attaining direction, an
  outward admissible ray, and distinct safe pairs
  with exactly known Cartesian separation.
- R030–R031 prove **finite-difference bounds** with C3
  on convex safe domains and certified Cartesian boxes.
- R036 proves that the **actual admissible secant quotients**
  converge to C3 along an outward unit direction.
- R037 proves that any universal two-point coefficient
  valid outside the unit safety cube must be at least C3.
- R038 proves the **global two-point C3 upper estimate**
  for one source whenever two safe endpoints have Cartesian
  separation at least the positive clearance d, with no
  requirement that their connecting segment be safe.
- R039 proves that the same estimate holds for two endpoints
  in a **common safe supporting halfspace**, regardless of
  separation. Together R038–R039 cover far or common-face
  pairs, but not all safe pairs.
- R040 constructs a **coordinate bridge** between endpoints
  supported by different safe axes. It gives two convex-safe
  hops of length at most the original separation and thus a
  **nonsharp 2*C3 bound**, even if the direct segment is unsafe.
- R041 proves that the still-open **one-source global C3**
  statement, *if established*, implies the sharp finite-source
  differential-force bound with coefficient N*M*C3/d³.
  The premise is stated explicitly and remains unproved.
- R001–R015 and R018–R023 document the foundational
  field, regularity, conservative estimates, and the
  verified algebraic reductions.

**Proposed but not yet verified in Lean:**

R041 is verified as a **conditional implication**,
not as proof of its one-source premise. The missing
sharp C3 upper bound for short cross-face pairs is
still an open research problem (issue #4). No
unproved theorem is included in this results ledger.

**Still unproved:**

- A universal C3 bound for arbitrary endpoints outside
  forbidden cubes, even if the joining segment is unsafe;
  the **nonconvex complement** requires separate analysis.
- The final N-source global optimality theorem planned
  as the second Palomar target, and independent Comparator
  validation of the two selected theorem statements.

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
coefficient lower bound; the global nonconvex C3
upper bound is still open.

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
the operator-norm equality (R029), nor the still-open
global two-point C3 upper estimate.

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
R037 later proves the necessary two-point lower bound;
the global nonconvex C3 upper estimate remains unproved.

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
geometry required by the global conjecture.
**Limit:** This ray alone does not establish the
secant quotient limit (proved later in R036) or
the still-open sharp global C3 upper bound.

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
for arbitrarily close pairs and reduces the unresolved
global problem to short pairs with no shared safe
supporting halfspace.
**Limit:** The residual cross-face case, arbitrary
source-position lifting, finite-source upper estimate
and independent Comparator remain unproved.

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
as the still-open assertion that **every** admissible
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
**Limit:** The required `oneSourceGlobalCandidateBound`
premise remains **unproved**, specifically for short
cross-face pairs. R041 is not an unconditional global
upper bound, a finished optimality theorem or
independent Comparator verification.

**Lean:**
`oneSourceGlobalCandidateBound`,
`NewtonianPointSource.finiteDifferentialAcceleration_norm_le_of_oneSourceGlobal`,
`sourceGravitationalParameter_sum_le_length_mul`,
`NewtonianPointSource.finiteDifferentialAcceleration_norm_le_length_mul_of_oneSourceGlobal`.
**Source:** [ConditionalFiniteSource.lean][conditional-finite-source].

## Direct proof strategy

The derivative bound (R027) is attained (R029)
and minimal for derivative estimates (R032).
R033–R037 close the **admissible two-point lower bound**.
R038 covers long separations, R039 covers common safe
supporting halfspaces, and R040 gives the two-hop
**2*C3** estimate for distinct active axes. R041
already establishes the **conditional** N-source lift.

1. Prove or refute the missing sharp C3 bound for
   short cross-face one-source pairs; investigate
   force-difference cancellation instead of merely
   summing two C3 bounds.
2. Combine that future one-source theorem with the
   **already verified conditional reduction R041**
   and identify physical parameters `mu_k = G*m_k`,
   including source-position translations.
3. Assemble two auditable Palomar statements and
   configure Comparator only after both targets
   are actually proved, without implying that
   the conditional result supplies its premise.

## Roadmap

- **M01 — Foundation: complete.** Exact field, derivative,
  norm bridges, clearance, and bounds 10 and 7 (R001–R010).
- **M02 — Jacobian reduction: complete for pointwise
  row sums.** The exact Jacobian (R013), normalized row
  algebra (R014–R015, R018–R019), symmetries (R020–R021),
  dominant-axis estimates (R022–R023) and arbitrary
  signed coordinates (R024) have been verified. R025
  expresses the result in the Cartesian norm.
- **M03 — Sharp upper bound: complete pointwise and on
  convex safe domains.** R016–R017 fix C3, R024–R027
  bound the Cartesian derivative operator norm, and
  R028–R029 prove its attainment. R030 proves the
  actual finite-difference bound on convex safe domains.
  The unrestricted nonconvex bound remains unproved.
- **M04 — Two-point lower bound: complete for the unit
  source.** R029 proves derivative-norm attainment,
  R032 pointwise minimality, R033–R035 supply admissible
  secants, and R036–R037 establish the actual secant
  limit and necessary lower bound C3. The full
  nonconvex **upper** bound is still open.
- **M05 — Domain theorem: in progress.** In addition to
  convex and box bounds (R030–R031), R038 proves the
  nonconvex bound for safe pairs separated by at least
  d and R039 handles any common safe supporting face.
  R040 gives a constructive two-hop nonsharp 2*C3
  bound for distinct-axis active faces. R041 proves
  the **conditional** finite-source lifting with the
  sharp N*M*C3/d³ factor. The short cross-face
  one-source C3 bound and thus the unconditional
  multi-source theorem remain open.
- **M06 — Scientific and archival validation: open.** The
  planned Palomar pair is the exact formula for C3 and its
  global optimality (see [PALOMAR.md](PALOMAR.md)).
  The second theorem, independent Comparator, references
  and final review before any Palomar submission remain
  outstanding. Further research uses one active PR,
  with verified proof statements and documentation
  reviewed before merge.

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
  [ConditionalFiniteSource][conditional-finite-source].

[derivative-minimality]: NewtonianLipschitz/DerivativeCoefficientMinimality.lean
[derivative-direction]: NewtonianLipschitz/DerivativeAttainingDirection.lean
[admissible-critical]: NewtonianLipschitz/AdmissibleCriticalDirection.lean
[admissible-secant]: NewtonianLipschitz/AdmissibleSecantPairs.lean
[long-separation]: NewtonianLipschitz/LongSeparation.lean
[common-safe-face]: NewtonianLipschitz/CommonSafeFace.lean
[cross-face-two-hop]: NewtonianLipschitz/CrossFaceTwoHop.lean
[conditional-finite-source]: NewtonianLipschitz/ConditionalFiniteSource.lean
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

The global nonconvex upper bound and full optimality are
**not yet Lean-verified theorems**, even though the scalar
C3 maximum and universal two-point coefficient lower bound
have been proved. Preserve exact assumptions, norms, source
links, and uncertainty.

Keep cumulative **mathematical** results here; keep the build and
task chronology in the pull request, not in the results catalog.
Require a green full build and documentation review before merge.
No novelty, priority, or publication-readiness claim is made.

## License

Apache License, Version 2.0 (Apache-2.0).
See [LICENSE](LICENSE).
