module

public import NewtonianLipschitz.NormalizedSharpBound

public section

/-!
# Coordinate signs and positive scaling of the exact Newtonian Jacobian

The normalized positive-octant row bounds have been kernel checked.
This module records two structural invariances needed to transfer
those inequalities to arbitrary Cartesian displacements.

The statements below concern the actual Jacobian, not a candidate
matrix defined only for the reduction. No unrestricted sharp bound
is asserted here.
-/

namespace NewtonianLipschitz

/-- Replace each Cartesian coordinate by its absolute value. -/
def coordinateAbs (x : Vec3) : Vec3 := fun i => |x i|

@[simp] theorem coordinateAbs_apply (x : Vec3) (i : Fin 3) :
    coordinateAbs x i = |x i| := by
  rfl

/-- Taking absolute values componentwise preserves physical radius. -/
theorem euclideanRadius_coordinateAbs (x : Vec3) :
    euclideanRadius (coordinateAbs x) = euclideanRadius x := by
  rw [euclideanRadius_eq_coordinates (coordinateAbs x),
    euclideanRadius_eq_coordinates x]
  simp only [coordinateAbs_apply, sq_abs]

/-- The elementary numerator of the physical matrix has an
absolute value invariant under coordinatewise sign changes. -/
theorem newtonianJacobianNumerator_coordinateAbs (x : Vec3)
    (i j : Fin 3) :
    |3 * coordinateAbs x i * coordinateAbs x j -
      euclideanRadius x ^ 2 * (if i = j then 1 else 0)| =
    |3 * x i * x j -
      euclideanRadius x ^ 2 * (if i = j then 1 else 0)| := by
  simp only [coordinateAbs_apply]
  by_cases hij : i = j
  · subst j
    simp only [if_pos rfl, mul_one]
    have hsq : (3 : ℝ) * |x i| * |x i| =
        3 * x i * x i := by
      nlinarith [sq_abs (x i)]
    rw [hsq]
  · simp only [if_neg hij, mul_zero, sub_zero, abs_mul, abs_abs]

/-- Every absolute matrix entry is unaffected by changing the signs
of any subset of the three Cartesian coordinates. -/
theorem newtonianJacobianMatrix_entry_abs_coordinateAbs
    (μ : ℝ) (x : Vec3) (i j : Fin 3) :
    |newtonianJacobianMatrix μ (coordinateAbs x) i j| =
      |newtonianJacobianMatrix μ x i j| := by
  rw [newtonianJacobianMatrix_entry μ (coordinateAbs x) i j,
    newtonianJacobianMatrix_entry μ x i j,
    euclideanRadius_coordinateAbs]
  simp only [abs_mul]
  rw [newtonianJacobianNumerator_coordinateAbs]

/-- Every row's sum of absolute values is invariant under replacing
the original coordinates by their absolute values. -/
theorem newtonianJacobianMatrix_rowSum_coordinateAbs
    (μ : ℝ) (x : Vec3) (i : Fin 3) :
    (∑ j : Fin 3, |newtonianJacobianMatrix μ (coordinateAbs x) i j|) =
      ∑ j : Fin 3, |newtonianJacobianMatrix μ x i j| := by
  apply Finset.sum_congr rfl
  intro j hj
  exact newtonianJacobianMatrix_entry_abs_coordinateAbs μ x i j

/-- The physical Euclidean radius scales like an ordinary norm. -/
theorem euclideanRadius_smul (c : ℝ) (x : Vec3) :
    euclideanRadius (c • x) = |c| * euclideanRadius x := by
  rw [euclideanRadius_eq_physical_norm (c • x),
    euclideanRadius_eq_physical_norm x,
    toPhysicalVec3_eq_continuousLinearEquiv (c • x),
    toPhysicalVec3_eq_continuousLinearEquiv x]
  rw [map_smul, norm_smul, Real.norm_eq_abs]

/-- Under a positive spatial rescaling by c, each exact Newtonian
Jacobian entry is multiplied by c^(-3). -/
theorem newtonianJacobianMatrix_entry_positive_smul
    (μ c : ℝ) (x : Vec3) (i j : Fin 3)
    (hc : 0 < c) (hx : x ≠ 0) :
    newtonianJacobianMatrix μ (c • x) i j =
      (1 / c ^ 3) * newtonianJacobianMatrix μ x i j := by
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
  rw [newtonianJacobianMatrix_entry μ (c • x) i j,
    newtonianJacobianMatrix_entry μ x i j,
    euclideanRadius_smul, abs_of_pos hc]
  simp only [Pi.smul_apply, smul_eq_mul]
  field_simp [ne_of_gt hc, hr] <;> ring

end NewtonianLipschitz
