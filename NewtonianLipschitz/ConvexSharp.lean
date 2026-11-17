module

public import NewtonianLipschitz.JacobianOperatorWitness
public import NewtonianLipschitz.ConvexBaseline

public section

/-!
# Candidate finite-difference bound on convex Cartesian-safe domains

The verified Frechet operator-norm bound can be integrated
along any segment contained in a convex domain with uniform
Cartesian clearance from the source. The mean-value estimate
is a bound on actual differences of Newtonian acceleration,
not only on the derivative.

The complement of a source-centered open cube is not convex.
No bound for arbitrary pairs in that exterior follows from
this result without a separate geometric argument.
-/

namespace NewtonianLipschitz

/-- The actual Newtonian acceleration field obeys the exact
candidate coefficient on every convex set with positive
Cartesian clearance from the source. The conclusion bounds
the finite difference between any two points of that set. -/
theorem NewtonianPointSource.accelerationField_norm_sub_le_candidateMaximum_convex
    (c : NewtonianPointSource)
    (positions : Set Vec3) (hconvex : Convex ℝ positions)
    (d : ℝ) (hd : 0 < d)
    (hclear : ∀ z ∈ positions, d ≤ ‖z‖)
    (x y : Vec3) (hx : x ∈ positions) (hy : y ∈ positions) :
    ‖c.accelerationField x - c.accelerationField y‖ ≤
      ((1 / d ^ 3) * (c.gravitationalParameter * candidateMaximum)) *
        ‖x - y‖ := by
  have hnoncollision : ∀ z ∈ positions, z ≠ 0 := by
    intro z hz
    have hpos : 0 < ‖z‖ := lt_of_lt_of_le hd (hclear z hz)
    exact norm_pos_iff.mp hpos
  have hdiff : ∀ z ∈ positions,
      DifferentiableAt ℝ c.accelerationField z := by
    intro z hz
    exact (c.accelerationField_contDiffAt z
      (hnoncollision z hz)).differentiableAt_one
  have hbound : ∀ z ∈ positions,
      ‖fderiv ℝ c.accelerationField z‖ ≤
        (1 / d ^ 3) *
          (c.gravitationalParameter * candidateMaximum) := by
    intro z hz
    exact c.accelerationField_fderiv_opNorm_le_clearance
      z d hd (hclear z hz)
  have hmean :=
    hconvex.norm_image_sub_le_of_norm_fderiv_le
      hdiff hbound hx hy
  simpa only [dist_eq_norm, norm_sub_rev] using hmean

end NewtonianLipschitz
