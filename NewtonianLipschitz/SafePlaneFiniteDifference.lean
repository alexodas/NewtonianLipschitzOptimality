module

public import NewtonianLipschitz.PhysicalTangentialAllAxes

public section

/-!
# Finite differences on safe planes and the sharp global single-source bound

R046 proves the true physical Newtonian derivative estimate with
coefficient 5/4 in every direction tangent to any signed-safe
Cartesian coordinate plane. Here the line between two endpoints
having the SAME safe coordinate stays on that plane. We apply the
one-dimensional mean-value inequality along this segment to
prove actual finite differences of the physical acceleration.

The resulting safe-plane bound discharges the explicit premise
of R043, which already proves that every arbitrary pair of
cube-exterior endpoints satisfies the global sharp C3 bound.
No statement about the independent Comparator is made here.
-/

namespace NewtonianLipschitz

/-- A 5/4 bound on the actual Newtonian force difference
between any two endpoints with a fixed signed-safe coordinate.
The segment remains safe, and the estimate is obtained by
integrating R046's genuine tangent derivative. -/
theorem NewtonianPointSource.accelerationField_norm_sub_le_fiveFourth_safePlane
    (c : NewtonianPointSource) (x y : Vec3) (d : ℝ) (i : Fin 3)
    (hd : 0 < d) (hxy : x i = y i)
    (hsafe : d ≤ x i ∨ x i ≤ -d) :
    ‖c.accelerationField x - c.accelerationField y‖ ≤
      ((1 / d ^ 3) *
        (c.gravitationalParameter * (5 / 4 : ℝ))) * ‖x - y‖ := by
  let v : Vec3 := y - x
  let line : ℝ → Vec3 := fun t => x + t • v
  let fieldLine : ℝ → Vec3 :=
    fun t => c.accelerationField (line t)
  let fieldLineDeriv : ℝ → Vec3 :=
    fun t => (fderiv ℝ c.accelerationField (line t)) v
  let B : ℝ :=
    (1 / d ^ 3) * (c.gravitationalParameter * (5 / 4 : ℝ))
  have hvi : v i = 0 := by
    change y i - x i = 0
    linarith
  have hcoordinate (t : ℝ) : line t i = x i := by
    change (x + t • v) i = x i
    simp only [Pi.add_apply, Pi.smul_apply, smul_eq_mul,
      hvi, mul_zero, add_zero]
  have hsafeabs : d ≤ |x i| := by
    rcases hsafe with hpos | hneg
    · exact hpos.trans (le_abs_self _)
    · have hn : d ≤ -(x i) := by linarith
      exact hn.trans (neg_le_abs _)
  have hlineclear (t : ℝ) : d ≤ |line t i| := by
    rw [hcoordinate t]
    exact hsafeabs
  have hnonzero (t : ℝ) : line t ≠ 0 := by
    intro hz
    have hzero := congrArg (fun z : Vec3 => z i) hz
    simp only [Pi.zero_apply] at hzero
    have hclear := hlineclear t
    rw [hzero, abs_zero] at hclear
    linarith
  have hlineDeriv (t : ℝ) : HasDerivAt line v t := by
    change HasDerivAt (fun s : ℝ => x + s • v) v t
    simpa using ((hasDerivAt_id t).smul_const v).const_add x
  have hphysicalDifferentiable (t : ℝ) :
      DifferentiableAt ℝ c.accelerationField (line t) :=
    (c.accelerationField_contDiffAt (line t)
      (hnonzero t)).differentiableAt_one
  have hfieldDeriv (t : ℝ) :
      HasDerivAt fieldLine (fieldLineDeriv t) t := by
    exact (hphysicalDifferentiable t).hasFDerivAt.comp_hasDerivAt
      t (hlineDeriv t)
  have hderivBound (t : ℝ) :
      ‖fieldLineDeriv t‖ ≤ B * ‖v‖ :=
    c.accelerationField_fderiv_any_safe_axis_tangent_le
      (line t) v d hd i (hlineclear t) hvi
  have hmean :
      ‖fieldLine 1 - fieldLine 0‖ ≤ B * ‖v‖ :=
    norm_image_sub_le_of_norm_deriv_le_segment_01'
      (f := fieldLine) (f' := fieldLineDeriv)
      (C := B * ‖v‖)
      (fun t _ => (hfieldDeriv t).hasDerivWithinAt)
      (fun t _ => hderivBound t)
  have hstart : fieldLine 0 = c.accelerationField x := by
    dsimp [fieldLine, line]
    simp
  have hend : fieldLine 1 = c.accelerationField y := by
    change c.accelerationField (x + (1 : ℝ) • v) =
      c.accelerationField y
    congr 1
    rw [one_smul]
    dsimp [v]
    abel
  change ‖c.accelerationField x - c.accelerationField y‖ ≤
    B * ‖x - y‖
  calc
    ‖c.accelerationField x - c.accelerationField y‖
        = ‖fieldLine 1 - fieldLine 0‖ := by
          rw [hstart, hend]
          exact norm_sub_rev _ _
    _ ≤ B * ‖v‖ := hmean
    _ = B * ‖x - y‖ := by
      dsimp [v]
      rw [norm_sub_rev]

/-- The previously explicit R043 safe-plane proposition is
now proved with no extra physical or geometric assumptions. -/
theorem oneSourceSafePlaneFiveFourthBound_proved :
    oneSourceSafePlaneFiveFourthBound := by
  intro c x y d i hd hxy hsafe
  exact c.accelerationField_norm_sub_le_fiveFourth_safePlane
    x y d i hd hxy hsafe

/-- Global C3 finite-difference bound for the exact single-source
Newtonian acceleration on the full NONCONVEX exterior of a
Cartesian safety cube, without restrictions on the segment
between the endpoints. This is unconditional. -/
theorem oneSourceGlobalCandidateBound_proved :
    oneSourceGlobalCandidateBound :=
  oneSourceGlobalCandidateBound_of_safePlaneFiveFourth
    oneSourceSafePlaneFiveFourthBound_proved

end NewtonianLipschitz
