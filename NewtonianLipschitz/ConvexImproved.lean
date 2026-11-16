module

public import NewtonianLipschitz.ImprovedBounds
public import NewtonianLipschitz.Clearance

public section

/-!
# Improved convex-domain certificate with coefficient 7

This theorem uses the exact Newtonian field and integrates a verified
pointwise derivative bound along segments inside a *convex* region.
It is not a claim on arbitrary nonconvex pairs, and is not sharp.
-/

open scoped NNReal Topology InnerProductSpace

namespace NewtonianLipschitz

/-- Explicit nonoptimal improvement of the previous NNReal coefficient. -/
noncomputable def NewtonianPointSource.sevenLipschitzCoefficient
    (d : ℝ) (M : ℝ≥0) (hd : 0 < d) : ℝ≥0 :=
  Real.toNNReal (((7 : ℕ) : ℝ) * (M : ℝ) / d ^ 3)

theorem NewtonianPointSource.sevenLipschitzCoefficient_coe
    (d : ℝ) (M : ℝ≥0) (hd : 0 < d) :
    ((NewtonianPointSource.sevenLipschitzCoefficient d M hd : ℝ≥0) : ℝ) =
      7 * (M : ℝ) / d ^ 3 := by
  change (Real.toNNReal (((7 : ℕ) : ℝ) * (M : ℝ) / d ^ 3) : ℝ) =
    7 * (M : ℝ) / d ^ 3
  simpa using
    (Real.coe_toNNReal
      (((7 : ℕ) : ℝ) * (M : ℝ) / d ^ 3) (by positivity))

/-- Fully derived, nonoptimal convex-domain Lipschitz certificate
for the exact Newtonian force. -/
theorem NewtonianPointSource.accelerationField_lipschitzOnWith_seven
    (c : NewtonianPointSource) (positions : Set Vec3)
    (hconvex : Convex ℝ positions)
    (d : ℝ) (M : ℝ≥0) (hd : 0 < d)
    (hclear : ∀ x ∈ positions, d ≤ euclideanRadius x)
    (hM : c.gravitationalParameter ≤ (M : ℝ)) :
    LipschitzOnWith
      (NewtonianPointSource.sevenLipschitzCoefficient d M hd)
      c.accelerationField positions := by
  have hnoncollision : ∀ x ∈ positions, x ≠ 0 := by
    intro x hx hzero
    have hpos : 0 < euclideanRadius x :=
      lt_of_lt_of_le hd (hclear x hx)
    have hzeroRadius : euclideanRadius x = 0 := by
      rw [hzero, euclideanRadius_eq_physical_norm]
      simp
    exact (ne_of_gt hpos) hzeroRadius
  have hdiff : ∀ x ∈ positions,
      DifferentiableAt ℝ c.accelerationField x := by
    intro x hx
    exact (c.accelerationField_contDiffAt x
      (hnoncollision x hx)).differentiableAt_one
  have hnonneg : 0 ≤ 7 * (M : ℝ) / d ^ 3 := by positivity
  have hbound : ∀ x ∈ positions,
      ‖fderiv ℝ c.accelerationField x‖ ≤
        7 * (M : ℝ) / d ^ 3 := by
    intro x hx
    apply ContinuousLinearMap.opNorm_le_bound _ hnonneg
    intro h
    exact c.accelerationField_fderiv_norm_le_seven_of_clearance
      x h d (M : ℝ) (hnoncollision x hx) hd (hclear x hx) hM
  apply LipschitzOnWith.of_dist_le_mul
  intro x hx y hy
  have hmean :=
    hconvex.norm_image_sub_le_of_norm_fderiv_le
      hdiff hbound hx hy
  rw [NewtonianPointSource.sevenLipschitzCoefficient_coe d M hd]
  simpa only [dist_eq_norm, norm_sub_rev] using hmean

/-- The improved explicit bound applies to each safe anchor ball. -/
theorem NewtonianPointSource.unitAxis_lipschitzOnWith_anchor_seven
    (anchor : Vec3) (ρ d : ℝ) (hd : 0 < d)
    (hanchor : d + ρ ≤ dist anchor (0 : Vec3)) :
    LipschitzOnWith
      (NewtonianPointSource.sevenLipschitzCoefficient
        d (1 : ℝ≥0) hd)
      NewtonianPointSource.unitAxis.accelerationField
      (Metric.ball anchor ρ) := by
  have hsafe : ∀ x ∈ Metric.ball anchor ρ,
      d ≤ euclideanRadius x :=
    clearance_on_anchor_ball anchor ρ d hd hanchor
  have hmass :
      NewtonianPointSource.unitAxis.gravitationalParameter ≤ (1 : ℝ) := by
    rw [NewtonianPointSource.unitAxis_gravitationalParameter_eq_one]
  exact NewtonianPointSource.accelerationField_lipschitzOnWith_seven
    NewtonianPointSource.unitAxis (Metric.ball anchor ρ)
    (convex_ball _ _) d (1 : ℝ≥0) hd hsafe hmass

end NewtonianLipschitz
