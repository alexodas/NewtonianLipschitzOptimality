module

public import NewtonianLipschitz.Basic

public section

/-!
# Exact three-dimensional Newtonian point-source field

The scalar parameter mu represents a gravitational parameter (G times
mass). The field is intended on the noncollision domain x != 0.
No sharp derivative or Lipschitz bound is asserted by this module.
-/

namespace NewtonianLipschitz

/-- Exact inverse-cube Newtonian acceleration at the source displacement. -/
noncomputable def newtonianAcceleration (μ : ℝ) (x : Vec3) : Vec3 :=
  (-(μ) / euclideanRadius x ^ 3) • x


/-! ## Structured point sources and exact relative acceleration -/

structure NewtonianPointSource where
  gravitationalParameter : ℝ
  gravitationalParameter_nonneg : 0 ≤ gravitationalParameter
  displacement : Vec3
  displacement_ne_zero : displacement ≠ 0

/-- Exact inverse-cube Newtonian acceleration at a Cartesian displacement
from the point source. It uses the physical Euclidean radius, not
the Lean Cartesian Pi-space norm. Collision is excluded physically. -/
noncomputable def NewtonianPointSource.accelerationField
    (c : NewtonianPointSource) (x : Vec3) : Vec3 :=
  (-(c.gravitationalParameter) / euclideanRadius x ^ 3) • x

/-- Exact nonlinear differential point-source acceleration between
two positions with relative displacement q. Meaningful only when
both actual source separations are nonzero. This nonlinear
difference is NOT claimed to equal its linearized approximation. -/
noncomputable def NewtonianPointSource.exactDifferentialAcceleration
    (c : NewtonianPointSource) (q : Vec3) : Vec3 :=
  c.accelerationField (c.displacement + q) -
    c.accelerationField c.displacement

/-- Public unfolding identity for the exact nonlinear two-position
differential force. Later modules can use this equality without
unfolding the imported definition. -/
theorem NewtonianPointSource.exactDifferentialAcceleration_eq_sub
    (c : NewtonianPointSource) (q : Vec3) :
    c.exactDifferentialAcceleration q =
      c.accelerationField (c.displacement + q) -
        c.accelerationField c.displacement := by
  rfl

/-- Every exact differential force, including this Newtonian one,
vanishes at coincident positions. This is an exact identity, not
a linearization claim. -/
theorem NewtonianPointSource.exactDifferentialAcceleration_zero
    (c : NewtonianPointSource) :
    c.exactDifferentialAcceleration 0 = 0 := by
  simp only [NewtonianPointSource.exactDifferentialAcceleration,
    add_zero, sub_self]

def NewtonianPointSource.unitAxis : NewtonianPointSource where
  gravitationalParameter := 1
  gravitationalParameter_nonneg := by norm_num
  displacement := ![(1 : ℝ), 0, 0]
  displacement_ne_zero := by
    intro h
    have h0 := congrArg (fun q : Vec3 => q 0) h
    norm_num at h0

/-- Expose the exact unit gravitational parameter across Lean module
boundaries, where the original illustrative source definition is opaque.
This can instantiate explicit quantitative bounds without assuming
an external unit-field Lipschitz coefficient. -/
theorem NewtonianPointSource.unitAxis_gravitationalParameter_eq_one :
    NewtonianPointSource.unitAxis.gravitationalParameter = 1 := by
  rfl

end NewtonianLipschitz
