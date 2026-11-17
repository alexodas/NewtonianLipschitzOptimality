module

public import NewtonianLipschitz.AdmissibleSecantPairs

public section

/-!
# Long-separation bound outside nonconvex cubical exclusions

The upper bound for two admissible endpoints at Cartesian
distance at least their common clearance d does not require
the connecting segment to be safe. It follows simply from
the magnitudes of the physical Newtonian forces.

This covers a genuine portion of the nonconvex global theorem,
but NOT the short-separation, cross-face case. The module
does not claim the full global Lipschitz inequality.
-/

namespace NewtonianLipschitz

/-- The sharp coefficient is at least the axis-aligned
scalar value 2, independently of decimal approximations. -/
theorem candidateMaximum_ge_two : (2 : ℝ) ≤ candidateMaximum := by
  have hmax :=
    candidateCoefficient_le_at_criticalPoint (0 : ℝ)
      (by constructor <;> norm_num : (0 : ℝ) ∈ Set.Icc 0 1)
  have hzero : candidateCoefficient (0 : ℝ) = 2 := by
    rw [candidateCoefficient_eq]
    norm_num
  rw [hzero] at hmax
  rwa [candidateMaximum_eq]

/-- The magnitude of one Newtonian acceleration at a point
with Cartesian clearance d is at most μ / d². No convexity
or segment hypothesis is involved. -/
theorem NewtonianPointSource.accelerationField_norm_le_of_cartesian_clearance
    (c : NewtonianPointSource) (x : Vec3) (d : ℝ)
    (hd : 0 < d) (hclear : d ≤ ‖x‖) :
    ‖c.accelerationField x‖ ≤ c.gravitationalParameter / d ^ 2 := by
  have hrclear : d ≤ euclideanRadius x :=
    hclear.trans (cartesian_norm_le_euclideanRadius x)
  have hr : 0 < euclideanRadius x := lt_of_lt_of_le hd hrclear
  have hcoeff : 0 ≤ c.gravitationalParameter / euclideanRadius x ^ 3 :=
    div_nonneg c.gravitationalParameter_nonneg
      (pow_nonneg (le_of_lt hr) _)
  have hratio :
      c.gravitationalParameter / euclideanRadius x ^ 2 ≤
        c.gravitationalParameter / d ^ 2 := by
    apply (div_le_div_iff₀ (pow_pos hr 2) (pow_pos hd 2)).2
    exact mul_le_mul_of_nonneg_left
      (pow_le_pow_left₀ hd.le hrclear 2)
      c.gravitationalParameter_nonneg
  calc
    ‖c.accelerationField x‖ =
        (c.gravitationalParameter / euclideanRadius x ^ 3) * ‖x‖ := by
      rw [c.accelerationField_eq_formula, norm_smul,
        Real.norm_eq_abs, abs_div, abs_neg,
        abs_of_nonneg c.gravitationalParameter_nonneg,
        abs_of_nonneg (pow_nonneg (le_of_lt hr) 3)]
    _ ≤ (c.gravitationalParameter / euclideanRadius x ^ 3) *
          euclideanRadius x :=
      mul_le_mul_of_nonneg_left
        (cartesian_norm_le_euclideanRadius x) hcoeff
    _ = c.gravitationalParameter / euclideanRadius x ^ 2 := by
      field_simp [ne_of_gt hr]
    _ ≤ c.gravitationalParameter / d ^ 2 := hratio

/-- R038: if two safe endpoints are at least one clearance
radius apart in the Cartesian norm, their actual Newtonian
force difference obeys the C3 coefficient even when the
segment passes through the forbidden cube.

This theorem deliberately does not address ‖x-y‖ < d. -/
theorem NewtonianPointSource.accelerationField_norm_sub_le_candidateMaximum_long
    (c : NewtonianPointSource)
    (x y : Vec3) (d : ℝ)
    (hd : 0 < d)
    (hx : d ≤ ‖x‖) (hy : d ≤ ‖y‖)
    (hsep : d ≤ ‖x - y‖) :
    ‖c.accelerationField x - c.accelerationField y‖ ≤
      ((1 / d ^ 3) *
        (c.gravitationalParameter * candidateMaximum)) *
          ‖x - y‖ := by
  have hmass : 2 * c.gravitationalParameter ≤
      c.gravitationalParameter * candidateMaximum := by
    calc
      2 * c.gravitationalParameter =
        c.gravitationalParameter * 2 := by ring
      _ ≤ c.gravitationalParameter * candidateMaximum :=
        mul_le_mul_of_nonneg_left candidateMaximum_ge_two
          c.gravitationalParameter_nonneg
  have hscale :
      (1 / d ^ 3) * (2 * c.gravitationalParameter) ≤
        (1 / d ^ 3) *
          (c.gravitationalParameter * candidateMaximum) :=
    mul_le_mul_of_nonneg_left hmass (by positivity)
  have hcoef :
      0 ≤ (1 / d ^ 3) *
        (c.gravitationalParameter * candidateMaximum) :=
    mul_nonneg (by positivity)
      (mul_nonneg c.gravitationalParameter_nonneg
        candidateMaximum_nonneg)
  calc
    ‖c.accelerationField x - c.accelerationField y‖ ≤
        ‖c.accelerationField x‖ + ‖c.accelerationField y‖ :=
      norm_sub_le _ _
    _ ≤ c.gravitationalParameter / d ^ 2 +
        c.gravitationalParameter / d ^ 2 :=
      add_le_add
        (c.accelerationField_norm_le_of_cartesian_clearance x d hd hx)
        (c.accelerationField_norm_le_of_cartesian_clearance y d hd hy)
    _ = 2 * (c.gravitationalParameter / d ^ 2) := by ring
    _ = ((1 / d ^ 3) * (2 * c.gravitationalParameter)) * d := by
      field_simp [ne_of_gt hd]
    _ ≤ ((1 / d ^ 3) *
          (c.gravitationalParameter * candidateMaximum)) * d :=
      mul_le_mul_of_nonneg_right hscale hd.le
    _ ≤ ((1 / d ^ 3) *
          (c.gravitationalParameter * candidateMaximum)) * ‖x - y‖ :=
      mul_le_mul_of_nonneg_left hsep hcoef

end NewtonianLipschitz
