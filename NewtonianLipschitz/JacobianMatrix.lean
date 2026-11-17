module

public import NewtonianLipschitz.Derivative

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

end NewtonianLipschitz
