module

public import NewtonianLipschitz

public section

/-!
# Proofs of the two auditable Palomar statements

The final public statements are repeated verbatim from Challenge.lean.
The scalar proof uses the exact cubic-root and one-variable maximum
certificates. The global proof uses the exact physical inverse-square
field and the already proved one-source global C3 theorem, then takes a
finite sum over independently located sources. No source positions
or masses are fixed by definitions in the Challenge.
-/

open NewtonianLipschitz

/-- The physical finite-source bound, written with an explicit
Newtonian G, masses and centers. It holds for the actual Euclidean
inverse-square field and Cartesian supremum norm on positions. -/
private theorem physicalFiniteSourceGlobalBound
    (n : ℕ) (G M d : ℝ)
    (m : Fin n → ℝ) (a : Fin n → Fin 3 → ℝ)
    (P Q : Fin 3 → ℝ)
    (hG : 0 ≤ G) (hM : 0 ≤ M) (hd : 0 < d)
    (hm : ∀ i : Fin n, 0 ≤ m i ∧ m i ≤ M)
    (hs : ∀ i : Fin n, d ≤ ‖P - a i‖ ∧ d ≤ ‖Q - a i‖) :
    let g : (Fin 3 → ℝ) → (Fin 3 → ℝ) :=
      fun z =>
        ∑ i : Fin n,
          (-(G * m i) /
            (Real.sqrt
              ((z 0 - a i 0) ^ 2 +
               (z 1 - a i 1) ^ 2 +
               (z 2 - a i 2) ^ 2)) ^ 3) • (z - a i)
    ‖g P - g Q‖ ≤
      ((n : ℝ) * G * M * candidateMaximum / d ^ 3) * ‖P - Q‖ := by
  let term : Fin n → Vec3 → Vec3 := fun i z =>
    (-(G * m i) /
      (Real.sqrt
        ((z 0 - a i 0) ^ 2 +
         (z 1 - a i 1) ^ 2 +
         (z 2 - a i 2) ^ 2)) ^ 3) • (z - a i)
  let g : Vec3 → Vec3 := fun z => ∑ i : Fin n, term i z
  have hterm (i : Fin n) :
      ‖term i P - term i Q‖ ≤
        ((1 / d ^ 3) * ((G * m i) * candidateMaximum)) *
          ‖P - Q‖ := by
    let c : NewtonianPointSource :=
      { gravitationalParameter := G * m i
        gravitationalParameter_nonneg := mul_nonneg hG (hm i).1
        displacement := NewtonianPointSource.unitAxis.displacement
        displacement_ne_zero :=
          NewtonianPointSource.unitAxis.displacement_ne_zero }
    have hcμ : c.gravitationalParameter = G * m i := by
      rfl
    have hident (z : Vec3) :
        term i z = c.accelerationField (z - a i) := by
      dsimp [term]
      rw [c.accelerationField_eq_formula, hcμ,
        euclideanRadius_eq_coordinates]
      simp only [Pi.sub_apply]
    have hdist : (P - a i) - (Q - a i) = P - Q := by
      abel
    have hsingle :=
      oneSourceGlobalCandidateBound_proved
        c (P - a i) (Q - a i) d hd (hs i).1 (hs i).2
    calc
      ‖term i P - term i Q‖ =
          ‖c.accelerationField (P - a i) -
            c.accelerationField (Q - a i)‖ := by
          rw [hident, hident]
      _ ≤ ((1 / d ^ 3) *
             ((G * m i) * candidateMaximum)) *
            ‖(P - a i) - (Q - a i)‖ := by
          simpa only [hcμ] using hsingle
      _ = ((1 / d ^ 3) * ((G * m i) *
            candidateMaximum)) * ‖P - Q‖ := by
          rw [hdist]
  have hmass :
      (∑ i : Fin n, G * m i) ≤ (n : ℝ) * (G * M) := by
    have hmasses :
        (∑ i : Fin n, m i) ≤ (n : ℝ) * M := by
      calc
        (∑ i : Fin n, m i) ≤ ∑ _i : Fin n, M :=
          Finset.sum_le_sum (by
            intro i hi
            exact (hm i).2)
        _ = (n : ℝ) * M := by simp
    calc
      (∑ i : Fin n, G * m i) =
          G * (∑ i : Fin n, m i) := by
            rw [Finset.mul_sum]
      _ ≤ G * ((n : ℝ) * M) :=
        mul_le_mul_of_nonneg_left hmasses hG
      _ = (n : ℝ) * (G * M) := by ring
  have hcoefNonneg :
      0 ≤ (1 / d ^ 3) * candidateMaximum * ‖P - Q‖ := by
    exact mul_nonneg
      (mul_nonneg (by positivity) candidateMaximum_nonneg)
      (norm_nonneg _)
  have hsum :
      ‖g P - g Q‖ ≤
        ((n : ℝ) * G * M * candidateMaximum / d ^ 3) *
          ‖P - Q‖ := by
    calc
      ‖g P - g Q‖ =
          ‖∑ i : Fin n, (term i P - term i Q)‖ := by
            dsimp [g]
            rw [Finset.sum_sub_distrib]
      _ ≤ ∑ i : Fin n, ‖term i P - term i Q‖ :=
        norm_sum_le _ _
      _ ≤ ∑ i : Fin n,
            ((1 / d ^ 3) * ((G * m i) *
              candidateMaximum)) * ‖P - Q‖ :=
        Finset.sum_le_sum (by intro i hi; exact hterm i)
      _ = ((∑ i : Fin n, G * m i) *
            ((1 / d ^ 3) * candidateMaximum * ‖P - Q‖)) := by
        calc
          _ = ∑ i : Fin n,
                (G * m i) *
                  ((1 / d ^ 3) * candidateMaximum *
                    ‖P - Q‖) := by
            apply Finset.sum_congr rfl
            intro i hi
            ring
          _ = _ := by rw [Finset.sum_mul]
      _ ≤ ((n : ℝ) * (G * M)) *
            ((1 / d ^ 3) * candidateMaximum * ‖P - Q‖) :=
        mul_le_mul_of_nonneg_right hmass hcoefNonneg
      _ = ((n : ℝ) * G * M *
            candidateMaximum / d ^ 3) * ‖P - Q‖ := by ring
  exact hsum

/-- The stationary cubic has one root in the rational bracket. At that
root the stated exact scalar coefficient is maximal on [0,1]. -/
theorem PalomarNewtonian.scalarMaximum :
    ∃ t : ℝ,
      (9 / 50 : ℝ) ≤ t ∧
      t ≤ (1 / 5 : ℝ) ∧
      2 * t ^ 3 - 8 * t ^ 2 - 4 * t + 1 = 0 ∧
      (∀ s : ℝ, 0 ≤ s → s ≤ 1 →
        (2 + 6 * s - 2 * s ^ 2) /
          (Real.sqrt (1 + 2 * s ^ 2)) ^ 5 ≤
        (2 + 6 * t - 2 * t ^ 2) /
          (Real.sqrt (1 + 2 * t ^ 2)) ^ 5) ∧
      (∀ u : ℝ,
        (9 / 50 : ℝ) ≤ u →
        u ≤ (1 / 5 : ℝ) →
        2 * u ^ 3 - 8 * u ^ 2 - 4 * u + 1 = 0 →
        u = t) := by
  obtain ⟨hl, hr, hz⟩ := candidateCriticalPoint_spec
  refine ⟨candidateCriticalPoint, hl, hr, ?_, ?_, ?_⟩
  · simpa only [stationaryCubic_eq] using hz
  · intro s hs0 hs1
    have h :=
      candidateCoefficient_le_at_criticalPoint s ⟨hs0, hs1⟩
    simpa only [candidateCoefficient_eq] using h
  · intro u hul hur huz
    apply stationaryCubic_root_unique_on_unitInterval
      u candidateCriticalPoint
      ⟨by linarith, by linarith⟩
      ⟨by linarith, by linarith⟩
    · simpa only [stationaryCubic_eq] using huz
    · exact hz

/-- Global Newtonian sensitivity for arbitrary finite masses and source
positions, and exact universality of the coefficient. All distances are
measured in the Cartesian maximum norm; the gravitational field uses
the physical Euclidean radius. The second conjunct proves optimality
universally over configurations (already N=1 suffices), not
optimality separately for every fixed N and every fixed mass layout. -/
theorem PalomarNewtonian.globalCubicSensitivityAndOptimality
    (t : ℝ)
    (htlow : (9 / 50 : ℝ) ≤ t)
    (hthigh : t ≤ (1 / 5 : ℝ))
    (htcubic : 2 * t ^ 3 - 8 * t ^ 2 - 4 * t + 1 = 0) :
    (∀ (n : ℕ) (G M d : ℝ)
      (m : Fin n → ℝ) (a : Fin n → Fin 3 → ℝ)
      (P Q : Fin 3 → ℝ),
      0 ≤ G →
      0 ≤ M →
      0 < d →
      (∀ i : Fin n, 0 ≤ m i ∧ m i ≤ M) →
      (∀ i : Fin n, d ≤ ‖P - a i‖ ∧ d ≤ ‖Q - a i‖) →
      let g : (Fin 3 → ℝ) → (Fin 3 → ℝ) :=
        fun z =>
          ∑ i : Fin n,
            (-(G * m i) /
              (Real.sqrt
                ((z 0 - a i 0) ^ 2 +
                 (z 1 - a i 1) ^ 2 +
                 (z 2 - a i 2) ^ 2)) ^ 3) • (z - a i)
      ‖g P - g Q‖ ≤
        ((n : ℝ) * G * M *
          ((2 + 6 * t - 2 * t ^ 2) /
            (Real.sqrt (1 + 2 * t ^ 2)) ^ 5) / d ^ 3) *
          ‖P - Q‖) ∧
    (∀ K : ℝ,
      (∀ P Q : Fin 3 → ℝ,
        (1 : ℝ) ≤ ‖P‖ →
        (1 : ℝ) ≤ ‖Q‖ →
        ‖(-(1 : ℝ) /
            (Real.sqrt (P 0 ^ 2 + P 1 ^ 2 + P 2 ^ 2)) ^ 3) • P -
          (-(1 : ℝ) /
            (Real.sqrt (Q 0 ^ 2 + Q 1 ^ 2 + Q 2 ^ 2)) ^ 3) • Q‖ ≤
          K * ‖P - Q‖) ↔
      (2 + 6 * t - 2 * t ^ 2) /
        (Real.sqrt (1 + 2 * t ^ 2)) ^ 5 ≤ K) := by
  have ht : t = candidateCriticalPoint := by
    apply stationaryCubic_root_unique_on_unitInterval
      t candidateCriticalPoint
      ⟨by linarith, by linarith⟩
      ⟨by
        have hs := candidateCriticalPoint_spec
        linarith [hs.1],
        by
        have hs := candidateCriticalPoint_spec
        linarith [hs.2.1]⟩
    · simpa only [stationaryCubic_eq] using htcubic
    · exact candidateCriticalPoint_spec.2.2
  have hC :
      candidateMaximum =
        (2 + 6 * t - 2 * t ^ 2) /
          (Real.sqrt (1 + 2 * t ^ 2)) ^ 5 := by
    rw [ht, candidateMaximum_eq, candidateCoefficient_eq]
  constructor
  · intro n G M d m a P Q hG hM hd hm hs
    have hbound := physicalFiniteSourceGlobalBound
      n G M d m a P Q hG hM hd hm hs
    calc
      _ ≤ ((n : ℝ) * G * M * candidateMaximum / d ^ 3) *
          ‖P - Q‖ := hbound
      _ = ((n : ℝ) * G * M *
            ((2 + 6 * t - 2 * t ^ 2) /
              (Real.sqrt (1 + 2 * t ^ 2)) ^ 5) / d ^ 3) *
          ‖P - Q‖ := by rw [hC]
  · intro K
    have hunit (z : Vec3) :
        (-(1 : ℝ) /
          (Real.sqrt (z 0 ^ 2 + z 1 ^ 2 + z 2 ^ 2)) ^ 3) • z =
          NewtonianPointSource.unitAxis.accelerationField z := by
      rw [NewtonianPointSource.accelerationField_eq_formula,
        NewtonianPointSource.unitAxis_gravitationalParameter_eq_one,
        euclideanRadius_eq_coordinates]
    simpa only [← hunit, hC] using
      (unitSource_safe_global_bound_iff_candidateMaximum_le K)
