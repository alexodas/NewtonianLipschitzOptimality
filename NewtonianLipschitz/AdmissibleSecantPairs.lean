module

public import NewtonianLipschitz.AdmissibleCriticalDirection

public section

/-!
# Distinct admissible point pairs from the sharp derivative direction

At the unit Cartesian critical separation, R034 constructs
an outward direction with derivative-action norm C3.
Because C3 is positive, this direction necessarily has
norm exactly one. Hence every positive step along its ray
gives a distinct pair of unit-clearance-admissible points
with Cartesian separation equal to the step size.

This supplies geometrically valid secant pairs; it does
not yet establish their difference-quotient limit.
-/

namespace NewtonianLipschitz

/-- The exact candidate maximum is strictly positive. -/
theorem candidateMaximum_pos : 0 < candidateMaximum := by
  have h0 : candidateCoefficient (0 : ℝ) ≤ candidateMaximum := by
    rw [candidateMaximum_eq]
    exact candidateCoefficient_le_at_criticalPoint (0 : ℝ)
      ⟨by norm_num, by norm_num⟩
  have hv : candidateCoefficient (0 : ℝ) = 2 := by
    rw [candidateCoefficient_eq]
    norm_num
  rw [hv] at h0
  linarith

/-- There is a unit Cartesian derivative-attaining direction
for which every positive outward perturbation is a distinct
admissible point, exactly the step length away from the
critical unit-clearance displacement. -/
theorem NewtonianPointSource.unitAxis_exists_safe_distinct_secant_pairs :
    ∃ h : Vec3, ‖h‖ = 1 ∧
      ‖(fderiv ℝ NewtonianPointSource.unitAxis.accelerationField
        (normalizedVector candidateCriticalPoint candidateCriticalPoint)) h‖ =
          candidateMaximum ∧
      ∀ s : ℝ, 0 < s →
        (1 : ℝ) ≤
          ‖normalizedVector candidateCriticalPoint candidateCriticalPoint +
            s • h‖ ∧
        ‖(normalizedVector candidateCriticalPoint candidateCriticalPoint +
            s • h) -
          normalizedVector candidateCriticalPoint candidateCriticalPoint‖ =
            s ∧
        normalizedVector candidateCriticalPoint candidateCriticalPoint +
          s • h ≠
            normalizedVector candidateCriticalPoint candidateCriticalPoint := by
  let x : Vec3 :=
    normalizedVector candidateCriticalPoint candidateCriticalPoint
  let c := NewtonianPointSource.unitAxis
  obtain ⟨h, hh, haction, hsafe⟩ :=
    NewtonianPointSource.unitAxis_exists_safe_sharp_outward_ray
  have hoper :
      ‖fderiv ℝ c.accelerationField x‖ = candidateMaximum :=
    NewtonianPointSource.unitAxis_fderiv_opNorm_eq_candidateMaximum
  have hmult :
      candidateMaximum ≤ candidateMaximum * ‖h‖ := by
    calc
      candidateMaximum =
          ‖(fderiv ℝ c.accelerationField x) h‖ := haction.symm
      _ ≤ ‖fderiv ℝ c.accelerationField x‖ * ‖h‖ :=
        (fderiv ℝ c.accelerationField x).le_opNorm h
      _ = candidateMaximum * ‖h‖ := by rw [hoper]
  have hnorm : ‖h‖ = (1 : ℝ) := by
    rcases lt_or_eq_of_le hh with hlt | heq
    · have hmul :=
        mul_lt_mul_of_pos_left hlt candidateMaximum_pos
      linarith
    · exact heq
  refine ⟨h, hnorm, haction, ?_⟩
  intro s hs
  have hdist : ‖(x + s • h) - x‖ = s := by
    rw [add_sub_cancel_left, norm_smul,
      Real.norm_eq_abs, abs_of_nonneg hs.le, hnorm, mul_one]
  have hdistinct : x + s • h ≠ x := by
    intro heq
    rw [heq, sub_self, norm_zero] at hdist
    linarith
  exact ⟨hsafe s hs.le, hdist, hdistinct⟩

/-!
## From admissible secants to optimal two-point coefficients

R036 passes from R035 to the actual *right-hand* limit of finite
differences. R037 uses that limit to rule out every smaller
coefficient in a universal bound on pairs outside the unit cube.
Neither statement assumes that arbitrary segments in the exterior
are safe, and neither proves the global upper bound.
-/

/-- R036: the actual finite-difference quotients along an admissible
outward unit ray converge to the sharp Newtonian coefficient. -/
theorem NewtonianPointSource.unitAxis_exists_safe_secant_quotient_limit :
    ∃ h : Vec3, ‖h‖ = 1 ∧
      (∀ s : ℝ, 0 < s →
        (1 : ℝ) ≤
          ‖normalizedVector candidateCriticalPoint candidateCriticalPoint +
            s • h‖ ∧
        ‖(normalizedVector candidateCriticalPoint candidateCriticalPoint +
            s • h) -
          normalizedVector candidateCriticalPoint candidateCriticalPoint‖ =
            s ∧
        normalizedVector candidateCriticalPoint candidateCriticalPoint +
          s • h ≠
            normalizedVector candidateCriticalPoint candidateCriticalPoint) ∧
      Filter.Tendsto
        (fun s : ℝ =>
          ‖s⁻¹ •
            (NewtonianPointSource.unitAxis.accelerationField
                (normalizedVector candidateCriticalPoint candidateCriticalPoint +
                  s • h) -
              NewtonianPointSource.unitAxis.accelerationField
                (normalizedVector candidateCriticalPoint candidateCriticalPoint))‖)
        (nhdsWithin 0 (Set.Ioi 0)) (nhds candidateMaximum) := by
  let c : NewtonianPointSource := NewtonianPointSource.unitAxis
  let x : Vec3 :=
    normalizedVector candidateCriticalPoint candidateCriticalPoint
  obtain ⟨h, hunit, haction, hsafe⟩ :=
    NewtonianPointSource.unitAxis_exists_safe_distinct_secant_pairs
  refine ⟨h, hunit, hsafe, ?_⟩
  have hnorm : ‖x‖ = (1 : ℝ) :=
    criticalDiagonal_cartesian_norm_eq_one
  have hx : x ≠ 0 := by
    intro hzero
    rw [hzero, norm_zero] at hnorm
    norm_num at hnorm
  have hf : HasFDerivAt c.accelerationField
      (fderiv ℝ c.accelerationField x) x :=
    (c.accelerationField_contDiffAt x hx).differentiableAt_one.hasFDerivAt
  have hline :=
    (hf.hasLineDerivAt h).tendsto_slope_zero_right
  simpa only [haction] using hline.norm

/-- R037: any coefficient valid for every pair of unit-cube-safe
displacements for the unit Newtonian source must be at least C3.
The global upper bound is *not* assumed to have been proved. -/
theorem candidateMaximum_le_of_universal_safe_secant_bound
    (K : ℝ)
    (hK : ∀ x y : Vec3,
      (1 : ℝ) ≤ ‖x‖ → (1 : ℝ) ≤ ‖y‖ →
        ‖NewtonianPointSource.unitAxis.accelerationField x -
          NewtonianPointSource.unitAxis.accelerationField y‖ ≤
            K * ‖x - y‖) :
    candidateMaximum ≤ K := by
  let x : Vec3 :=
    normalizedVector candidateCriticalPoint candidateCriticalPoint
  let c : NewtonianPointSource := NewtonianPointSource.unitAxis
  obtain ⟨h, _hunit, hsafe, hlimit⟩ :=
    NewtonianPointSource.unitAxis_exists_safe_secant_quotient_limit
  have hxclear : (1 : ℝ) ≤ ‖x‖ := by
    change (1 : ℝ) ≤
      ‖normalizedVector candidateCriticalPoint candidateCriticalPoint‖
    rw [criticalDiagonal_cartesian_norm_eq_one]
  have hbound : ∀ s : ℝ, 0 < s →
      ‖s⁻¹ • (c.accelerationField (x + s • h) -
        c.accelerationField x)‖ ≤ K := by
    intro s hs
    obtain ⟨hclear, hdist, _⟩ := hsafe s hs
    have hpair := hK (x + s • h) x hclear hxclear
    have hpositive : 0 ≤ s⁻¹ := inv_nonneg.mpr hs.le
    calc
      ‖s⁻¹ • (c.accelerationField (x + s • h) -
          c.accelerationField x)‖ =
          s⁻¹ * ‖c.accelerationField (x + s • h) -
            c.accelerationField x‖ := by
        rw [norm_smul, Real.norm_eq_abs, abs_of_nonneg hpositive]
      _ ≤ s⁻¹ * (K * ‖(x + s • h) - x‖) :=
        mul_le_mul_of_nonneg_left hpair hpositive
      _ = K := by
        rw [hdist]
        field_simp [ne_of_gt hs]
  have heventually :
      ∀ᶠ s : ℝ in nhdsWithin 0 (Set.Ioi 0),
        ‖s⁻¹ • (c.accelerationField (x + s • h) -
          c.accelerationField x)‖ ≤ K := by
    filter_upwards [self_mem_nhdsWithin] with s hs
    exact hbound s hs
  exact le_of_tendsto_of_tendsto hlimit tendsto_const_nhds heventually

/-- No strictly smaller constant can hold for all *admissible*
two-point finite differences, already for a single unit source. -/
theorem candidateMaximum_no_smaller_universal_safe_secant_bound
    (K : ℝ) (hK : K < candidateMaximum) :
    ¬ ∀ x y : Vec3,
      (1 : ℝ) ≤ ‖x‖ → (1 : ℝ) ≤ ‖y‖ →
        ‖NewtonianPointSource.unitAxis.accelerationField x -
          NewtonianPointSource.unitAxis.accelerationField y‖ ≤
            K * ‖x - y‖ := by
  intro hall
  have hmin :=
    candidateMaximum_le_of_universal_safe_secant_bound K hall
  linarith

end NewtonianLipschitz
