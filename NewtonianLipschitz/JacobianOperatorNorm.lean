module

public import NewtonianLipschitz.JacobianOperatorAction

public section

/-!
# Candidate operator norm of the physical Newtonian derivative

The verified directional estimate applies to every input
direction, and therefore bounds the operator norm of the
actual Frechet derivative. The second result imposes positive
Cartesian clearance. No two-point statement on the nonconvex
exterior of safety cubes or optimality is asserted.
-/

namespace NewtonianLipschitz

/-- Candidate Cartesian operator-norm upper bound on the
actual Newtonian Frechet derivative at a nonzero displacement. -/
theorem NewtonianPointSource.accelerationField_fderiv_opNorm_le_candidateMaximum
    (c : NewtonianPointSource) (x : Vec3) (hx : x ≠ 0) :
    ‖fderiv ℝ c.accelerationField x‖ ≤
      (1 / ‖x‖ ^ 3) *
        (c.gravitationalParameter * candidateMaximum) := by
  have hfactor :
      0 ≤ (1 / ‖x‖ ^ 3) *
          (c.gravitationalParameter * candidateMaximum) :=
    mul_nonneg (by positivity)
      (mul_nonneg c.gravitationalParameter_nonneg
        candidateMaximum_nonneg)
  apply ContinuousLinearMap.opNorm_le_bound _ hfactor
  intro h
  exact c.accelerationField_fderiv_norm_le_candidateMaximum x h hx

/-- Under positive Cartesian clearance, the Frechet
derivative's operator norm obeys the candidate cube bound. -/
theorem NewtonianPointSource.accelerationField_fderiv_opNorm_le_clearance
    (c : NewtonianPointSource) (x : Vec3) (d : ℝ)
    (hd : 0 < d) (hclear : d ≤ ‖x‖) :
    ‖fderiv ℝ c.accelerationField x‖ ≤
      (1 / d ^ 3) *
        (c.gravitationalParameter * candidateMaximum) := by
  have hnorm : 0 < ‖x‖ := lt_of_lt_of_le hd hclear
  have hx : x ≠ 0 := norm_pos_iff.mp hnorm
  have hpow : d ^ 3 ≤ ‖x‖ ^ 3 :=
    pow_le_pow_left₀ hd.le hclear 3
  have hinv : (1 : ℝ) / ‖x‖ ^ 3 ≤ 1 / d ^ 3 := by
    apply (div_le_div_iff₀ (pow_pos hnorm 3) (pow_pos hd 3)).2
    simpa only [one_mul] using hpow
  calc
    ‖fderiv ℝ c.accelerationField x‖
      ≤ (1 / ‖x‖ ^ 3) *
          (c.gravitationalParameter * candidateMaximum) :=
        c.accelerationField_fderiv_opNorm_le_candidateMaximum x hx
    _ ≤ (1 / d ^ 3) *
          (c.gravitationalParameter * candidateMaximum) :=
        mul_le_mul_of_nonneg_right hinv
          (mul_nonneg c.gravitationalParameter_nonneg
            candidateMaximum_nonneg)

end NewtonianLipschitz
