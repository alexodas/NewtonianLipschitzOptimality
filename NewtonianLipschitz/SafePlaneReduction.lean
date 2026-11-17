module

public import NewtonianLipschitz.ConditionalFiniteSource
public import NewtonianLipschitz.TangentialAlgebra

public section

/-!
# Reducing global cubical Lipschitz optimality to safe-plane differences

The R042 algebra supports, but does not yet prove, a 5/4 estimate
for genuine Newtonian differences along planes with one fixed safe
Cartesian coordinate. Here we state precisely that remaining
finite-difference premise and show that it WOULD imply the sharp
single-source global C3 statement from R041.

The proof uses the fully verified R038 long-separation bound,
R039 common-face bound, R040 two-hop coordinate bridge, and
R042 strict comparison 5/2 < C3.

All final conclusions in this file are conditional on the
explicit, still-unproved safe-plane premise.
-/

namespace NewtonianLipschitz

/-- Explicit, currently unproved safe-plane finite-difference
premise. The coordinate i is fixed along the entire segment
and lies outside the forbidden open cube. -/
abbrev oneSourceSafePlaneFiveFourthBound : Prop :=
  ∀ (c : NewtonianPointSource) (x y : Vec3)
    (d : ℝ) (i : Fin 3),
    0 < d →
    x i = y i →
    (d ≤ x i ∨ x i ≤ -d) →
    ‖c.accelerationField x - c.accelerationField y‖ ≤
      ((1 / d ^ 3) *
        (c.gravitationalParameter * (5 / 4 : ℝ))) * ‖x - y‖

/-- Positive clearance in the Cartesian maximum norm
means that at least one signed coordinate is safe. -/
theorem cartesian_exists_signed_safe_coordinate
    (x : Vec3) (d : ℝ) (hx : d ≤ ‖x‖) :
    ∃ i : Fin 3, d ≤ x i ∨ x i ≤ -d := by
  have hmax :
      d ≤ max (|x 0|) (max (|x 1|) (|x 2|)) := by
    simpa only [cartesian_norm_eq_max_abs] using hx
  have hsigned (i : Fin 3) (hi : d ≤ |x i|) :
      d ≤ x i ∨ x i ≤ -d := by
    rcases le_total 0 (x i) with hpos | hneg
    · left
      rwa [abs_of_nonneg hpos] at hi
    · right
      rw [abs_of_nonpos hneg] at hi
      linarith
  rcases (le_max_iff).1 hmax with hzero | hrest
  · exact ⟨0, hsigned 0 hzero⟩
  · rcases (le_max_iff).1 hrest with hone | htwo
    · exact ⟨1, hsigned 1 hone⟩
    · exact ⟨2, hsigned 2 htwo⟩

/-- Conditional improvement of R040: if the physical
5/4 estimate is available on every fixed safe plane,
a two-hop connection between different active axes
has factor 5/2, strictly smaller than C3. -/
theorem NewtonianPointSource.accelerationField_norm_sub_le_candidateMaximum_different_axes_of_safePlane
    (hPlane : oneSourceSafePlaneFiveFourthBound)
    (c : NewtonianPointSource) (x y : Vec3) (d : ℝ)
    (hd : 0 < d) (i j : Fin 3) (hij : i ≠ j)
    (hxi : d ≤ x i ∨ x i ≤ -d)
    (hyj : d ≤ y j ∨ y j ≤ -d) :
    ‖c.accelerationField x - c.accelerationField y‖ ≤
      ((1 / d ^ 3) *
        (c.gravitationalParameter * candidateMaximum)) * ‖x - y‖ := by
  obtain ⟨w, hwi, hwj, hxw, hwy⟩ :=
    cartesian_different_axes_two_hop_bridge x y i j hij
  have hwj_safe : d ≤ w j ∨ w j ≤ -d := by
    simpa only [hwj] using hyj
  let A : ℝ :=
    (1 / d ^ 3) * (c.gravitationalParameter * (5 / 4 : ℝ))
  let B : ℝ :=
    (1 / d ^ 3) * (c.gravitationalParameter * candidateMaximum)
  have hA : 0 ≤ A := by
    dsimp [A]
    exact mul_nonneg (by positivity)
      (mul_nonneg c.gravitationalParameter_nonneg (by norm_num))
  have hcoef : 2 * A ≤ B := by
    have hm :
        c.gravitationalParameter * (5 / 2 : ℝ) ≤
          c.gravitationalParameter * candidateMaximum :=
      mul_le_mul_of_nonneg_left
        (le_of_lt candidateMaximum_gt_five_halves)
        c.gravitationalParameter_nonneg
    calc
      2 * A =
          (1 / d ^ 3) *
            (c.gravitationalParameter * (5 / 2 : ℝ)) := by
        dsimp [A]
        ring
      _ ≤ B := by
        dsimp [B]
        exact mul_le_mul_of_nonneg_left hm (by positivity)
  have hxbound :
      ‖c.accelerationField x - c.accelerationField w‖ ≤
        A * ‖x - w‖ :=
    hPlane c x w d i hd hwi.symm hxi
  have hybound :
      ‖c.accelerationField w - c.accelerationField y‖ ≤
        A * ‖w - y‖ :=
    hPlane c w y d j hd hwj hwj_safe
  change ‖c.accelerationField x - c.accelerationField y‖ ≤
    B * ‖x - y‖
  calc
    ‖c.accelerationField x - c.accelerationField y‖ ≤
        ‖c.accelerationField x - c.accelerationField w‖ +
          ‖c.accelerationField w - c.accelerationField y‖ := by
      simpa only [dist_eq_norm] using
        (dist_triangle
          (c.accelerationField x)
          (c.accelerationField w)
          (c.accelerationField y))
    _ ≤ A * ‖x - w‖ + A * ‖w - y‖ :=
      add_le_add hxbound hybound
    _ ≤ A * ‖x - y‖ + A * ‖x - y‖ :=
      add_le_add
        (mul_le_mul_of_nonneg_left hxw hA)
        (mul_le_mul_of_nonneg_left hwy hA)
    _ = (2 * A) * ‖x - y‖ := by ring
    _ ≤ B * ‖x - y‖ :=
      mul_le_mul_of_nonneg_right hcoef (norm_nonneg _)

/-- If the same coordinate is safe on opposite sides of
the cube for x and y, their Cartesian separation is at
least d, so R038 applies. -/
theorem cartesian_opposite_safe_sides_separated
    (x y : Vec3) (d : ℝ) (hd : 0 < d)
    (i : Fin 3)
    (hpos : d ≤ x i) (hneg : y i ≤ -d) :
    d ≤ ‖x - y‖ := by
  have hcomponent :
      |(x - y) i| ≤ ‖x - y‖ := by
    simpa only [Real.norm_eq_abs] using
      (norm_le_pi_norm (x - y) i)
  have hdiff : d ≤ x i - y i := by
    linarith
  have heq : (x - y) i = x i - y i := by
    simp
  have habs : d ≤ |(x - y) i| := by
    rw [heq]
    exact hdiff.trans (le_abs_self _)
  exact habs.trans hcomponent

/-- The full sharp one-source global C3 statement is a
formal consequence of the SINGLE explicit safe-plane
5/4 finite-difference proposition. No nonconvex theorem
is asserted here without that premise. -/
theorem oneSourceGlobalCandidateBound_of_safePlaneFiveFourth
    (hPlane : oneSourceSafePlaneFiveFourthBound) :
    oneSourceGlobalCandidateBound := by
  intro c x y d hd hx hy
  obtain ⟨i, hxi⟩ := cartesian_exists_signed_safe_coordinate x d hx
  obtain ⟨j, hyj⟩ := cartesian_exists_signed_safe_coordinate y d hy
  by_cases hij : i = j
  · subst j
    rcases hxi with hxpos | hxneg
    · rcases hyj with hypos | hyneg
      · exact c.accelerationField_norm_sub_le_candidateMaximum_common_face
          x y d hd ⟨i, Or.inl ⟨hxpos, hypos⟩⟩
      · have hfar : d ≤ ‖x - y‖ :=
          cartesian_opposite_safe_sides_separated
            x y d hd i hxpos hyneg
        exact c.accelerationField_norm_sub_le_candidateMaximum_long
          x y d hd hx hy hfar
    · rcases hyj with hypos | hyneg
      · have hfar : d ≤ ‖x - y‖ := by
          have hreverse :
              d ≤ ‖y - x‖ :=
            cartesian_opposite_safe_sides_separated
              y x d hd i hypos hxneg
          simpa only [norm_sub_rev] using hreverse
        exact c.accelerationField_norm_sub_le_candidateMaximum_long
          x y d hd hx hy hfar
      · exact c.accelerationField_norm_sub_le_candidateMaximum_common_face
          x y d hd ⟨i, Or.inr ⟨hxneg, hyneg⟩⟩
  · exact c.accelerationField_norm_sub_le_candidateMaximum_different_axes_of_safePlane
      hPlane x y d hd i j hij hxi hyj

end NewtonianLipschitz
