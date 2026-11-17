# Palomar — mathematical statements and comparison preparation

This repository contains a substantive Lean 4 proof development for two
connected theorems on the **sharp Cartesian Lipschitz coefficient of
three-dimensional Newtonian point-source gravity**. This document
describes the mathematical submission, not the history of its
development. It is **not yet a Palomar registration**.

## Theorem 1 — Exact algebraic coefficient

There is a unique parameter \(t_*\in[9/50,1/5]\) satisfying

\[
2t_*^3-8t_*^2-4t_*+1=0.
\]

The function
\[
f(t)=\frac{2+6t-2t^2}{(1+2t^2)^{5/2}}
\]
has its maximum on \(0\leq t\leq1\) at \(t_*\), giving

\[
C_3=f(t_*)\approx2.5775644212.
\]

The root bracket, uniqueness, and global scalar maximality are all
exact Lean statements, with no numerical solver or reliance on
the decimal approximation.

## Theorem 2 — Sharp global Newtonian bound outside safety cubes

For \(n\) point masses \(m_i\) at arbitrary centers \(a_i\in\mathbb R^3\),
choose \(G\geq0\), \(M\geq0\), \(d>0\), and
\(0\leq m_i\leq M\). The physical Newtonian acceleration is

\[
g(P)=-G\sum_{i=1}^{n}
       \frac{m_i(P-a_i)}{\|P-a_i\|_2^3}.
\]

Let \(P,Q\in\mathbb R^3\) have *Cartesian clearance*
\[
\|P-a_i\|_\infty\geq d,\qquad
\|Q-a_i\|_\infty\geq d
\]
from every source. Cube boundaries are admissible; the connecting
segment \([P,Q]\) is not required to avoid the excluded cubes.
Then

\[
\boxed{\displaystyle
\|g(P)-g(Q)\|_\infty\leq
\frac{nGM C_3}{d^3}\,\|P-Q\|_\infty.}
\]

The theorem also characterizes the **least universal coefficient**:
for a single unit source centered at the origin with \(G=M=d=1\),
a real \(K\) bounds all admissible force differences if and only if
\(K\geq C_3\). Because the physical family includes this single-source
case, no smaller dimensionless coefficient works universally across
all finite-source instances.

**Scope:** This does not say the bound is attained for each fixed
\(n\), mass layout or degenerate zero-mass configuration. The theorem
does not assume the direct connecting segment is safe. Its field
uses Euclidean radii and its clearance and variation bounds use
the Cartesian maximum norm.

## Mathematical proof

The exact scalar extremum yields \(C_3\). The full Newtonian
Fréchet derivative has Cartesian operator norm at most
\(C_3\mu/d^3\), and a boundary derivative witness yields
the matching necessary lower bound via genuine safe secants.

Nonconvexity requires an additional idea: the derivative restricted
to directions tangent to any signed-safe Cartesian coordinate plane
has the stronger bound \(5\mu/(4d^3)\). On such a plane the
straight segment remains safe, so the one-dimensional mean-value
inequality proves the corresponding finite-difference estimate.
For endpoints with different safe supporting axes, a two-leg safe
bridge gives coefficient \(5/2<C_3\); same-face and sufficiently
separated pairs are handled directly. This gives the unrestricted
one-source upper bound. Summing exact individual source differences
and applying the mass cap yields the many-source estimate.

The substantive Lean proof is in \`NewtonianLipschitz/\`; its exact
scalar and global steps are available in \`ScalarMaximum.lean\`,
\`AdmissibleSecantPairs.lean\`, \`PhysicalTangentialAllAxes.lean\`,
\`SafePlaneFiniteDifference.lean\`, and
\`UnconditionalFiniteSource.lean\`.

## Comparator statements and verification boundary

\`Challenge.lean\` contains exactly the two audited theorem
statements \`PalomarNewtonian.scalarMaximum\` and
\`PalomarNewtonian.globalCubicSensitivityAndOptimality\`.
It imports only Mathlib and spells out the physical field directly,
without relying on project-specific definitions.

\`Solution.lean\` contains the corresponding completed proofs and
may import the substantive project. \`comparator.json\` selects
exactly those two names and permits only
\`propext\`, \`Quot.sound\` and \`Classical.choice\`.
The intentional statement placeholders of the Challenge do not
count as unsolved substantive proofs. The Solution must be
free of \`sorry\`, \`admit\` and custom axioms.

The ordinary Lean build and the independent Comparator
verification are separate. **Do not infer a Comparator pass from
a successful Lean build**; the independent-kernel result must
be reported only after the selected configuration actually runs.
Neither verification constitutes external mathematical peer review.

## Provenance and limitations

The result was developed in this repository under the
mathematical direction of Alessandro Odasso with substantive
GPT-6 assistance in argument discovery, Lean formalization
and exposition. The \`formalization.yaml\` v0.4 metadata discloses
the process, human responsibility, classification, result origin,
and precise qualifications.

No exhaustive literature review establishes research priority,
and the stated applications to rigorous N-body or interval
computation are not performance claims. The decimal expansion of
\(C_3\) has not been Lean-certified as an interval.

A Palomar submission requires a **public** GitHub repository
and an immutable **full 40-character commit SHA**, together
with the selected repository-relative \`comparator.json\`.
Preparing these files does not make this private repository
public or submit it on the maintainer's behalf.

