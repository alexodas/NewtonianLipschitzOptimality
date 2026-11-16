module

public import NewtonianLipschitz.BaselineBounds
public import NewtonianLipschitz.Clearance

public section

/-!
# Convex-domain Lipschitz estimates from certified clearance

This module connects the explicit, conservative derivative bound
to a genuine Lipschitz estimate on convex collision-free domains.
The bound is not presented as sharp. A future optimization can
strengthen the coefficient while keeping the verified baseline intact.
-/

open scoped NNReal Topology InnerProductSpace

namespace NewtonianLipschitz

noncomputable def NewtonianPointSource.clearanceLipschitzCoefficient
    (d : ℝ) (M : ℝ≥0) (hd : 0 < d) : ℝ≥0 :=
  Real.toNNReal (((10 : ℕ) : ℝ) * (M : ℝ) / d ^ 3)

/-- Public coefficient equation, for use across opaque Lean module
boundaries. In particular, the bound is *computed* from d and M. -/
theorem NewtonianPointSource.clearanceLipschitzCoefficient_coe
    (d : ℝ) (M : ℝ≥0) (hd : 0 < d) :
    ((NewtonianPointSource.clearanceLipschitzCoefficient d M hd : ℝ≥0) : ℝ) =
      10 * (M : ℝ) / d ^ 3 := by
  change (Real.toNNReal (((10 : ℕ) : ℝ) * (M : ℝ) / d ^ 3) : ℝ) =
    10 * (M : ℝ) / d ^ 3
  simpa using
    (Real.coe_toNNReal
      (((10 : ℕ) : ℝ) * (M : ℝ) / d ^ 3) (by positivity))

/-- A positive Euclidean separation certificate rules out collision
for every position of a safe domain. -/
private theorem no_collision_of_clearance
    (positions : Set Vec3) (d : ℝ) (hd : 0 < d)
    (hclear : ∀ x ∈ positions, d ≤ euclideanRadius x) :
    ∀ x ∈ positions, x ≠ 0 := by
  intro x hx hzero
  have hpos : 0 < euclideanRadius x :=
    lt_of_lt_of_le hd (hclear x hx)
  have hzeroRadius : euclideanRadius x = 0 := by
    rw [hzero, euclideanRadius_eq_physical_norm]
    simp
  exact (ne_of_gt hpos) hzeroRadius

/-- Mean-value transfer: an *explicit derived* bound on the actual
inverse-cube field's Fréchet derivative yields a Lipschitz certificate
on any convex, uniformly noncolliding spatial domain. This avoids
assuming an independent unit-field Lipschitz certificate (R055). -/
theorem NewtonianPointSource.accelerationField_lipschitzOnWith_of_clearance
    (c : NewtonianPointSource) (positions : Set Vec3)
    (hconvex : Convex ℝ positions)
    (d : ℝ) (M : ℝ≥0) (hd : 0 < d)
    (hclear : ∀ x ∈ positions, d ≤ euclideanRadius x)
    (hM : c.gravitationalParameter ≤ (M : ℝ)) :
    LipschitzOnWith
      (NewtonianPointSource.clearanceLipschitzCoefficient d M hd)
      c.accelerationField positions := by
  have hnoncollision : ∀ x ∈ positions, x ≠ 0 :=
    no_collision_of_clearance positions d hd hclear
  have hdiff : ∀ x ∈ positions,
      DifferentiableAt ℝ c.accelerationField x := by
    intro x hx
    exact (c.accelerationField_contDiffAt x
      (hnoncollision x hx)).differentiableAt_one
  have hcoefficient_nonneg : 0 ≤ 10 * (M : ℝ) / d ^ 3 := by
    positivity
  have hbound : ∀ x ∈ positions,
      ‖fderiv ℝ c.accelerationField x‖ ≤
        10 * (M : ℝ) / d ^ 3 := by
    intro x hx
    apply ContinuousLinearMap.opNorm_le_bound _
      hcoefficient_nonneg
    intro h
    exact c.accelerationField_fderiv_norm_le_ten_of_clearance
      x h d (M : ℝ) (hnoncollision x hx) hd
      (hclear x hx) hM
  apply LipschitzOnWith.of_dist_le_mul
  intro x hx y hy
  have hmean :=
    hconvex.norm_image_sub_le_of_norm_fderiv_le
      hdiff hbound hx hy
  rw [NewtonianPointSource.clearanceLipschitzCoefficient_coe d M hd]
  simpa only [dist_eq_norm, norm_sub_rev] using hmean

/-- A finite-anchor noncollision margin yields an *explicit* unit
field Lipschitz constant on the whole anchor ball. This is precisely
the missing R055 certificate and is proved, rather than supplied. -/
theorem NewtonianPointSource.unitAxis_lipschitzOnWith_anchor_of_clearance
    (anchor : Vec3) (ρ d : ℝ) (hd : 0 < d)
    (hanchor : d + ρ ≤ dist anchor (0 : Vec3)) :
    LipschitzOnWith
      (NewtonianPointSource.clearanceLipschitzCoefficient
        d (1 : ℝ≥0) hd)
      NewtonianPointSource.unitAxis.accelerationField
      (Metric.ball anchor ρ) := by
  have hsafe : ∀ x ∈ Metric.ball anchor ρ,
      d ≤ euclideanRadius x := by
    intro x hx
    have hxball : dist x anchor < ρ := Metric.mem_ball.mp hx
    have htriangle :
        dist anchor (0 : Vec3) ≤ dist anchor x + dist x 0 :=
      dist_triangle _ _ _
    have hcart : d ≤ dist x (0 : Vec3) := by
      rw [dist_comm anchor x] at htriangle
      linarith
    exact euclideanRadius_ge_of_cartesian_distance x d hcart
  have hunitMass :
      NewtonianPointSource.unitAxis.gravitationalParameter ≤ (1 : ℝ) := by
    rw [NewtonianPointSource.unitAxis_gravitationalParameter_eq_one]
  exact NewtonianPointSource.accelerationField_lipschitzOnWith_of_clearance
    NewtonianPointSource.unitAxis (Metric.ball anchor ρ)
    (convex_ball _ _) d (1 : ℝ≥0) hd hsafe hunitMass

end NewtonianLipschitz
