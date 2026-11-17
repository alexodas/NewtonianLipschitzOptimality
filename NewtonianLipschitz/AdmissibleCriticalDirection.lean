module

public import NewtonianLipschitz.DerivativeAttainingDirection

public section

/-!
# Admissible outward sharp direction for Cartesian cube clearance

At the critical displacement (1,t_star,t_star) the true
point-source Frechet derivative admits a direction
of norm at most one attaining candidateMaximum (R033).
Because negating the direction preserves its derivative
action norm, we can orient the first coordinate outward.

Every nonnegative displacement along this oriented ray
has Cartesian norm at least one. Both the original point
and every such perturbed point are therefore outside the
open unit safety cube around the source. This does not
yet establish the limiting finite-difference ratio.
-/

namespace NewtonianLipschitz

/-- One can orient an attaining derivative direction
so that its first Cartesian coordinate is nonnegative. -/
theorem NewtonianPointSource.unitAxis_exists_outward_attaining_direction :
    ∃ h : Vec3, ‖h‖ ≤ 1 ∧ 0 ≤ h 0 ∧
      ‖(fderiv ℝ NewtonianPointSource.unitAxis.accelerationField
        (normalizedVector candidateCriticalPoint candidateCriticalPoint)) h‖ =
          candidateMaximum := by
  obtain ⟨h, hnorm, haction⟩ :=
    NewtonianPointSource.unitAxis_fderiv_exists_attaining_direction
  by_cases hfirst : 0 ≤ h 0
  · exact ⟨h, hnorm, hfirst, haction⟩
  · have hneg : 0 ≤ -(h 0) :=
      neg_nonneg.mpr (le_of_lt (lt_of_not_ge hfirst))
    refine ⟨-h, ?_, ?_, ?_⟩
    · simpa only [norm_neg] using hnorm
    · simpa only [Pi.neg_apply] using hneg
    · simpa only [map_neg, norm_neg] using haction

/-- The critical diagonal remains outside the open
Cartesian safety cube under every nonnegative outward
perturbation of the first coordinate. -/
theorem criticalDiagonal_outward_ray_cartesian_clearance
    (h : Vec3) (hfirst : 0 ≤ h 0)
    (s : ℝ) (hs : 0 ≤ s) :
    (1 : ℝ) ≤
      ‖normalizedVector candidateCriticalPoint candidateCriticalPoint +
        s • h‖ := by
  let z := normalizedVector candidateCriticalPoint candidateCriticalPoint +
    s • h
  have hnonneg : 0 ≤ s * h 0 := mul_nonneg hs hfirst
  have hcoord : (1 : ℝ) ≤ z 0 := by
    change (1 : ℝ) ≤
      (normalizedVector candidateCriticalPoint candidateCriticalPoint) 0 +
        s * h 0
    rw [normalizedVector_zero]
    linarith
  have habs : z 0 ≤ |z 0| := le_abs_self _
  have hle : |z 0| ≤ ‖z‖ := by
    simpa only [Real.norm_eq_abs] using (norm_le_pi_norm z 0)
  exact hcoord.trans (habs.trans hle)

/-- A derivative-attaining direction has an orientation
whose entire forward ray satisfies Cartesian unit clearance. -/
theorem NewtonianPointSource.unitAxis_exists_safe_sharp_outward_ray :
    ∃ h : Vec3, ‖h‖ ≤ 1 ∧
      ‖(fderiv ℝ NewtonianPointSource.unitAxis.accelerationField
        (normalizedVector candidateCriticalPoint candidateCriticalPoint)) h‖ =
          candidateMaximum ∧
      ∀ s : ℝ, 0 ≤ s →
        (1 : ℝ) ≤
          ‖normalizedVector candidateCriticalPoint candidateCriticalPoint +
            s • h‖ := by
  obtain ⟨h, hnorm, hfirst, haction⟩ :=
    NewtonianPointSource.unitAxis_exists_outward_attaining_direction
  refine ⟨h, hnorm, haction, ?_⟩
  intro s hs
  exact criticalDiagonal_outward_ray_cartesian_clearance
    h hfirst s hs

end NewtonianLipschitz
