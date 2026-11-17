module

public import NewtonianLipschitz.JacobianPermutations

public section

/-!
# Transfer of the normalized sharp bound to positive displacements

The normalized row bound is verified for (1,u,v) with 0 <= u,v <= 1.
Here it is transferred to any nonnegative displacement whose first
coordinate is positive and maximal, using exact positive scaling.
All other coordinate orders and signs remain separate obligations.
-/

namespace NewtonianLipschitz

/-- Scaling by a positive factor c scales every absolute Jacobian
row sum by c^(-3), provided the original displacement is nonzero. -/
theorem newtonianJacobianMatrix_rowSum_positive_smul
    (μ c : ℝ) (x : Vec3) (i : Fin 3)
    (hc : 0 < c) (hx : x ≠ 0) :
    (∑ j : Fin 3, |newtonianJacobianMatrix μ (c • x) i j|) =
      (1 / c ^ 3) *
        (∑ j : Fin 3, |newtonianJacobianMatrix μ x i j|) := by
  calc
    (∑ j : Fin 3, |newtonianJacobianMatrix μ (c • x) i j|)
      = ∑ j : Fin 3,
          |(1 / c ^ 3) * newtonianJacobianMatrix μ x i j| := by
        apply Finset.sum_congr rfl
        intro j hj
        rw [newtonianJacobianMatrix_entry_positive_smul μ c x i j hc hx]
    _ = (1 / c ^ 3) *
          (∑ j : Fin 3, |newtonianJacobianMatrix μ x i j|) := by
        rw [Finset.mul_sum]
        apply Finset.sum_congr rfl
        intro j hj
        rw [abs_mul, abs_of_nonneg
          (by positivity : (0 : ℝ) ≤ 1 / c ^ 3)]

/-- If X is positive, a nonnegative displacement is exactly
its X coordinate times a vector whose first coordinate is one. -/
theorem positive_first_coordinate_normalization
    (x : Vec3) (hx0 : 0 < x 0) :
    (x 0) • normalizedVector (x 1 / x 0) (x 2 / x 0) = x := by
  have hfirst :
      ((x 0) • normalizedVector (x 1 / x 0) (x 2 / x 0)) 0 =
        x 0 := by
    simp only [Pi.smul_apply, smul_eq_mul, normalizedVector_zero]
    ring
  have hsecond :
      ((x 0) • normalizedVector (x 1 / x 0) (x 2 / x 0)) 1 =
        x 1 := by
    simp only [Pi.smul_apply, smul_eq_mul, normalizedVector_one]
    field_simp [ne_of_gt hx0] <;> ring
  have hthird :
      ((x 0) • normalizedVector (x 1 / x 0) (x 2 / x 0)) 2 =
        x 2 := by
    simp only [Pi.smul_apply, smul_eq_mul, normalizedVector_two]
    field_simp [ne_of_gt hx0] <;> ring
  ext i
  fin_cases i
  · simpa using hfirst
  · simpa using hsecond
  · simpa using hthird

/-- The sharp candidate bounds every row of the physical
Jacobian when X is the largest nonnegative coordinate.
This is not yet the unrestricted 3D derivative theorem. -/
theorem newtonianJacobianMatrix_firstMax_le_candidateMaximum
    (μ : ℝ) (x : Vec3) (i : Fin 3)
    (hμ : 0 ≤ μ)
    (hx0 : 0 < x 0)
    (hx10 : 0 ≤ x 1) (hx1 : x 1 ≤ x 0)
    (hx20 : 0 ≤ x 2) (hx2 : x 2 ≤ x 0) :
    (∑ j : Fin 3, |newtonianJacobianMatrix μ x i j|) ≤
      (1 / (x 0) ^ 3) * (μ * candidateMaximum) := by
  let u : ℝ := x 1 / x 0
  let v : ℝ := x 2 / x 0
  let z : Vec3 := normalizedVector u v
  have hu0 : 0 ≤ u := div_nonneg hx10 hx0.le
  have hu1 : u ≤ 1 := (div_le_iff₀ hx0).2 (by simpa only [one_mul] using hx1)
  have hv0 : 0 ≤ v := div_nonneg hx20 hx0.le
  have hv1 : v ≤ 1 := (div_le_iff₀ hx0).2 (by simpa only [one_mul] using hx2)
  have hz : z ≠ 0 := by
    intro hzero
    have hfirst := congrArg (fun w : Vec3 => w 0) hzero
    simp only [z, normalizedVector_zero, Pi.zero_apply] at hfirst
    norm_num at hfirst
  have hvec : (x 0) • z = x :=
    positive_first_coordinate_normalization x hx0
  have hnorm :=
    newtonianJacobianMatrix_normalized_allRows_le_candidateMaximum
      μ u v hμ hu0 hu1 hv0 hv1 i
  calc
    (∑ j : Fin 3, |newtonianJacobianMatrix μ x i j|)
      = ∑ j : Fin 3,
          |newtonianJacobianMatrix μ ((x 0) • z) i j| := by
        rw [hvec]
    _ = (1 / (x 0) ^ 3) *
          (∑ j : Fin 3, |newtonianJacobianMatrix μ z i j|) :=
        newtonianJacobianMatrix_rowSum_positive_smul
          μ (x 0) z i hx0 hz
    _ ≤ (1 / (x 0) ^ 3) * (μ * candidateMaximum) :=
        mul_le_mul_of_nonneg_left hnorm (by positivity)

end NewtonianLipschitz
