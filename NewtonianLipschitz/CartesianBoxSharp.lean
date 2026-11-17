module

public import NewtonianLipschitz.ConvexSharp

public section

/-!
# Certified sharp Cartesian-box sensitivity of point-source gravity

In the Cartesian supremum norm, an open metric ball is
an axis-aligned open cube. If the center of this box has
enough clearance for its radius, every point in the box
has positive noncollision clearance from the point source.

The already verified convex finite-difference estimate
then bounds any two physical accelerations inside the box.
This is useful for certified spatial enclosures, but
does not treat points in different boxes or arbitrary
pairs outside a forbidden source-centered safety cube.
-/

namespace NewtonianLipschitz

/-- A Cartesian open box with an explicit center-margin
certificate is uniformly separated from the point source. -/
theorem cartesianBox_clearance_of_center_margin
    (anchor : Vec3) (ρ d : ℝ) (hd : 0 < d)
    (hmargin : d + ρ ≤ dist anchor (0 : Vec3)) :
    ∀ z ∈ Metric.ball anchor ρ, d ≤ ‖z‖ := by
  intro z hz
  have hzball : dist z anchor < ρ := Metric.mem_ball.mp hz
  have htriangle :
      dist anchor (0 : Vec3) ≤
        dist anchor z + dist z (0 : Vec3) :=
    dist_triangle _ _ _
  rw [dist_comm anchor z] at htriangle
  have hclear : d ≤ dist z (0 : Vec3) := by
    linarith
  simpa only [dist_zero_right] using hclear

/-- The optimal candidate C3 bounds every pair of Newtonian
accelerations inside an explicitly certified Cartesian box. -/
theorem NewtonianPointSource.accelerationField_norm_sub_le_candidateMaximum_box
    (c : NewtonianPointSource)
    (anchor : Vec3) (ρ d : ℝ)
    (hd : 0 < d) (hmargin : d + ρ ≤ dist anchor (0 : Vec3))
    (x y : Vec3)
    (hx : x ∈ Metric.ball anchor ρ)
    (hy : y ∈ Metric.ball anchor ρ) :
    ‖c.accelerationField x - c.accelerationField y‖ ≤
      ((1 / d ^ 3) * (c.gravitationalParameter * candidateMaximum)) *
        ‖x - y‖ := by
  exact c.accelerationField_norm_sub_le_candidateMaximum_convex
    (Metric.ball anchor ρ) (convex_ball _ _) d hd
    (cartesianBox_clearance_of_center_margin anchor ρ d hd hmargin)
    x y hx hy

end NewtonianLipschitz
