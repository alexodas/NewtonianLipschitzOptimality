module

public import NewtonianLipschitz.PhysicalTangentialFirstAxis

public section

/-!
# The physical Newtonian 5/4 tangential derivative bound on every safe axis

R045 proves the bound when the first Cartesian coordinate is safe.
Here cyclic permutation of the EXACT Newtonian Jacobian transfers that
bound to a safe second or third coordinate. We then bound matrix action
on a direction whose corresponding coordinate vanishes.

This proves the full pointwise directional estimate for arbitrary
safe Cartesian axis, signs, and positive clearance. It does not
integrate this bound into a finite-difference theorem.
-/

open Matrix

namespace NewtonianLipschitz

/-- When the second coordinate is the fixed safe coordinate, the
remaining columns 0 and 2 of every row obey the same physical
Newtonian 5/4 estimate. -/
theorem newtonianJacobianMatrix_second_safe_axis_tangent_columns_le
    (μ d : ℝ) (x : Vec3) (k : Fin 3)
    (hμ : 0 ≤ μ) (hd : 0 < d) (hx : d ≤ |x 1|) :
    |newtonianJacobianMatrix μ x k 0| +
        |newtonianJacobianMatrix μ x k 2| ≤
      (1 / d ^ 3) * (μ * (5 / 4 : ℝ)) := by
  have hcy : d ≤ |(cycleVec x) 0| := by
    simpa only [cycleVec_zero] using hx
  have hfirst :=
    newtonianJacobianMatrix_first_safe_axis_tangent_columns_le
      μ d (cycleVec x) (cycleIndex (cycleIndex k)) hμ hd hcy
  simpa only [newtonianJacobianMatrix_cycle_entry,
      cycleIndex_three, cycleIndex_one, cycleIndex_two,
      add_comm] using hfirst

/-- When the third coordinate is fixed and safe, the
remaining physical Jacobian columns 0 and 1 obey 5/4. -/
theorem newtonianJacobianMatrix_third_safe_axis_tangent_columns_le
    (μ d : ℝ) (x : Vec3) (k : Fin 3)
    (hμ : 0 ≤ μ) (hd : 0 < d) (hx : d ≤ |x 2|) :
    |newtonianJacobianMatrix μ x k 0| +
        |newtonianJacobianMatrix μ x k 1| ≤
      (1 / d ^ 3) * (μ * (5 / 4 : ℝ)) := by
  have hcy : d ≤ |(cycleVec (cycleVec x)) 0| := by
    simpa only [cycleVec_zero, cycleVec_one] using hx
  have hfirst :=
    newtonianJacobianMatrix_first_safe_axis_tangent_columns_le
      μ d (cycleVec (cycleVec x)) (cycleIndex k) hμ hd hcy
  simpa only [newtonianJacobianMatrix_cycle_entry,
      cycleIndex_three, cycleIndex_zero,
      cycleIndex_one, cycleIndex_two] using hfirst

/-- Matrix action estimate when the SECOND input coordinate is
zero; the relevant row sum uses only columns 0 and 2. -/
theorem matrix3_mulVec_tangent_one_norm_le
    (A : Matrix (Fin 3) (Fin 3) ℝ) (h : Vec3)
    (hzero : h 1 = 0) (B : ℝ) (hB : 0 ≤ B)
    (hrows : ∀ k : Fin 3, |A k 0| + |A k 2| ≤ B) :
    ‖A *ᵥ h‖ ≤ B * ‖h‖ := by
  apply (pi_norm_le_iff_of_nonneg
    (mul_nonneg hB (norm_nonneg h))).2
  intro k
  have h0 : |h 0| ≤ ‖h‖ := by
    simpa only [Real.norm_eq_abs] using
      (norm_le_pi_norm h (0 : Fin 3))
  have h2 : |h 2| ≤ ‖h‖ := by
    simpa only [Real.norm_eq_abs] using
      (norm_le_pi_norm h (2 : Fin 3))
  have hterm0 : |A k 0 * h 0| ≤ |A k 0| * ‖h‖ := by
    rw [abs_mul]
    exact mul_le_mul_of_nonneg_left h0 (abs_nonneg _)
  have hterm2 : |A k 2 * h 2| ≤ |A k 2| * ‖h‖ := by
    rw [abs_mul]
    exact mul_le_mul_of_nonneg_left h2 (abs_nonneg _)
  have hbound : |(A *ᵥ h) k| ≤ (|A k 0| + |A k 2|) * ‖h‖ := by
    calc
      |(A *ᵥ h) k| = |A k 0 * h 0 + A k 2 * h 2| := by
        simp only [Matrix.mulVec, dotProduct, Fin.sum_univ_three,
          hzero, mul_zero, add_zero]
      _ ≤ |A k 0 * h 0| + |A k 2 * h 2| :=
        abs_add_le _ _
      _ ≤ |A k 0| * ‖h‖ + |A k 2| * ‖h‖ :=
        add_le_add hterm0 hterm2
      _ = (|A k 0| + |A k 2|) * ‖h‖ := by ring
  calc
    ‖(A *ᵥ h) k‖ = |(A *ᵥ h) k| := Real.norm_eq_abs _
    _ ≤ (|A k 0| + |A k 2|) * ‖h‖ := hbound
    _ ≤ B * ‖h‖ :=
      mul_le_mul_of_nonneg_right (hrows k) (norm_nonneg h)

/-- Matrix action estimate when the THIRD input coordinate is
zero; the relevant row sum uses only columns 0 and 1. -/
theorem matrix3_mulVec_tangent_two_norm_le
    (A : Matrix (Fin 3) (Fin 3) ℝ) (h : Vec3)
    (hzero : h 2 = 0) (B : ℝ) (hB : 0 ≤ B)
    (hrows : ∀ k : Fin 3, |A k 0| + |A k 1| ≤ B) :
    ‖A *ᵥ h‖ ≤ B * ‖h‖ := by
  apply (pi_norm_le_iff_of_nonneg
    (mul_nonneg hB (norm_nonneg h))).2
  intro k
  have h0 : |h 0| ≤ ‖h‖ := by
    simpa only [Real.norm_eq_abs] using
      (norm_le_pi_norm h (0 : Fin 3))
  have h1 : |h 1| ≤ ‖h‖ := by
    simpa only [Real.norm_eq_abs] using
      (norm_le_pi_norm h (1 : Fin 3))
  have hterm0 : |A k 0 * h 0| ≤ |A k 0| * ‖h‖ := by
    rw [abs_mul]
    exact mul_le_mul_of_nonneg_left h0 (abs_nonneg _)
  have hterm1 : |A k 1 * h 1| ≤ |A k 1| * ‖h‖ := by
    rw [abs_mul]
    exact mul_le_mul_of_nonneg_left h1 (abs_nonneg _)
  have hbound : |(A *ᵥ h) k| ≤ (|A k 0| + |A k 1|) * ‖h‖ := by
    calc
      |(A *ᵥ h) k| = |A k 0 * h 0 + A k 1 * h 1| := by
        simp only [Matrix.mulVec, dotProduct, Fin.sum_univ_three,
          hzero, mul_zero, add_zero]
      _ ≤ |A k 0 * h 0| + |A k 1 * h 1| :=
        abs_add_le _ _
      _ ≤ |A k 0| * ‖h‖ + |A k 1| * ‖h‖ :=
        add_le_add hterm0 hterm1
      _ = (|A k 0| + |A k 1|) * ‖h‖ := by ring
  calc
    ‖(A *ᵥ h) k‖ = |(A *ᵥ h) k| := Real.norm_eq_abs _
    _ ≤ (|A k 0| + |A k 1|) * ‖h‖ := hbound
    _ ≤ B * ‖h‖ :=
      mul_le_mul_of_nonneg_right (hrows k) (norm_nonneg h)

/-- The physical Newtonian Jacobian has tangent-column row
sum at most (5/4)*μ/d³ on ANY of the three safe axes. -/
theorem newtonianJacobianMatrix_any_safe_axis_tangent_columns_le
    (μ d : ℝ) (x : Vec3) (k i : Fin 3)
    (hμ : 0 ≤ μ) (hd : 0 < d) (hx : d ≤ |x i|) :
    (if i = 0 then
      |newtonianJacobianMatrix μ x k 1| +
        |newtonianJacobianMatrix μ x k 2|
     else if i = 1 then
      |newtonianJacobianMatrix μ x k 0| +
        |newtonianJacobianMatrix μ x k 2|
     else
      |newtonianJacobianMatrix μ x k 0| +
        |newtonianJacobianMatrix μ x k 1|) ≤
        (1 / d ^ 3) * (μ * (5 / 4 : ℝ)) := by
  fin_cases i
  · simpa using
      newtonianJacobianMatrix_first_safe_axis_tangent_columns_le
        μ d x k hμ hd hx
  · simpa using
      newtonianJacobianMatrix_second_safe_axis_tangent_columns_le
        μ d x k hμ hd hx
  · simpa using
      newtonianJacobianMatrix_third_safe_axis_tangent_columns_le
        μ d x k hμ hd hx

/-- The genuine Newtonian Frechet derivative has the
exact 5/4 directional factor on EVERY signed-safe axis,
for any real position and any positive clearance d. -/
theorem NewtonianPointSource.accelerationField_fderiv_any_safe_axis_tangent_le
    (c : NewtonianPointSource) (x h : Vec3) (d : ℝ)
    (hd : 0 < d) (i : Fin 3)
    (hx : d ≤ |x i|) (hh : h i = 0) :
    ‖(fderiv ℝ c.accelerationField x) h‖ ≤
      ((1 / d ^ 3) *
        (c.gravitationalParameter * (5 / 4 : ℝ))) * ‖h‖ := by
  have hx_ne : x ≠ 0 := by
    intro hz
    have hz_i := congrArg (fun q : Vec3 => q i) hz
    simp only [Pi.zero_apply] at hz_i
    rw [hz_i, abs_zero] at hx
    linarith
  rw [c.accelerationField_fderiv_eq_jacobianMatrix x h hx_ne]
  let B : ℝ :=
    (1 / d ^ 3) * (c.gravitationalParameter * (5 / 4 : ℝ))
  have hB : 0 ≤ B :=
    mul_nonneg (by positivity)
      (mul_nonneg c.gravitationalParameter_nonneg (by norm_num))
  change ‖newtonianJacobianMatrix c.gravitationalParameter x *ᵥ h‖ ≤
    B * ‖h‖
  fin_cases i
  · exact matrix3_mulVec_tangent_zero_norm_le
      (newtonianJacobianMatrix c.gravitationalParameter x)
      h hh B hB (fun k =>
        newtonianJacobianMatrix_first_safe_axis_tangent_columns_le
          c.gravitationalParameter d x k
          c.gravitationalParameter_nonneg hd hx)
  · exact matrix3_mulVec_tangent_one_norm_le
      (newtonianJacobianMatrix c.gravitationalParameter x)
      h hh B hB (fun k =>
        newtonianJacobianMatrix_second_safe_axis_tangent_columns_le
          c.gravitationalParameter d x k
          c.gravitationalParameter_nonneg hd hx)
  · exact matrix3_mulVec_tangent_two_norm_le
      (newtonianJacobianMatrix c.gravitationalParameter x)
      h hh B hB (fun k =>
        newtonianJacobianMatrix_third_safe_axis_tangent_columns_le
          c.gravitationalParameter d x k
          c.gravitationalParameter_nonneg hd hx)

end NewtonianLipschitz
