module

public import NewtonianLipschitz.Derivative

public section

/-!
# Proven conservative quantitative derivative bounds

This module preserves the already established inverse-power estimates,
Cauchy--Schwarz bound, and an explicit (nonoptimal) coefficient of 10
for the Newtonian point-source derivative in the Cartesian Pi norm.
It is a baseline and does not assert optimality.
-/

open scoped NNReal Topology InnerProductSpace

namespace NewtonianLipschitz

theorem NewtonianPointSource.inverse_power_parameter_le_of_clearance
    (c : NewtonianPointSource) (x : Vec3) (d M : ℝ) (n : ℕ)
    (hd : 0 < d)
    (hclear : d ≤ euclideanRadius x)
    (hM : c.gravitationalParameter ≤ M) :
    c.gravitationalParameter / euclideanRadius x ^ n ≤
      M / d ^ n := by
  have hr : 0 < euclideanRadius x := lt_of_lt_of_le hd hclear
  have hdpow : 0 < d ^ n := pow_pos hd n
  have hrpow : 0 < euclideanRadius x ^ n := pow_pos hr n
  have hpow : d ^ n ≤ euclideanRadius x ^ n :=
    pow_le_pow_left₀ (le_of_lt hd) hclear n
  have hMnonneg : 0 ≤ M :=
    le_trans c.gravitationalParameter_nonneg hM
  apply (div_le_div_iff₀ hrpow hdpow).2
  exact (mul_le_mul_of_nonneg_right hM (le_of_lt hdpow)).trans
    (mul_le_mul_of_nonneg_left hpow hMnonneg)

/-- The inverse-cube coefficient `μ/r³` of the exact Newtonian
acceleration is bounded by `M/d³` when `r ≥ d > 0`. -/
theorem NewtonianPointSource.inverse_cube_parameter_le_of_clearance
    (c : NewtonianPointSource) (x : Vec3) (d M : ℝ)
    (hd : 0 < d)
    (hclear : d ≤ euclideanRadius x)
    (hM : c.gravitationalParameter ≤ M) :
    c.gravitationalParameter / euclideanRadius x ^ 3 ≤
      M / d ^ 3 := by
  exact c.inverse_power_parameter_le_of_clearance x d M 3 hd hclear hM

/-- The actual directional derivative of the exact field contains
a second inverse-fifth coefficient `3μ/r⁵`; the same positive
clearance bounds it by `3M/d⁵`. -/
theorem NewtonianPointSource.inverse_fifth_derivative_coefficient_le
    (c : NewtonianPointSource) (x : Vec3) (d M : ℝ)
    (hd : 0 < d)
    (hclear : d ≤ euclideanRadius x)
    (hM : c.gravitationalParameter ≤ M) :
    3 * c.gravitationalParameter / euclideanRadius x ^ 5 ≤
      3 * M / d ^ 5 := by
  have h :=
    c.inverse_power_parameter_le_of_clearance x d M 5 hd hclear hM
  calc
    3 * c.gravitationalParameter / euclideanRadius x ^ 5 =
        3 * (c.gravitationalParameter / euclideanRadius x ^ 5) := by ring
    _ ≤ 3 * (M / d ^ 5) :=
      mul_le_mul_of_nonneg_left h (by norm_num)
    _ = 3 * M / d ^ 5 := by ring

/-- The true Newtonian field derivative, not an assumed auxiliary
field, has the following explicit *directionwise* norm bound.

The remaining steps for the full R058 Lipschitz coefficient are to
control the inner product by Cauchy–Schwarz, convert the Pi norm,
and apply the mean-value theorem on a convex collision-free domain.
This inequality by itself is not a uniform Lipschitz estimate. -/
theorem NewtonianPointSource.accelerationField_fderiv_norm_le_of_clearance
    (c : NewtonianPointSource) (x h : Vec3) (d M : ℝ)
    (hx : x ≠ 0) (hd : 0 < d)
    (hclear : d ≤ euclideanRadius x)
    (hM : c.gravitationalParameter ≤ M) :
    ‖(fderiv ℝ c.accelerationField x) h‖ ≤
      (M / d ^ 3) * ‖h‖ +
        (3 * M / d ^ 5) *
          abs (⟪toPhysicalVec3 x, toPhysicalVec3 h⟫_ℝ) * ‖x‖ := by
  have hr : 0 < euclideanRadius x := lt_of_lt_of_le hd hclear
  have hmu5 : 0 ≤ 3 * c.gravitationalParameter /
      euclideanRadius x ^ 5 :=
    div_nonneg
      (mul_nonneg (by norm_num) c.gravitationalParameter_nonneg)
      (pow_nonneg (le_of_lt hr) _)
  have habs3 :
      |-(c.gravitationalParameter) / euclideanRadius x ^ 3| =
        c.gravitationalParameter / euclideanRadius x ^ 3 := by
    rw [abs_div, abs_neg,
      abs_of_nonneg c.gravitationalParameter_nonneg,
      abs_of_nonneg (pow_nonneg (le_of_lt hr) 3)]
  have hcoeff3 :=
    c.inverse_cube_parameter_le_of_clearance x d M hd hclear hM
  have hcoeff5 :=
    c.inverse_fifth_derivative_coefficient_le x d M hd hclear hM
  rw [c.accelerationField_fderiv_full x h hx]
  calc
    ‖(-(c.gravitationalParameter) / euclideanRadius x ^ 3) • h +
        ((3 * c.gravitationalParameter / euclideanRadius x ^ 5) *
          ⟪toPhysicalVec3 x, toPhysicalVec3 h⟫_ℝ) • x‖ ≤
      ‖(-(c.gravitationalParameter) / euclideanRadius x ^ 3) • h‖ +
        ‖((3 * c.gravitationalParameter / euclideanRadius x ^ 5) *
          ⟪toPhysicalVec3 x, toPhysicalVec3 h⟫_ℝ) • x‖ := norm_add_le _ _
    _ = (c.gravitationalParameter / euclideanRadius x ^ 3) * ‖h‖ +
        (3 * c.gravitationalParameter / euclideanRadius x ^ 5) *
          abs (⟪toPhysicalVec3 x, toPhysicalVec3 h⟫_ℝ) * ‖x‖ := by
      simp only [norm_smul, Real.norm_eq_abs,
        habs3, abs_mul, abs_of_nonneg hmu5]
    _ ≤ (M / d ^ 3) * ‖h‖ +
          (3 * M / d ^ 5) *
            abs (⟪toPhysicalVec3 x, toPhysicalVec3 h⟫_ℝ) * ‖x‖ := by
      have h3 :=
        mul_le_mul_of_nonneg_right hcoeff3 (norm_nonneg h)
      have hinner :
          0 ≤ abs (⟪toPhysicalVec3 x, toPhysicalVec3 h⟫_ℝ) :=
        abs_nonneg _
      have h5 :
          (3 * c.gravitationalParameter / euclideanRadius x ^ 5) *
              abs (⟪toPhysicalVec3 x, toPhysicalVec3 h⟫_ℝ) * ‖x‖ ≤
            (3 * M / d ^ 5) *
              abs (⟪toPhysicalVec3 x, toPhysicalVec3 h⟫_ℝ) * ‖x‖ := by
        apply mul_le_mul_of_nonneg_right _ (norm_nonneg x)
        exact mul_le_mul_of_nonneg_right hcoeff5 hinner
      exact add_le_add h3 h5

theorem NewtonianPointSource.accelerationField_fderiv_norm_le_cauchy_clearance
    (c : NewtonianPointSource) (x h : Vec3) (d M : ℝ)
    (hx : x ≠ 0) (hd : 0 < d)
    (hclear : d ≤ euclideanRadius x)
    (hM : c.gravitationalParameter ≤ M) :
    ‖(fderiv ℝ c.accelerationField x) h‖ ≤
      (M / d ^ 3) * ‖h‖ +
        (3 * M / d ^ 5) *
          (‖toPhysicalVec3 x‖ * ‖toPhysicalVec3 h‖) * ‖x‖ := by
  have hMnonneg : 0 ≤ M :=
    le_trans c.gravitationalParameter_nonneg hM
  have hcoef : 0 ≤ 3 * M / d ^ 5 := by
    positivity
  have hCS :
      abs (⟪toPhysicalVec3 x, toPhysicalVec3 h⟫_ℝ) ≤
        ‖toPhysicalVec3 x‖ * ‖toPhysicalVec3 h‖ :=
    abs_real_inner_le_norm _ _
  have hterm :
      (3 * M / d ^ 5) *
          abs (⟪toPhysicalVec3 x, toPhysicalVec3 h⟫_ℝ) * ‖x‖ ≤
        (3 * M / d ^ 5) *
          (‖toPhysicalVec3 x‖ * ‖toPhysicalVec3 h‖) * ‖x‖ :=
    mul_le_mul_of_nonneg_right
      (mul_le_mul_of_nonneg_left hCS hcoef) (norm_nonneg x)
  exact
    (c.accelerationField_fderiv_norm_le_of_clearance x h d M
      hx hd hclear hM).trans (add_le_add (le_refl _) hterm)

theorem NewtonianPointSource.accelerationField_fderiv_norm_le_ten_of_clearance
    (c : NewtonianPointSource) (x h : Vec3) (d M : ℝ)
    (hx : x ≠ 0) (hd : 0 < d)
    (hclear : d ≤ euclideanRadius x)
    (hM : c.gravitationalParameter ≤ M) :
    ‖(fderiv ℝ c.accelerationField x) h‖ ≤
      (10 * M / d ^ 3) * ‖h‖ := by
  let r : ℝ := euclideanRadius x
  have hr : 0 < r := lt_of_lt_of_le hd hclear
  have hcoef : 0 ≤ 3 * c.gravitationalParameter / r ^ 5 := by
    exact div_nonneg
      (mul_nonneg (by norm_num) c.gravitationalParameter_nonneg)
      (pow_nonneg (le_of_lt hr) _)
  have hnormx : ‖x‖ ≤ r := cartesian_norm_le_euclideanRadius x
  have hnormh : ‖toPhysicalVec3 h‖ ≤ 3 * ‖h‖ :=
    toPhysicalVec3_norm_le_three_cartesian_norm h
  have hcauchy :
      ‖(fderiv ℝ c.accelerationField x) h‖ ≤
        (c.gravitationalParameter / r ^ 3) * ‖h‖ +
          (3 * c.gravitationalParameter / r ^ 5) *
            (‖toPhysicalVec3 x‖ * ‖toPhysicalVec3 h‖) * ‖x‖ := by
    simpa only [r] using
      c.accelerationField_fderiv_norm_le_cauchy_clearance
        x h r c.gravitationalParameter hx hr le_rfl le_rfl
  have hstep1 :
      (3 * c.gravitationalParameter / r ^ 5) *
          (r * ‖toPhysicalVec3 h‖) * ‖x‖ ≤
        (3 * c.gravitationalParameter / r ^ 5) *
          (r * (3 * ‖h‖)) * ‖x‖ := by
    apply mul_le_mul_of_nonneg_right _ (norm_nonneg x)
    apply mul_le_mul_of_nonneg_left _ hcoef
    exact mul_le_mul_of_nonneg_left hnormh (le_of_lt hr)
  have hstep2 :
      (3 * c.gravitationalParameter / r ^ 5) *
          (r * (3 * ‖h‖)) * ‖x‖ ≤
        (3 * c.gravitationalParameter / r ^ 5) *
          (r * (3 * ‖h‖)) * r := by
    apply mul_le_mul_of_nonneg_left hnormx
    exact mul_nonneg hcoef
      (mul_nonneg (le_of_lt hr)
        (mul_nonneg (by norm_num) (norm_nonneg h)))
  have hcancel :
      (3 * c.gravitationalParameter / r ^ 5) *
          (r * (3 * ‖h‖)) * r =
        (9 * c.gravitationalParameter / r ^ 3) * ‖h‖ := by
    field_simp [ne_of_gt hr]
    ring
  have hexact :
      ‖(fderiv ℝ c.accelerationField x) h‖ ≤
        (10 * c.gravitationalParameter / r ^ 3) * ‖h‖ := by
    calc
      _ ≤ (c.gravitationalParameter / r ^ 3) * ‖h‖ +
          (3 * c.gravitationalParameter / r ^ 5) *
            (‖toPhysicalVec3 x‖ * ‖toPhysicalVec3 h‖) * ‖x‖ := hcauchy
      _ = (c.gravitationalParameter / r ^ 3) * ‖h‖ +
          (3 * c.gravitationalParameter / r ^ 5) *
            (r * ‖toPhysicalVec3 h‖) * ‖x‖ := by
          rw [← euclideanRadius_eq_physical_norm]
      _ ≤ (c.gravitationalParameter / r ^ 3) * ‖h‖ +
          (3 * c.gravitationalParameter / r ^ 5) *
            (r * (3 * ‖h‖)) * ‖x‖ :=
          add_le_add (le_refl _) hstep1
      _ ≤ (c.gravitationalParameter / r ^ 3) * ‖h‖ +
          (3 * c.gravitationalParameter / r ^ 5) *
            (r * (3 * ‖h‖)) * r :=
          add_le_add (le_refl _) hstep2
      _ = (10 * c.gravitationalParameter / r ^ 3) * ‖h‖ := by
          rw [hcancel]
          ring
  have hmu :
      c.gravitationalParameter / r ^ 3 ≤ M / d ^ 3 :=
    c.inverse_cube_parameter_le_of_clearance x d M hd hclear hM
  calc
    ‖(fderiv ℝ c.accelerationField x) h‖ ≤
        (10 * c.gravitationalParameter / r ^ 3) * ‖h‖ := hexact
    _ = (10 * (c.gravitationalParameter / r ^ 3)) * ‖h‖ := by ring
    _ ≤ (10 * (M / d ^ 3)) * ‖h‖ :=
      mul_le_mul_of_nonneg_right
        (mul_le_mul_of_nonneg_left hmu (by norm_num))
        (norm_nonneg h)
    _ = (10 * M / d ^ 3) * ‖h‖ := by ring

end NewtonianLipschitz
