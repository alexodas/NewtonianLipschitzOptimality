module

public import NewtonianLipschitz.Derivative
public import NewtonianLipschitz.JacobianRows

public section

/-!
# Exact Cartesian matrix for the Newtonian Jacobian

At every noncollision point an explicit symmetric 3 × 3 Cartesian
matrix has precisely the same action as the actual Fréchet derivative
of the inverse-cube Newtonian point-source field. This bridge is needed
for the supremum operator-norm optimization. No optimal bound is
claimed by this module.
-/

open Matrix WithLp
open scoped NNReal Topology InnerProductSpace

namespace NewtonianLipschitz

/-- The physical Euclidean inner product expressed as the Cartesian
dot product, without identifying the two vector norms. -/
theorem toPhysicalVec3_inner_eq_dotProduct (x h : Vec3) :
    ⟪toPhysicalVec3 x, toPhysicalVec3 h⟫_ℝ = x ⬝ᵥ h := by
  rw [EuclideanSpace.inner_eq_star_dotProduct]
  simp only [ofLp_toPhysicalVec3, dotProduct, Fin.sum_univ_three,
    Pi.star_apply, star_trivial]
  ring

/-- Exact Newtonian Jacobian matrix using the physical Euclidean
source radius. -/
noncomputable def newtonianJacobianMatrix
    (μ : ℝ) (x : Vec3) : Matrix (Fin 3) (Fin 3) ℝ :=
  (μ / euclideanRadius x ^ 5) •
    ((3 : ℝ) • Matrix.vecMulVec x x -
      (euclideanRadius x ^ 2) •
        (1 : Matrix (Fin 3) (Fin 3) ℝ))

/-- The exact Newtonian Jacobian matrix is symmetric. -/
theorem newtonianJacobianMatrix_symmetric
    (μ : ℝ) (x : Vec3) :
    (newtonianJacobianMatrix μ x).IsSymm := by
  have houter :
      (Matrix.vecMulVec x x).IsSymm := by
    apply Matrix.IsSymm.ext
    intro i j
    simp only [Matrix.vecMulVec_apply]
    ring
  have hid : (1 : Matrix (Fin 3) (Fin 3) ℝ).IsSymm :=
    Matrix.isSymm_one
  change ((μ / euclideanRadius x ^ 5) •
    ((3 : ℝ) • Matrix.vecMulVec x x -
      (euclideanRadius x ^ 2) •
        (1 : Matrix (Fin 3) (Fin 3) ℝ))).IsSymm
  exact ((houter.smul (3 : ℝ)).sub
    (hid.smul (euclideanRadius x ^ 2))).smul
      (μ / euclideanRadius x ^ 5)

/-- Exact matrix action on a direction at any nonzero source separation. -/
theorem newtonianJacobianMatrix_mulVec
    (μ : ℝ) (x h : Vec3) (hx : x ≠ 0) :
    newtonianJacobianMatrix μ x *ᵥ h =
      (-(μ) / euclideanRadius x ^ 3) • h +
        ((3 * μ / euclideanRadius x ^ 5) * (x ⬝ᵥ h)) • x := by
  let e : Vec3 ≃L[ℝ] PhysicalVec3 :=
    (PiLp.continuousLinearEquiv 2 ℝ (fun _ : Fin 3 => ℝ)).symm
  have hphys : e x ≠ 0 := by
    intro hz
    apply hx
    apply e.injective
    simpa only [map_zero] using hz
  have hr : euclideanRadius x ≠ 0 := by
    rw [euclideanRadius_eq_physical_norm,
      toPhysicalVec3_eq_continuousLinearEquiv]
    exact norm_ne_zero_iff.mpr hphys
  have houter :
      (Matrix.vecMulVec x x) *ᵥ h =
        (x ⬝ᵥ h) • x := by
    ext i
    simp only [Matrix.mulVec, dotProduct, Matrix.vecMulVec_apply,
      Fin.sum_univ_three, Pi.smul_apply, smul_eq_mul]
    ring
  simp only [newtonianJacobianMatrix,
    Matrix.smul_mulVec, Matrix.sub_mulVec, Matrix.one_mulVec, houter]
  ext i
  simp only [Pi.add_apply, Pi.sub_apply, Pi.smul_apply, smul_eq_mul]
  field_simp [hr] <;> ring

/-- The actual Fréchet derivative of the physical Newtonian field
agrees, in every direction, with the explicit Cartesian matrix. -/
theorem NewtonianPointSource.accelerationField_fderiv_eq_jacobianMatrix
    (c : NewtonianPointSource) (x h : Vec3) (hx : x ≠ 0) :
    (fderiv ℝ c.accelerationField x) h =
      newtonianJacobianMatrix c.gravitationalParameter x *ᵥ h := by
  rw [c.accelerationField_fderiv_full x h hx,
    newtonianJacobianMatrix_mulVec c.gravitationalParameter x h hx,
    toPhysicalVec3_inner_eq_dotProduct]

/-!
## Direct connection with the dominant row numerator

This is a concrete bridge, not merely a definition of an algebraic
candidate: all entries below are entries of the actual Newtonian
Jacobian matrix proved equal to the Fréchet derivative above.
-/

/-- Cartesian entries of the exact point-source Jacobian. -/
theorem newtonianJacobianMatrix_entry
    (μ : ℝ) (x : Vec3) (i j : Fin 3) :
    newtonianJacobianMatrix μ x i j =
      (μ / euclideanRadius x ^ 5) *
        (3 * x i * x j -
          euclideanRadius x ^ 2 * (if i = j then 1 else 0)) := by
  simp only [newtonianJacobianMatrix, Matrix.smul_apply,
    Matrix.sub_apply, Matrix.vecMulVec_apply, Matrix.one_apply,
    smul_eq_mul]
  ring

/-- Nonnegative-octant normalization with first coordinate one. -/
def normalizedVector (u v : ℝ) : Vec3 :=
  ![(1 : ℝ), u, v]

@[simp] theorem normalizedVector_zero (u v : ℝ) :
    normalizedVector u v 0 = 1 := by
  rfl

@[simp] theorem normalizedVector_one (u v : ℝ) :
    normalizedVector u v 1 = u := by
  rfl

@[simp] theorem normalizedVector_two (u v : ℝ) :
    normalizedVector u v 2 = v := by
  rfl

/-- Square of the physical Euclidean radius of the normalized vector. -/
theorem normalizedVector_radius_sq (u v : ℝ) :
    euclideanRadius (normalizedVector u v) ^ 2 =
      1 + u ^ 2 + v ^ 2 := by
  rw [euclideanRadius_eq_coordinates]
  change Real.sqrt ((1 : ℝ) ^ 2 + u ^ 2 + v ^ 2) ^ 2 =
    1 + u ^ 2 + v ^ 2
  rw [Real.sq_sqrt (by positivity : 0 ≤ (1 : ℝ) ^ 2 + u ^ 2 + v ^ 2)]
  ring

/-- Exact diagonal entry of the maximal-coordinate row. -/
theorem newtonianJacobianMatrix_normalized_zero_zero
    (μ u v : ℝ) :
    newtonianJacobianMatrix μ (normalizedVector u v) 0 0 =
      (μ / euclideanRadius (normalizedVector u v) ^ 5) *
        (2 - u ^ 2 - v ^ 2) := by
  rw [newtonianJacobianMatrix_entry, normalizedVector_radius_sq]
  simp only [normalizedVector_zero, if_pos rfl]
  ring

/-- First off-diagonal entry of the maximal-coordinate row. -/
theorem newtonianJacobianMatrix_normalized_zero_one
    (μ u v : ℝ) :
    newtonianJacobianMatrix μ (normalizedVector u v) 0 1 =
      (μ / euclideanRadius (normalizedVector u v) ^ 5) *
        (3 * u) := by
  rw [newtonianJacobianMatrix_entry]
  norm_num

/-- Second off-diagonal entry of the maximal-coordinate row. -/
theorem newtonianJacobianMatrix_normalized_zero_two
    (μ u v : ℝ) :
    newtonianJacobianMatrix μ (normalizedVector u v) 0 2 =
      (μ / euclideanRadius (normalizedVector u v) ^ 5) *
        (3 * v) := by
  rw [newtonianJacobianMatrix_entry]
  norm_num

/-- The sum of absolute values in the *actual matrix's* first row
is the previously defined dominant numerator divided by the fifth
power of the physical Euclidean radius. -/
theorem newtonianJacobianMatrix_normalized_firstRow_abs_sum
    (μ u v : ℝ) (hμ : 0 ≤ μ)
    (hu0 : 0 ≤ u) (hu1 : u ≤ 1)
    (hv0 : 0 ≤ v) (hv1 : v ≤ 1) :
    (∑ j : Fin 3,
      |newtonianJacobianMatrix μ (normalizedVector u v) 0 j|) =
      (μ / euclideanRadius (normalizedVector u v) ^ 5) *
        dominantRowNumerator u v := by
  have hr : 0 ≤ euclideanRadius (normalizedVector u v) := by
    rw [euclideanRadius_eq_physical_norm]
    exact norm_nonneg _
  have hk :
      0 ≤ μ / euclideanRadius (normalizedVector u v) ^ 5 :=
    div_nonneg hμ (pow_nonneg hr _)
  have hu_prod : 0 ≤ (1 - u) * (1 + u) :=
    mul_nonneg (by linarith) (by linarith)
  have hv_prod : 0 ≤ (1 - v) * (1 + v) :=
    mul_nonneg (by linarith) (by linarith)
  have hdiag : 0 ≤ 2 - u ^ 2 - v ^ 2 := by
    nlinarith [hu_prod, hv_prod]
  rw [Fin.sum_univ_three,
    newtonianJacobianMatrix_normalized_zero_zero,
    newtonianJacobianMatrix_normalized_zero_one,
    newtonianJacobianMatrix_normalized_zero_two]
  rw [abs_of_nonneg (mul_nonneg hk hdiag),
    abs_of_nonneg (mul_nonneg hk (mul_nonneg (by norm_num) hu0)),
    abs_of_nonneg (mul_nonneg hk (mul_nonneg (by norm_num) hv0))]
  rw [dominantRowNumerator_eq]
  ring

end NewtonianLipschitz
