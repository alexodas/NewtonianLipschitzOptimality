module

public import NewtonianLipschitz.Smoothness
public import NewtonianLipschitz.Norms

public section

/-!
# Exact Newtonian Fréchet derivative

The scalar product rule and full directional derivative are proved for
the exact inverse-cube field; these results will support a separate
supremum-operator-norm optimization. No optimal constant is asserted.
-/

open scoped NNReal Topology InnerProductSpace

namespace NewtonianLipschitz

noncomputable def NewtonianPointSource.radialCoefficient
    (c : NewtonianPointSource) (x : Vec3) : ℝ :=
  -(c.gravitationalParameter) / euclideanRadius x ^ 3

/-- Exact acceleration factorization into scalar and vector. -/
theorem NewtonianPointSource.accelerationField_eq_radialCoefficient_smul
    (c : NewtonianPointSource) (x : Vec3) :
    c.accelerationField x = c.radialCoefficient x • x := by
  rfl

/-- R036: conditional product-rule factorization of the TRUE
Fréchet derivative. The scalar differentiability assumption is
supplied rather than proved from noncollision. -/
theorem NewtonianPointSource.accelerationField_fderiv_product
    (c : NewtonianPointSource) (x : Vec3)
    (hcoeff : DifferentiableAt ℝ c.radialCoefficient x) :
    fderiv ℝ c.accelerationField x =
      c.radialCoefficient x • ContinuousLinearMap.id ℝ Vec3 +
        (fderiv ℝ c.radialCoefficient x).smulRight x := by
  have hc : HasFDerivAt c.radialCoefficient
      (fderiv ℝ c.radialCoefficient x) x :=
    hcoeff.hasFDerivAt
  have hid : HasFDerivAt (fun y : Vec3 => y)
      (ContinuousLinearMap.id ℝ Vec3) x :=
    hasFDerivAt_id x
  have hsmul := hc.smul hid
  change fderiv ℝ (fun y : Vec3 => c.radialCoefficient y • y) x =
    c.radialCoefficient x • ContinuousLinearMap.id ℝ Vec3 +
      (fderiv ℝ c.radialCoefficient x).smulRight x
  exact hsmul.fderiv

theorem NewtonianPointSource.radialCoefficient_contDiffAt
    (c : NewtonianPointSource) (x : Vec3) (hx : x ≠ 0) :
    ContDiffAt ℝ 1 c.radialCoefficient x := by
  let e : Vec3 ≃L[ℝ] PhysicalVec3 :=
    (PiLp.continuousLinearEquiv 2 ℝ (fun _ : Fin 3 => ℝ)).symm
  have hphys : e x ≠ 0 := by
    intro hz
    apply hx
    apply e.injective
    simpa only [map_zero] using hz
  have hnorm : ContDiffAt ℝ 1 (fun y : Vec3 => ‖e y‖) x := by
    exact (contDiffAt_norm ℝ hphys).comp x e.contDiff.contDiffAt
  have hpow : ContDiffAt ℝ 1 (fun y : Vec3 => ‖e y‖ ^ 3) x :=
    hnorm.pow 3
  have hpow_ne : ‖e x‖ ^ 3 ≠ 0 :=
    pow_ne_zero _ (norm_ne_zero_iff.mpr hphys)
  have hscalar : ContDiffAt ℝ 1
      (fun y : Vec3 => -(c.gravitationalParameter) / ‖e y‖ ^ 3) x :=
    contDiffAt_const.div hpow hpow_ne
  have hrepr : c.radialCoefficient =
      (fun y : Vec3 => -(c.gravitationalParameter) / ‖e y‖ ^ 3) := by
    funext y
    change -(c.gravitationalParameter) / euclideanRadius y ^ 3 =
      -(c.gravitationalParameter) / ‖e y‖ ^ 3
    rw [euclideanRadius_eq_physical_norm,
      toPhysicalVec3_eq_continuousLinearEquiv]
  rw [hrepr]
  exact hscalar

/-- R037: R036's radial-prefactor differentiability premise is
unconditionally available at any noncolliding source separation. -/
theorem NewtonianPointSource.radialCoefficient_differentiableAt_of_ne_zero
    (c : NewtonianPointSource) (x : Vec3) (hx : x ≠ 0) :
    DifferentiableAt ℝ c.radialCoefficient x := by
  exact (c.radialCoefficient_contDiffAt x hx).differentiableAt_one

/-- Eliminate R036's formerly supplied radial regularity premise
from the product-rule formula, still without evaluating the radial
Fréchet derivative explicitly. -/
theorem NewtonianPointSource.accelerationField_fderiv_product_of_ne_zero
    (c : NewtonianPointSource) (x : Vec3) (hx : x ≠ 0) :
    fderiv ℝ c.accelerationField x =
      c.radialCoefficient x • ContinuousLinearMap.id ℝ Vec3 +
        (fderiv ℝ c.radialCoefficient x).smulRight x := by
  exact c.accelerationField_fderiv_product x
    (c.radialCoefficient_differentiableAt_of_ne_zero x hx)

theorem NewtonianPointSource.radialCoefficient_fderiv_full
    (c : NewtonianPointSource) (x h : Vec3) (hx : x ≠ 0) :
    (fderiv ℝ c.radialCoefficient x) h =
      (3 * c.gravitationalParameter / euclideanRadius x ^ 5) *
        ⟪toPhysicalVec3 x, toPhysicalVec3 h⟫_ℝ := by
  let e : Vec3 ≃L[ℝ] PhysicalVec3 :=
    (PiLp.continuousLinearEquiv 2 ℝ (fun _ : Fin 3 => ℝ)).symm
  have hphys : e x ≠ 0 := by
    intro hz
    apply hx
    apply e.injective
    simpa only [map_zero] using hz
  have hr : ‖e x‖ ≠ 0 := norm_ne_zero_iff.mpr hphys
  let Q : Vec3 →L[ℝ] ℝ :=
    ((2 : ℕ) • (innerSL ℝ) (e x)).comp
      (e : Vec3 →L[ℝ] PhysicalVec3)
  have hsq :
      HasFDerivAt (fun y : Vec3 => ‖e y‖ ^ 2) Q x := by
    dsimp only [Q]
    exact ((hasStrictFDerivAt_norm_sq (e x)).hasFDerivAt).comp
      x e.hasFDerivAt
  have hroot :
      HasFDerivAt (fun y : Vec3 => ‖e y‖)
        ((1 / (2 * ‖e x‖)) • Q) x := by
    have hs := hsq.sqrt (pow_ne_zero 2 hr)
    have hfun :
        (fun y : Vec3 => Real.sqrt (‖e y‖ ^ 2)) =
          (fun y : Vec3 => ‖e y‖) := by
      funext y
      exact Real.sqrt_sq (norm_nonneg (e y))
    rw [hfun, Real.sqrt_sq (norm_nonneg (e x))] at hs
    exact hs
  have hpow :
      HasDerivAt (fun t : ℝ => t ^ 3)
        (3 * ‖e x‖ ^ 2) ‖e x‖ := by
    simpa using (hasDerivAt_pow 3 (‖e x‖))
  have hquot :
      HasDerivAt
        (fun t : ℝ => -(c.gravitationalParameter) / t ^ 3)
        (3 * c.gravitationalParameter / ‖e x‖ ^ 4) ‖e x‖ := by
    have h :=
      (hasDerivAt_const (‖e x‖) (-(c.gravitationalParameter))).div
        hpow (pow_ne_zero 3 hr)
    convert h using 1 <;> field_simp [hr] <;> ring
  have hchain :=
    hquot.comp_hasFDerivAt x hroot
  have hrepr : c.radialCoefficient =
      (fun y : Vec3 => -(c.gravitationalParameter) / ‖e y‖ ^ 3) := by
    funext y
    change -(c.gravitationalParameter) / euclideanRadius y ^ 3 =
      -(c.gravitationalParameter) / ‖e y‖ ^ 3
    rw [euclideanRadius_eq_physical_norm,
      toPhysicalVec3_eq_continuousLinearEquiv]
  have hf :
      fderiv ℝ c.radialCoefficient x =
        (3 * c.gravitationalParameter / ‖e x‖ ^ 4) •
          ((1 / (2 * ‖e x‖)) • Q) := by
    rw [hrepr]
    simpa only [Function.comp_def] using hchain.fderiv
  rw [hf, euclideanRadius_eq_physical_norm]
  simp only [toPhysicalVec3_eq_continuousLinearEquiv]
  change (((3 * c.gravitationalParameter / ‖e x‖ ^ 4) •
      ((1 / (2 * ‖e x‖)) • Q)) h) =
    (3 * c.gravitationalParameter / ‖e x‖ ^ 5) *
      ⟪e x, e h⟫_ℝ
  simp only [Q, two_smul, ContinuousLinearMap.smul_apply,
    ContinuousLinearMap.comp_apply, ContinuousLinearMap.add_apply,
    innerSL_apply_apply, smul_eq_mul, ContinuousLinearEquiv.coe_coe]
  field_simp [hr] <;> ring

theorem NewtonianPointSource.accelerationField_fderiv_full
    (c : NewtonianPointSource) (x h : Vec3) (hx : x ≠ 0) :
    (fderiv ℝ c.accelerationField x) h =
      (-(c.gravitationalParameter) / euclideanRadius x ^ 3) • h +
        ((3 * c.gravitationalParameter / euclideanRadius x ^ 5) *
            ⟪toPhysicalVec3 x, toPhysicalVec3 h⟫_ℝ) • x := by
  rw [c.accelerationField_fderiv_product_of_ne_zero x hx]
  simp only [ContinuousLinearMap.add_apply, ContinuousLinearMap.smul_apply,
    ContinuousLinearMap.id_apply, ContinuousLinearMap.smulRight_apply]
  rw [c.radialCoefficient_fderiv_full x h hx]
  rfl

end NewtonianLipschitz
