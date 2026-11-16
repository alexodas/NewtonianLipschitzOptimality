module

public import NewtonianLipschitz.Basic

public section

/-!
# Euclidean and supremum-norm bridges

Quantitative norm comparisons are proved in the actual Pi norm, while
the force law uses the Euclidean radius. The factor 3 below is an
established nonsharp baseline, not an optimality claim.
-/

open scoped NNReal Topology InnerProductSpace

namespace NewtonianLipschitz

theorem cartesian_norm_le_euclideanRadius (x : Vec3) :
    ‖x‖ ≤ euclideanRadius x := by
  rw [euclideanRadius_eq_physical_norm]
  apply (pi_norm_le_iff_of_nonneg (norm_nonneg (toPhysicalVec3 x))).2
  intro i
  simpa only [toPhysicalVec3_apply] using
    (PiLp.norm_apply_le (toPhysicalVec3 x) i)

/-- A positive lower distance certificate stated in
the Cartesian/Pi norm, implies the *Euclidean* lower radius that is
actually used in the inverse-cube denominator. -/
theorem euclideanRadius_ge_of_cartesian_distance
    (x : Vec3) (d : ℝ)
    (hclear : d ≤ dist x (0 : Vec3)) :
    d ≤ euclideanRadius x := by
  calc
    d ≤ dist x (0 : Vec3) := hclear
    _ = ‖x‖ := by simp
    _ ≤ euclideanRadius x := cartesian_norm_le_euclideanRadius x

theorem euclideanRadius_le_three_mul_cartesian_norm (x : Vec3) :
    euclideanRadius x ≤ 3 * ‖x‖ := by
  have h0 : (x 0) ^ 2 ≤ ‖x‖ ^ 2 := by
    simpa only [Real.norm_eq_abs, sq_abs] using
      (pow_le_pow_left₀ (norm_nonneg (x 0))
        (norm_le_pi_norm x 0) 2)
  have h1 : (x 1) ^ 2 ≤ ‖x‖ ^ 2 := by
    simpa only [Real.norm_eq_abs, sq_abs] using
      (pow_le_pow_left₀ (norm_nonneg (x 1))
        (norm_le_pi_norm x 1) 2)
  have h2 : (x 2) ^ 2 ≤ ‖x‖ ^ 2 := by
    simpa only [Real.norm_eq_abs, sq_abs] using
      (pow_le_pow_left₀ (norm_nonneg (x 2))
        (norm_le_pi_norm x 2) 2)
  rw [euclideanRadius_eq_coordinates]
  apply (Real.sqrt_le_left (by positivity : 0 ≤ (3 : ℝ) * ‖x‖)).2
  nlinarith [sq_nonneg (‖x‖)]

/-- A corollary for the true physical vector, expressed in the exact
norm that appears in the Newtonian derivative. -/
theorem toPhysicalVec3_norm_le_three_cartesian_norm (x : Vec3) :
    ‖toPhysicalVec3 x‖ ≤ 3 * ‖x‖ := by
  rw [← euclideanRadius_eq_physical_norm]
  exact euclideanRadius_le_three_mul_cartesian_norm x

end NewtonianLipschitz
