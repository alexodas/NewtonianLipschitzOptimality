module

public import NewtonianLipschitz.Norms

public section

/-!
# Supremum-norm geometric clearance

An anchor sufficiently far from the origin provides a lower
noncollision distance throughout a Cartesian supremum-norm ball.
The anchor margin and the enclosure radius are explicit assumptions.
-/

namespace NewtonianLipschitz

/-- Clearance at a displaced point from a nominal geometric anchor. -/
theorem clearance_of_anchor
    (anchor center x : Vec3) (ε ρ d : ℝ)
    (hd : 0 < d)
    (hx : dist x center < ρ)
    (hcenter : dist center anchor ≤ ε)
    (hanchor : d + ε + ρ ≤ dist anchor (0 : Vec3)) :
    d ≤ dist x (0 : Vec3) ∧ x ≠ 0 := by
  have hdist : dist x anchor < ρ + ε := by
    calc
      dist x anchor ≤ dist x center + dist center anchor := dist_triangle _ _ _
      _ < ρ + ε := add_lt_add_of_lt_of_le hx hcenter
  have htriangle :
      dist anchor (0 : Vec3) ≤
        dist anchor x + dist x (0 : Vec3) := dist_triangle _ _ _
  have hclear : d ≤ dist x (0 : Vec3) := by
    rw [dist_comm anchor x] at htriangle
    linarith
  refine ⟨hclear, ?_⟩
  intro heq
  have : d ≤ 0 := by simpa [heq] using hclear
  linarith

/-- Clearance from an anchor's radius extends to a whole ball. -/
theorem clearance_on_anchor_ball
    (anchor : Vec3) (ρ d : ℝ)
    (hd : 0 < d) (hanchor : d + ρ ≤ dist anchor (0 : Vec3)) :
    ∀ x ∈ Metric.ball anchor ρ, d ≤ euclideanRadius x := by
  intro x hx
  have hx' : dist x anchor < ρ := Metric.mem_ball.mp hx
  have hxclear :=
    clearance_of_anchor anchor anchor x 0 ρ d hd hx' (by simp) (by simpa using hanchor)
  exact euclideanRadius_ge_of_cartesian_distance x d hxclear.1

end NewtonianLipschitz
