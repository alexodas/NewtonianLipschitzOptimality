module

public import Mathlib

public section

/-!
# Elementary algebra for the 3D Cartesian operator-norm optimization

For a normalized nonnegative displacement (1,u,v) with 0 ≤ u,v ≤ 1,
the numerator of the absolute row sum of the first Jacobian row is
2 - u² - v² + 3(u+v). The two lateral rows have analogous expressions.

This module proves **only algebraic comparisons**. The bridge from the
actual Fréchet derivative to these row numerators and the optimal
one-variable maximization are separate formal proof obligations.
-/

namespace NewtonianLipschitz

/-- Numerator of the first absolute Jacobian row sum
at the normalized point (1,u,v) in the nonnegative octant. -/
def dominantRowNumerator (u v : ℝ) : ℝ :=
  2 - u ^ 2 - v ^ 2 + 3 * (u + v)

/-- Numerator of the second absolute Jacobian row sum
at the same normalized point. -/
def lateralRowNumerator (u v : ℝ) : ℝ :=
  |2 * u ^ 2 - 1 - v ^ 2| + 3 * u * (1 + v)

/-- The row indexed by a maximal absolute Cartesian coordinate dominates
a lateral row, in the normalized positive octant. -/
theorem lateralRowNumerator_le_dominant
    (u v : ℝ) (hu0 : 0 ≤ u) (hu1 : u ≤ 1)
    (hv0 : 0 ≤ v) (hv1 : v ≤ 1) :
    lateralRowNumerator u v ≤ dominantRowNumerator u v := by
  have hleft : 0 ≤ (1 - v) * (1 + u ^ 2) :=
    mul_nonneg (by linarith) (by positivity)
  have hmiddle : 0 ≤ v * ((1 - u) * (2 - u)) :=
    mul_nonneg hv0 (mul_nonneg (by linarith) (by linarith))
  have hright : 0 ≤ v * (1 - v) :=
    mul_nonneg hv0 (by linarith)
  have hother : 0 ≤ (1 - u) * (1 + u + v) :=
    mul_nonneg (by linarith) (by linarith)
  have habs :
      |2 * u ^ 2 - 1 - v ^ 2| ≤
        2 - u ^ 2 - v ^ 2 + 3 * (u + v) - 3 * u * (1 + v) := by
    apply abs_le.mpr
    constructor
    · nlinarith [hleft, hmiddle, hright]
    · nlinarith [hother]
  unfold dominantRowNumerator lateralRowNumerator
  linarith

/-- The third row enjoys the same bound, with u and v exchanged. -/
theorem lateralRowNumerator_swapped_le_dominant
    (u v : ℝ) (hu0 : 0 ≤ u) (hu1 : u ≤ 1)
    (hv0 : 0 ≤ v) (hv1 : v ≤ 1) :
    lateralRowNumerator v u ≤ dominantRowNumerator u v := by
  simpa only [dominantRowNumerator, add_comm, add_left_comm, add_assoc]
    using lateralRowNumerator_le_dominant v u hv0 hv1 hu0 hu1

/-- Completing two squares produces a simple rational quadratic cap.
This is a numerator inequality, not yet a Lipschitz estimate. -/
theorem dominantRowNumerator_le_quadratic (u v : ℝ) :
    dominantRowNumerator u v ≤
      (13 : ℝ) / 5 + ((13 : ℝ) / 2) * (u ^ 2 + v ^ 2) := by
  unfold dominantRowNumerator
  nlinarith [sq_nonneg (u - 1 / 5), sq_nonneg (v - 1 / 5)]

/-- Diagonal restriction giving the exact candidate numerator. -/
theorem dominantRowNumerator_diagonal (t : ℝ) :
    dominantRowNumerator t t = 2 + 6 * t - 2 * t ^ 2 := by
  unfold dominantRowNumerator
  ring

end NewtonianLipschitz
