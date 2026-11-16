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

end NewtonianLipschitz
