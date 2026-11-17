module

public import NewtonianLipschitz.JacobianCartesianBound

public section

/-!
# From exact Jacobian row sums to Cartesian directional action

For the supremum norm, every coordinate of a matrix-vector
product is bounded by the corresponding absolute row sum
times the norm of the direction.

This combines the verified pointwise candidate row bound
with the actual Newtonian Frechet derivative. It is not
a global two-point theorem across nonconvex safety cubes.
-/

open Matrix

namespace NewtonianLipschitz

/-- Each coordinate of a three-by-three matrix-vector product
is bounded by its row's absolute sum times the direction norm. -/
theorem matrix3_mulVec_coordinate_abs_le_rowSum
    (A : Matrix (Fin 3) (Fin 3) ℝ) (h : Vec3) (i : Fin 3) :
    |(A *ᵥ h) i| ≤ (∑ j : Fin 3, |A i j|) * ‖h‖ := by
  have hterm (j : Fin 3) :
      |A i j * h j| ≤ |A i j| * ‖h‖ := by
    rw [abs_mul]
    apply mul_le_mul_of_nonneg_left
      (by simpa only [Real.norm_eq_abs] using (norm_le_pi_norm h j))
      (abs_nonneg _)
  have htri :
      |A i 0 * h 0 + A i 1 * h 1 + A i 2 * h 2| ≤
        |A i 0 * h 0| + |A i 1 * h 1| +
          |A i 2 * h 2| := by
    have hfirst :=
      abs_add_le (A i 0 * h 0 + A i 1 * h 1) (A i 2 * h 2)
    have hsecond := abs_add_le (A i 0 * h 0) (A i 1 * h 1)
    linarith
  have hbound :
      |A i 0 * h 0 + A i 1 * h 1 + A i 2 * h 2| ≤
        (|A i 0| + |A i 1| + |A i 2|) * ‖h‖ := by
    calc
      |A i 0 * h 0 + A i 1 * h 1 + A i 2 * h 2|
        ≤ |A i 0 * h 0| + |A i 1 * h 1| +
            |A i 2 * h 2| := htri
      _ ≤ |A i 0| * ‖h‖ + |A i 1| * ‖h‖ +
            |A i 2| * ‖h‖ := by
          exact add_le_add (add_le_add (hterm 0) (hterm 1))
            (hterm 2)
      _ = (|A i 0| + |A i 1| + |A i 2|) * ‖h‖ := by
          ring
  simpa only [Matrix.mulVec, dotProduct, Fin.sum_univ_three]
    using hbound

/-- The true Newtonian Jacobian acts on any direction
with the candidate factor in the Cartesian supremum norm. -/
theorem newtonianJacobianMatrix_mulVec_norm_le_candidateMaximum
    (μ : ℝ) (x h : Vec3)
    (hμ : 0 ≤ μ) (hx : x ≠ 0) :
    ‖newtonianJacobianMatrix μ x *ᵥ h‖ ≤
      ((1 / ‖x‖ ^ 3) * (μ * candidateMaximum)) * ‖h‖ := by
  have hfactor :
      0 ≤ (1 / ‖x‖ ^ 3) * (μ * candidateMaximum) :=
    mul_nonneg (by positivity)
      (mul_nonneg hμ candidateMaximum_nonneg)
  apply (pi_norm_le_iff_of_nonneg
    (mul_nonneg hfactor (norm_nonneg h))).2
  intro i
  have hcoord :
      |(newtonianJacobianMatrix μ x *ᵥ h) i| ≤
        ((1 / ‖x‖ ^ 3) * (μ * candidateMaximum)) * ‖h‖ := by
    calc
      |(newtonianJacobianMatrix μ x *ᵥ h) i|
        ≤ (∑ j : Fin 3,
            |newtonianJacobianMatrix μ x i j|) * ‖h‖ :=
          matrix3_mulVec_coordinate_abs_le_rowSum
            (newtonianJacobianMatrix μ x) h i
      _ ≤ ((1 / ‖x‖ ^ 3) * (μ * candidateMaximum)) * ‖h‖ :=
        mul_le_mul_of_nonneg_right
          (newtonianJacobianMatrix_rowSum_le_candidateMaximum_norm
            μ x i hμ hx) (norm_nonneg h)
  simpa only [Real.norm_eq_abs] using hcoord

/-- The genuine Frechet derivative has the same candidate
directional bound as the exact physical Jacobian matrix. -/
theorem NewtonianPointSource.accelerationField_fderiv_norm_le_candidateMaximum
    (c : NewtonianPointSource) (x h : Vec3) (hx : x ≠ 0) :
    ‖(fderiv ℝ c.accelerationField x) h‖ ≤
      ((1 / ‖x‖ ^ 3) *
        (c.gravitationalParameter * candidateMaximum)) * ‖h‖ := by
  rw [c.accelerationField_fderiv_eq_jacobianMatrix x h hx]
  exact newtonianJacobianMatrix_mulVec_norm_le_candidateMaximum
    c.gravitationalParameter x h c.gravitationalParameter_nonneg hx

end NewtonianLipschitz
