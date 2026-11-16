module

public import NewtonianLipschitz.Field

public section

/-!
# Smoothness of the exact Newtonian point-source field

Established regularity away from source collision, transported from
physical Euclidean coordinates to Cartesian Pi-norm coordinates.
-/

open scoped NNReal Topology InnerProductSpace

namespace NewtonianLipschitz

noncomputable def physicalNewtonianAcceleration
    (μ : ℝ) (q : PhysicalVec3) : PhysicalVec3 :=
  (-(μ) / ‖q‖ ^ 3) • q

/-- Public scalar-multiple form of physical Newtonian acceleration for
linking Euclidean regularity to the original Cartesian dynamics. -/
theorem physicalNewtonianAcceleration_eq_smul (μ : ℝ) (q : PhysicalVec3) :
    physicalNewtonianAcceleration μ q = (-(μ) / ‖q‖ ^ 3) • q := by
  rfl

/-- The physical Newtonian central field is continuously differentiable
at every nonzero separation. In contrast, no smoothness at the
collision point is asserted. -/
theorem physicalNewtonianAcceleration_contDiffAt
    (μ : ℝ) (q : PhysicalVec3) (hq : q ≠ 0) :
    ContDiffAt ℝ 1 (physicalNewtonianAcceleration μ) q := by
  have hnorm : ContDiffAt ℝ 1 (fun x : PhysicalVec3 => ‖x‖) q :=
    contDiffAt_norm ℝ hq
  have hpow : ContDiffAt ℝ 1
      (fun x : PhysicalVec3 => ‖x‖ ^ 3) q := hnorm.pow 3
  have hnonzero : ‖q‖ ^ 3 ≠ 0 := by
    exact pow_ne_zero _ (norm_ne_zero_iff.mpr hq)
  have hscalar : ContDiffAt ℝ 1
      (fun x : PhysicalVec3 => (-(μ)) / (‖x‖ ^ 3)) q :=
    contDiffAt_const.div hpow hnonzero
  have hid : ContDiffAt ℝ 1 (fun x : PhysicalVec3 => x) q :=
    contDiffAt_id
  change ContDiffAt ℝ 1
    (fun x : PhysicalVec3 => (-(μ) / ‖x‖ ^ 3) • x) q
  exact hscalar.fun_smul hid

theorem NewtonianPointSource.accelerationField_eq_physical
    (c : NewtonianPointSource) (x : Vec3) :
    c.accelerationField x =
      WithLp.ofLp
        (physicalNewtonianAcceleration c.gravitationalParameter
          (toPhysicalVec3 x)) := by
  rw [NewtonianPointSource.accelerationField,
    physicalNewtonianAcceleration_eq_smul]
  rw [← euclideanRadius_eq_physical_norm]
  rw [WithLp.ofLp_smul, ofLp_toPhysicalVec3]

/-- The exact source field, not merely its candidate tidal tensor,
is C¹ at every nonzero source separation, by transporting R019's
Euclidean regularity to the actual Cartesian source field. -/
theorem NewtonianPointSource.accelerationField_contDiffAt
    (c : NewtonianPointSource) (x : Vec3) (hx : x ≠ 0) :
    ContDiffAt ℝ 1 c.accelerationField x := by
  let e : Vec3 ≃L[ℝ] PhysicalVec3 :=
    (PiLp.continuousLinearEquiv 2 ℝ (fun _ : Fin 3 => ℝ)).symm
  have hn : e x ≠ 0 := by
    intro hzero
    apply hx
    apply e.injective
    simpa only [map_zero] using hzero
  have hphys : ContDiffAt ℝ 1
      (physicalNewtonianAcceleration c.gravitationalParameter) (e x) :=
    physicalNewtonianAcceleration_contDiffAt
      c.gravitationalParameter (e x) hn
  have hcomp : ContDiffAt ℝ 1
      (fun y : Vec3 =>
        e.symm (physicalNewtonianAcceleration
          c.gravitationalParameter (e y))) x :=
    (e.symm.contDiff.contDiffAt).comp x
      (hphys.comp x e.contDiff.contDiffAt)
  have hfield : c.accelerationField =
      (fun y : Vec3 =>
        e.symm (physicalNewtonianAcceleration
          c.gravitationalParameter (e y))) := by
    funext y
    rw [c.accelerationField_eq_physical y,
      toPhysicalVec3_eq_continuousLinearEquiv]
    rfl
  rw [hfield]
  exact hcomp

end NewtonianLipschitz
