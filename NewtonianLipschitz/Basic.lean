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


/-! ## Explicit Euclidean representation and exact norm bridge -/

/-- A genuine L² / Euclidean physical 3-vector. -/
abbrev PhysicalVec3 := EuclideanSpace ℝ (Fin 3)

/-- Interpret Cartesian coordinates as a Euclidean-normed physical vector. -/
def toPhysicalVec3 (q : Vec3) : PhysicalVec3 := WithLp.toLp ((2 : ℕ) : ENNReal) q

/-- The Cartesian-to-physical Euclidean map preserves the zero vector.
This also makes the property available to downstream modules, where
the body of `toPhysicalVec3` is deliberately opaque. -/
@[simp] theorem toPhysicalVec3_zero : toPhysicalVec3 (0 : Vec3) = 0 := by
  rfl

/-- Cartesian coordinates are unchanged componentwise by the
conversion to the Euclidean-normed physical vector representation. -/
@[simp] theorem toPhysicalVec3_apply (q : Vec3) (i : Fin 3) :
    toPhysicalVec3 q i = q i := by
  rfl

/-- The physical coordinate conversion is the canonical continuous
linear equivalence, enabling regularity transfer without unfolding. -/
theorem toPhysicalVec3_eq_continuousLinearEquiv (q : Vec3) :
    toPhysicalVec3 q =
      ((PiLp.continuousLinearEquiv 2 ℝ (fun _ : Fin 3 => ℝ)).symm) q := by
  rfl

/-- The inverse conversion returns the original Cartesian vector. -/
@[simp] theorem ofLp_toPhysicalVec3 (q : Vec3) :
    WithLp.ofLp (toPhysicalVec3 q) = q := by
  rfl

theorem euclideanRadius_eq_physical_norm (q : Vec3) :
    euclideanRadius q = ‖toPhysicalVec3 q‖ := by
  rw [euclideanRadius_eq_coordinates, EuclideanSpace.norm_eq]
  simp [Fin.sum_univ_three, toPhysicalVec3_apply, Real.norm_eq_abs, sq_abs]

end NewtonianLipschitz
