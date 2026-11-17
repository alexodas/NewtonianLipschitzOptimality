module

public import NewtonianLipschitz.CubicCandidate

public section

/-!
# Scalar maximization of the exact candidate coefficient

The derivative is an explicit positive-denominator multiple of the
stationary cubic. The critical root was defined and enclosed in the
previous verified module. The one-variable maximum is separate from
the global Cartesian Jacobian operator-norm inequality.
-/

namespace NewtonianLipschitz

/-- Differentiation of the exact scalar candidate function. -/
theorem candidateCoefficient_hasDerivAt (x : ℝ) :
    HasDerivAt candidateCoefficient
      (6 * stationaryCubic x / (Real.sqrt (1 + 2 * x ^ 2)) ^ 7) x := by
  let r : ℝ := Real.sqrt (1 + 2 * x ^ 2)
  have hp : 0 < (1 : ℝ) + 2 * x ^ 2 := by positivity
  have hr : r ≠ 0 := by
    dsimp [r]
    exact ne_of_gt (Real.sqrt_pos.mpr hp)
  have hrsq : r ^ 2 = 1 + 2 * x ^ 2 := by
    dsimp [r]
    exact Real.sq_sqrt hp.le
  have hn :
      HasDerivAt (fun y : ℝ => 2 + 6 * y - 2 * y ^ 2)
        (6 - 4 * x) x := by
    convert
      (((hasDerivAt_id x).const_mul (6 : ℝ)).sub
        (((hasDerivAt_id x).pow 2).const_mul (2 : ℝ))).const_add
        (2 : ℝ) using 1 <;> ring
  have hb :
      HasDerivAt (fun y : ℝ => 1 + 2 * y ^ 2)
        (4 * x) x := by
    convert
      (((hasDerivAt_id x).pow 2).const_mul (2 : ℝ)).const_add
        (1 : ℝ) using 1 <;> ring
  have hs :
      HasDerivAt (fun y : ℝ => Real.sqrt (1 + 2 * y ^ 2))
        (4 * x / (2 * r)) x := by
    exact hb.sqrt (by positivity)
  have hd :
      HasDerivAt (fun y : ℝ =>
        (Real.sqrt (1 + 2 * y ^ 2)) ^ 5)
        (5 * r ^ 4 * (4 * x / (2 * r))) x := by
    convert hs.pow 5 using 1 <;> ring
  have hf :
      candidateCoefficient =
        (fun y : ℝ => (2 + 6 * y - 2 * y ^ 2) /
          (Real.sqrt (1 + 2 * y ^ 2)) ^ 5) := by
    funext y
    exact candidateCoefficient_eq y
  have hquot :
      HasDerivAt candidateCoefficient
        (((6 - 4 * x) * r ^ 5 -
          (2 + 6 * x - 2 * x ^ 2) *
            (5 * r ^ 4 * (4 * x / (2 * r)))) /
          (r ^ 5) ^ 2) x := by
    rw [hf]
    convert hn.div hd (pow_ne_zero 5 hr) using 1 <;> ring
  have hfrac :
      (((6 - 4 * x) * r ^ 5 -
        (2 + 6 * x - 2 * x ^ 2) *
          (5 * r ^ 4 * (4 * x / (2 * r)))) /
        (r ^ 5) ^ 2) =
      (((6 - 4 * x) * r ^ 2 -
        (2 + 6 * x - 2 * x ^ 2) * (10 * x)) / r ^ 7) := by
    field_simp [hr]
    ring
  have hpoly :
      (6 - 4 * x) * r ^ 2 -
        (2 + 6 * x - 2 * x ^ 2) * (10 * x) =
        6 * stationaryCubic x := by
    rw [hrsq, stationaryCubic_eq]
    ring
  rw [hfrac, hpoly] at hquot
  exact hquot

/-- The stationary cubic is positive to the left of the exact root. -/
theorem stationaryCubic_positive_before_root
    (x : ℝ) (hx0 : 0 ≤ x) (hxa : x < candidateCriticalPoint) :
    0 < stationaryCubic x := by
  obtain ⟨hal, har, hzero⟩ := candidateCriticalPoint_spec
  have ha : candidateCriticalPoint ∈ Set.Icc (0 : ℝ) 1 :=
    ⟨by linarith, by linarith⟩
  have hx : x ∈ Set.Icc (0 : ℝ) 1 :=
    ⟨hx0, by linarith⟩
  have h := stationaryCubic_strictAntiOn_unitInterval hx ha hxa
  rw [hzero] at h
  exact h

/-- The stationary cubic is negative to the right of the exact root. -/
theorem stationaryCubic_negative_after_root
    (x : ℝ) (hxa : candidateCriticalPoint < x) (hx1 : x ≤ 1) :
    stationaryCubic x < 0 := by
  obtain ⟨hal, har, hzero⟩ := candidateCriticalPoint_spec
  have ha : candidateCriticalPoint ∈ Set.Icc (0 : ℝ) 1 :=
    ⟨by linarith, by linarith⟩
  have hx : x ∈ Set.Icc (0 : ℝ) 1 :=
    ⟨by linarith, hx1⟩
  have h := stationaryCubic_strictAntiOn_unitInterval ha hx hxa
  rw [hzero] at h
  exact h

/-- The exact cubic root realizes the maximum of the candidate scalar
coefficient on the unit interval. This is not yet a 3D Jacobian bound. -/
theorem candidateCoefficient_le_at_criticalPoint
    (t : ℝ) (ht : t ∈ Set.Icc (0 : ℝ) 1) :
    candidateCoefficient t ≤
      candidateCoefficient candidateCriticalPoint := by
  have hmax :
      IsMaxOn candidateCoefficient (Set.Icc (0 : ℝ) 1)
        candidateCriticalPoint := by
    apply isMaxOn_Icc_of_deriv
    · exact (candidateCoefficient_hasDerivAt 0).continuousAt
    · exact (candidateCoefficient_hasDerivAt candidateCriticalPoint).continuousAt
    · exact (candidateCoefficient_hasDerivAt 1).continuousAt
    · intro x hx
      exact (candidateCoefficient_hasDerivAt x).differentiableAt.differentiableWithinAt
    · intro x hx
      exact (candidateCoefficient_hasDerivAt x).differentiableAt.differentiableWithinAt
    · intro x hx
      rw [(candidateCoefficient_hasDerivAt x).deriv]
      have hp : 0 < stationaryCubic x :=
        stationaryCubic_positive_before_root x (le_of_lt hx.1) hx.2
      exact div_nonneg
        (mul_nonneg (by norm_num : (0 : ℝ) ≤ 6) hp.le)
        (pow_nonneg (Real.sqrt_nonneg _) _)
    · intro x hx
      rw [(candidateCoefficient_hasDerivAt x).deriv]
      have hp : stationaryCubic x < 0 :=
        stationaryCubic_negative_after_root x hx.1 (le_of_lt hx.2)
      exact div_nonpos_of_nonpos_of_nonneg
        (mul_nonpos_of_nonneg_of_nonpos
          (by norm_num : (0 : ℝ) ≤ 6) hp.le)
        (pow_nonneg (Real.sqrt_nonneg _) _)
  exact hmax ht

/-- Exact (non-decimal) value of the scalar candidate maximum. -/
noncomputable def candidateMaximum : ℝ :=
  candidateCoefficient candidateCriticalPoint

end NewtonianLipschitz
