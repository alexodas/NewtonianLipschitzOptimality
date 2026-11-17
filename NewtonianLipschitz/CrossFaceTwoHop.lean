module

public import NewtonianLipschitz.CommonSafeFace

public section

/-!
# Two safe hops for endpoints with different active Cartesian axes

R039 proves the sharp C3 bound whenever the endpoints
lie in a common supporting halfspace of the forbidden cube.
Two admissible endpoints with different active coordinates
can be connected through a coordinate bridge: the first
hop retains the first endpoint's safe coordinate; the
second hop retains the second endpoint's safe coordinate.

Each hop has Cartesian length at most the direct separation.
Consequently the physical two-point Newtonian difference
is bounded by *2 C3* times that separation, even when the
straight segment between the endpoints is unsafe.

This is a NONSHARP bound: it does NOT prove the proposed
global coefficient C3 for short cross-face pairs.
-/

namespace NewtonianLipschitz

/-- Replace the i-th coordinate of y with that of x.
When i ≠ j, this bridge agrees with x on coordinate i
and with y on coordinate j. Its two Cartesian hop
lengths are each no more than ‖x-y‖. -/
theorem cartesian_different_axes_two_hop_bridge
    (x y : Vec3) (i j : Fin 3) (hij : i ≠ j) :
    ∃ w : Vec3,
      w i = x i ∧
      w j = y j ∧
      ‖x - w‖ ≤ ‖x - y‖ ∧
      ‖w - y‖ ≤ ‖x - y‖ := by
  let w : Vec3 := fun k => if k = i then x i else y k
  have hwi : w i = x i := by
    simp [w]
  have hwj : w j = y j := by
    simp [w, hij.symm]
  have hxw : ‖x - w‖ ≤ ‖x - y‖ := by
    apply (pi_norm_le_iff_of_nonneg (norm_nonneg (x - y))).2
    intro k
    by_cases hki : k = i
    · subst k
      have hzero : (x - w) i = 0 := by
        simp [w]
      simpa [hzero] using (norm_nonneg (x - y))
    · have heq : (x - w) k = (x - y) k := by
        simp [w, hki]
      rw [heq]
      exact norm_le_pi_norm (x - y) k
  have hwy : ‖w - y‖ ≤ ‖x - y‖ := by
    apply (pi_norm_le_iff_of_nonneg (norm_nonneg (x - y))).2
    intro k
    by_cases hki : k = i
    · subst k
      have heq : (w - y) i = (x - y) i := by
        simp [w]
      rw [heq]
      exact norm_le_pi_norm (x - y) i
    · have hzero : (w - y) k = 0 := by
        simp [w, hki]
      simpa [hzero] using (norm_nonneg (x - y))
  exact ⟨w, hwi, hwj, hxw, hwy⟩

/-- R040: two endpoints with safe active coordinates
on *different axes* satisfy a global two-point Newtonian
bound with coefficient 2 C3. This applies even if their
straight connecting segment enters the forbidden cube.

The factor 2 is from two safe convex hops, and is not
asserted to be the optimal coefficient. -/
theorem NewtonianPointSource.accelerationField_norm_sub_le_two_candidateMaximum_different_axes
    (c : NewtonianPointSource) (x y : Vec3) (d : ℝ)
    (hd : 0 < d) (i j : Fin 3) (hij : i ≠ j)
    (hxi : d ≤ x i ∨ x i ≤ -d)
    (hyj : d ≤ y j ∨ y j ≤ -d) :
    ‖c.accelerationField x - c.accelerationField y‖ ≤
      (2 * ((1 / d ^ 3) *
        (c.gravitationalParameter * candidateMaximum))) * ‖x - y‖ := by
  obtain ⟨w, hwi, hwj, hxw, hwy⟩ :=
    cartesian_different_axes_two_hop_bridge x y i j hij
  have hxface :
      ∃ k : Fin 3,
        (d ≤ x k ∧ d ≤ w k) ∨
        (x k ≤ -d ∧ w k ≤ -d) := by
    refine ⟨i, ?_⟩
    rcases hxi with hiPos | hiNeg
    · left
      exact ⟨hiPos, by rwa [hwi]⟩
    · right
      exact ⟨hiNeg, by rwa [hwi]⟩
  have hyface :
      ∃ k : Fin 3,
        (d ≤ w k ∧ d ≤ y k) ∨
        (w k ≤ -d ∧ y k ≤ -d) := by
    refine ⟨j, ?_⟩
    rcases hyj with hjPos | hjNeg
    · left
      exact ⟨by rwa [hwj], hjPos⟩
    · right
      exact ⟨by rwa [hwj], hjNeg⟩
  let A : ℝ :=
    (1 / d ^ 3) * (c.gravitationalParameter * candidateMaximum)
  have hA : 0 ≤ A := by
    dsimp [A]
    exact mul_nonneg (by positivity)
      (mul_nonneg c.gravitationalParameter_nonneg
        candidateMaximum_nonneg)
  have hxbound :
      ‖c.accelerationField x - c.accelerationField w‖ ≤
        A * ‖x - w‖ :=
    c.accelerationField_norm_sub_le_candidateMaximum_common_face
      x w d hd hxface
  have hybound :
      ‖c.accelerationField w - c.accelerationField y‖ ≤
        A * ‖w - y‖ :=
    c.accelerationField_norm_sub_le_candidateMaximum_common_face
      w y d hd hyface
  change ‖c.accelerationField x - c.accelerationField y‖ ≤
    (2 * A) * ‖x - y‖
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

end NewtonianLipschitz
