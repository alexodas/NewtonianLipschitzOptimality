module

public import Mathlib

public section

/-!
# Three-dimensional Cartesian coordinates and physical radius

The ambient Lean vector type carries the Cartesian/Pi supremum norm.
The exact Newtonian force uses the physical Euclidean radius instead.
These definitions do not contain any Lipschitz or optimality claim.
-/

namespace NewtonianLipschitz

/-- Three real Cartesian coordinates with Mathlib's Pi/supremum norm. -/
abbrev Vec3 := Fin 3 → ℝ

/-- Euclidean radius of a Cartesian displacement, not the Pi norm. -/
noncomputable def euclideanRadius (x : Vec3) : ℝ :=
  Real.sqrt (x 0 ^ 2 + x 1 ^ 2 + x 2 ^ 2)

/-- The chosen coordinate expression for the physical radius. -/
theorem euclideanRadius_eq_coordinates (x : Vec3) :
    euclideanRadius x = Real.sqrt (x 0 ^ 2 + x 1 ^ 2 + x 2 ^ 2) := by
  rfl

end NewtonianLipschitz
