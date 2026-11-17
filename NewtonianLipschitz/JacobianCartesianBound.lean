module

public import NewtonianLipschitz.JacobianSignedBounds

public section

/-!
# The actual Cartesian maximum norm in the sharp Jacobian estimate

The previous theorem controls every absolute row sum using the
largest absolute Cartesian coordinate. This module identifies that
quantity with the ambient Pi supremum norm, then records the
pointwise estimate at positive Cartesian clearance.

These are derivative-matrix bounds. The global two-point claim
outside nonconvex safety cubes is a separate open problem.
-/

namespace NewtonianLipschitz

/-- The norm on Vec3 is exactly the largest absolute value
of its three Cartesian coordinates. -/
theorem cartesian_norm_eq_max_abs (x : Vec3) :
    ‖x‖ = max (|x 0|) (max (|x 1|) (|x 2|)) := by
  apply le_antisymm
  · have hbound :
        0 ≤ max (|x 0|) (max (|x 1|) (|x 2|)) :=
      (abs_nonneg (x 0)).trans (le_max_left _ _)
    apply (pi_norm_le_iff_of_nonneg hbound).2
    intro i
    fin_cases i
    · simpa only [Real.norm_eq_abs] using
        (le_max_left (|x 0|) (max (|x 1|) (|x 2|)))
    · simpa only [Real.norm_eq_abs] using
        ((le_max_left (|x 1|) (|x 2|)).trans
          (le_max_right (|x 0|) (max (|x 1|) (|x 2|))))
    · simpa only [Real.norm_eq_abs] using
        ((le_max_right (|x 1|) (|x 2|)).trans
          (le_max_right (|x 0|) (max (|x 1|) (|x 2|))))
  · apply max_le
    · simpa only [Real.norm_eq_abs] using (norm_le_pi_norm x 0)
    · apply max_le
      · simpa only [Real.norm_eq_abs] using (norm_le_pi_norm x 1)
      · simpa only [Real.norm_eq_abs] using (norm_le_pi_norm x 2)

/-- Every row of the true Newtonian Jacobian has the exact
candidate upper bound at an arbitrary nonzero displacement,
expressed in the Cartesian supremum norm. -/
theorem newtonianJacobianMatrix_rowSum_le_candidateMaximum_norm
    (μ : ℝ) (x : Vec3) (i : Fin 3)
    (hμ : 0 ≤ μ) (hx : x ≠ 0) :
    (∑ j : Fin 3, |newtonianJacobianMatrix μ x i j|) ≤
      (1 / ‖x‖ ^ 3) * (μ * candidateMaximum) := by
  have hmax : 0 < max (|x 0|) (max (|x 1|) (|x 2|)) := by
    rw [← cartesian_norm_eq_max_abs]
    exact norm_pos_iff.mpr hx
  simpa only [cartesian_norm_eq_max_abs] using
    (newtonianJacobianMatrix_signed_max_le_candidateMaximum
      μ x i hμ hmax)

/-- The exact scalar candidate maximum is nonnegative.
It is at least the value 2 attained at parameter zero. -/
theorem candidateMaximum_nonneg : 0 ≤ candidateMaximum := by
  have h0 :
      candidateCoefficient (0 : ℝ) ≤ candidateMaximum := by
    rw [candidateMaximum_eq]
    exact candidateCoefficient_le_at_criticalPoint (0 : ℝ)
      ⟨by norm_num, by norm_num⟩
  have hvalue : candidateCoefficient (0 : ℝ) = 2 := by
    rw [candidateCoefficient_eq]
    norm_num
  rw [hvalue] at h0
  linarith

/-- At positive Cartesian clearance d, every absolute row sum
is bounded by the sharp scalar candidate times mu / d^3.
This is a pointwise result, not a nonconvex global bound. -/
theorem newtonianJacobianMatrix_rowSum_le_candidateMaximum_clearance
    (μ d : ℝ) (x : Vec3) (i : Fin 3)
    (hμ : 0 ≤ μ) (hd : 0 < d) (hclear : d ≤ ‖x‖) :
    (∑ j : Fin 3, |newtonianJacobianMatrix μ x i j|) ≤
      (1 / d ^ 3) * (μ * candidateMaximum) := by
  have hnorm : 0 < ‖x‖ := lt_of_lt_of_le hd hclear
  have hx : x ≠ 0 := norm_pos_iff.mp hnorm
  have hpow : d ^ 3 ≤ ‖x‖ ^ 3 :=
    pow_le_pow_left₀ hd.le hclear 3
  have hinv : (1 : ℝ) / ‖x‖ ^ 3 ≤ 1 / d ^ 3 := by
    apply (div_le_div_iff₀ (pow_pos hnorm 3) (pow_pos hd 3)).2
    simpa only [one_mul] using hpow
  calc
    (∑ j : Fin 3, |newtonianJacobianMatrix μ x i j|)
      ≤ (1 / ‖x‖ ^ 3) * (μ * candidateMaximum) :=
        newtonianJacobianMatrix_rowSum_le_candidateMaximum_norm
          μ x i hμ hx
    _ ≤ (1 / d ^ 3) * (μ * candidateMaximum) :=
        mul_le_mul_of_nonneg_right hinv
          (mul_nonneg hμ candidateMaximum_nonneg)

end NewtonianLipschitz
