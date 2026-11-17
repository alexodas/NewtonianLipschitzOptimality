module

public import Mathlib

public section

/-!
# Candidate stationary polynomial and coefficient function

These are exact definitions for a research problem; no assertion of
critical-point uniqueness, maximality, or sharp Lipschitz regularity
has yet been proved.
-/

namespace NewtonianLipschitz

/-- Cubic equation associated with the candidate stationary point. -/
def stationaryCubic (y : ℝ) : ℝ :=
  2 * y ^ 3 - 8 * y ^ 2 - 4 * y + 1

/-- Exported polynomial formula for downstream proofs. -/
theorem stationaryCubic_eq (t : ℝ) :
    stationaryCubic t = 2 * t ^ 3 - 8 * t ^ 2 - 4 * t + 1 := by
  rfl

/-- Dimensionless candidate coefficient as an exact real expression. -/
noncomputable def candidateCoefficient (y : ℝ) : ℝ :=
  (2 + 6 * y - 2 * y ^ 2) / (Real.sqrt (1 + 2 * y ^ 2)) ^ 5

/-- Exported exact coefficient formula for downstream proofs. -/
theorem candidateCoefficient_eq (t : ℝ) :
    candidateCoefficient t =
      (2 + 6 * t - 2 * t ^ 2) /
        (Real.sqrt (1 + 2 * t ^ 2)) ^ 5 := by
  rfl

/-! ## Exactly checked polynomial facts for the proposed critical point -/

/-- The stationary polynomial begins positive on the unit interval. -/
theorem stationaryCubic_at_zero : stationaryCubic 0 = 1 := by
  norm_num [stationaryCubic]

/-- The stationary polynomial ends negative on the unit interval. -/
theorem stationaryCubic_at_one : stationaryCubic 1 = -9 := by
  norm_num [stationaryCubic]

/-- An exact positive sign to the left of the numerical candidate. -/
theorem stationaryCubic_pos_at_nine_fiftieths :
    0 < stationaryCubic (9 / 50 : ℝ) := by
  norm_num [stationaryCubic]

/-- An exact negative sign to the right of the numerical candidate. -/
theorem stationaryCubic_neg_at_one_fifth :
    stationaryCubic (1 / 5 : ℝ) < 0 := by
  norm_num [stationaryCubic]

/-- The candidate stationary polynomial is strictly decreasing on [0,1]. -/
theorem stationaryCubic_strictAntiOn_unitInterval :
    StrictAntiOn stationaryCubic (Set.Icc (0 : ℝ) 1) := by
  intro x hx y hy hxy
  have hx0 : 0 ≤ x := hx.1
  have hx1 : x ≤ 1 := hx.2
  have hy0 : 0 ≤ y := hy.1
  have hy1 : y ≤ 1 := hy.2
  have hxx : 0 ≤ x * (1 - x) :=
    mul_nonneg hx0 (by linarith)
  have hyy : 0 ≤ y * (1 - y) :=
    mul_nonneg hy0 (by linarith)
  have hxy' : 0 ≤ x * (1 - y) :=
    mul_nonneg hx0 (by linarith)
  have hfactor :
      0 < 4 + 8 * (x + y) -
        2 * (x ^ 2 + x * y + y ^ 2) := by
    nlinarith [hxx, hyy, hxy']
  have hidentity :
      stationaryCubic x - stationaryCubic y =
        (y - x) *
          (4 + 8 * (x + y) -
            2 * (x ^ 2 + x * y + y ^ 2)) := by
    unfold stationaryCubic
    ring
  have hpositive : 0 < stationaryCubic x - stationaryCubic y := by
    rw [hidentity]
    exact mul_pos (sub_pos.mpr hxy) hfactor
  exact sub_pos.mp hpositive

/-- There is at most one zero of the polynomial in [0,1].
Existence of a zero is a separate intermediate-value obligation. -/
theorem stationaryCubic_root_unique_on_unitInterval
    (x y : ℝ)
    (hx : x ∈ Set.Icc (0 : ℝ) 1)
    (hy : y ∈ Set.Icc (0 : ℝ) 1)
    (hpx : stationaryCubic x = 0)
    (hpy : stationaryCubic y = 0) : x = y := by
  rcases lt_trichotomy x y with hlt | heq | hgt
  · have h := stationaryCubic_strictAntiOn_unitInterval hx hy hlt
    rw [hpx, hpy] at h
    exact (lt_irrefl (0 : ℝ) h).elim
  · exact heq
  · have h := stationaryCubic_strictAntiOn_unitInterval hy hx hgt
    rw [hpx, hpy] at h
    exact (lt_irrefl (0 : ℝ) h).elim

/-!
## Exact root of the stationary cubic

The rational sign-changing interval and the intermediate value
theorem produce a root. The existing strict-antitonicity theorem
makes it unique. This does not yet prove scalar maximization.
-/

/-- The stationary cubic has a root in the exact rational bracket. -/
theorem stationaryCubic_exists_root_bracket :
    ∃ t : ℝ, (9 / 50 : ℝ) ≤ t ∧ t ≤ 1 / 5 ∧
      stationaryCubic t = 0 := by
  have hc : Continuous stationaryCubic := by
    unfold stationaryCubic
    fun_prop
  have hz :
      (0 : ℝ) ∈ Set.Icc
        (stationaryCubic (1 / 5 : ℝ))
        (stationaryCubic (9 / 50 : ℝ)) :=
    ⟨le_of_lt stationaryCubic_neg_at_one_fifth,
      le_of_lt stationaryCubic_pos_at_nine_fiftieths⟩
  obtain ⟨t, ht, hpt⟩ :=
    (intermediate_value_Icc'
      (by norm_num : (9 / 50 : ℝ) ≤ 1 / 5)
      hc.continuousOn) hz
  exact ⟨t, ht.1, ht.2, hpt⟩

/-- Uniqueness of the root in the exact rational bracket. -/
theorem stationaryCubic_existsUnique_root_bracket :
    ∃! t : ℝ, (9 / 50 : ℝ) ≤ t ∧ t ≤ 1 / 5 ∧
      stationaryCubic t = 0 := by
  obtain ⟨t, htl, htr, hpt⟩ := stationaryCubic_exists_root_bracket
  refine ⟨t, ⟨htl, htr, hpt⟩, ?_⟩
  intro y hy
  exact stationaryCubic_root_unique_on_unitInterval y t
    ⟨by linarith [hy.1], by linarith [hy.2.1]⟩
    ⟨by linarith, by linarith⟩ hy.2.2 hpt

/-- Exact critical-point parameter; no numerical solver is used. -/
noncomputable def candidateCriticalPoint : ℝ :=
  Classical.choose stationaryCubic_exists_root_bracket

/-- Exact enclosure and stationary polynomial equation. -/
theorem candidateCriticalPoint_spec :
    (9 / 50 : ℝ) ≤ candidateCriticalPoint ∧
      candidateCriticalPoint ≤ 1 / 5 ∧
      stationaryCubic candidateCriticalPoint = 0 :=
  Classical.choose_spec stationaryCubic_exists_root_bracket

end NewtonianLipschitz
