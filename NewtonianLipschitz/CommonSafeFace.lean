module

public import NewtonianLipschitz.LongSeparation

public section

/-!
# Sharp Newtonian bound for endpoints sharing a safe cube face

R038 establishes the sharp C3 finite-difference estimate when
the Cartesian separation between two safe endpoints is at least
their clearance d.

Here a second elementary part of the nonconvex-domain
problem is isolated: if the endpoints lie on the same
supporting halfspace of the forbidden cube, the whole
connecting segment lies in that safe convex halfspace.
R030 can therefore be applied without any extra assumptions
about the other coordinates.

The two cases are combined below. The global upper bound
for short, cross-face endpoint pairs is NOT proved here.
-/

namespace NewtonianLipschitz

/-- A coordinate supporting halfspace on the positive side of
the forbidden Cartesian cube is convex. -/
theorem cartesianPositiveSafeHalfspace_convex (i : Fin 3) (d : ℝ) :
    Convex ℝ {z : Vec3 | d ≤ z i} := by
  change Convex ℝ
    ((LinearMap.proj i : Vec3 →ₗ[ℝ] ℝ) ⁻¹' Set.Ici d)
  exact (convex_Ici d).linear_preimage
    (LinearMap.proj i : Vec3 →ₗ[ℝ] ℝ)

/-- Every point in a positive coordinate supporting halfspace
has at least d Cartesian norm. -/
theorem cartesianPositiveSafeHalfspace_clearance (i : Fin 3) (d : ℝ) :
    ∀ z : Vec3, d ≤ z i → d ≤ ‖z‖ := by
  intro z hz
  have hcoord : |z i| ≤ ‖z‖ := by
    simpa only [Real.norm_eq_abs] using (norm_le_pi_norm z i)
  exact (hz.trans (le_abs_self (z i))).trans hcoord

/-- A negative coordinate supporting halfspace is convex. -/
theorem cartesianNegativeSafeHalfspace_convex (i : Fin 3) (d : ℝ) :
    Convex ℝ {z : Vec3 | z i ≤ -d} := by
  change Convex ℝ
    ((LinearMap.proj i : Vec3 →ₗ[ℝ] ℝ) ⁻¹' Set.Iic (-d))
  exact (convex_Iic (-d)).linear_preimage
    (LinearMap.proj i : Vec3 →ₗ[ℝ] ℝ)

/-- Every point in a negative coordinate supporting halfspace
has at least d Cartesian norm. -/
theorem cartesianNegativeSafeHalfspace_clearance (i : Fin 3) (d : ℝ) :
    ∀ z : Vec3, z i ≤ -d → d ≤ ‖z‖ := by
  intro z hz
  have hneg : d ≤ -(z i) := by linarith
  have hcoord : |z i| ≤ ‖z‖ := by
    simpa only [Real.norm_eq_abs] using (norm_le_pi_norm z i)
  exact (hneg.trans (neg_le_abs (z i))).trans hcoord

/-- R039: the C3 finite-difference bound holds for any two
endpoints sharing a positive or negative safe supporting
halfspace, independent of their mutual distance.

The endpoint conditions themselves certify their clearance,
and convexity of the supporting halfspace certifies the
whole connecting segment. -/
theorem NewtonianPointSource.accelerationField_norm_sub_le_candidateMaximum_common_face
    (c : NewtonianPointSource) (x y : Vec3) (d : ℝ)
    (hd : 0 < d)
    (hface : ∃ i : Fin 3,
      (d ≤ x i ∧ d ≤ y i) ∨
      (x i ≤ -d ∧ y i ≤ -d)) :
    ‖c.accelerationField x - c.accelerationField y‖ ≤
      ((1 / d ^ 3) * (c.gravitationalParameter * candidateMaximum)) *
        ‖x - y‖ := by
  obtain ⟨i, hpos | hneg⟩ := hface
  · let positions : Set Vec3 := {z | d ≤ z i}
    have hconvex : Convex ℝ positions := by
      simpa only [positions] using cartesianPositiveSafeHalfspace_convex i d
    have hclear : ∀ z ∈ positions, d ≤ ‖z‖ := by
      intro z hz
      exact cartesianPositiveSafeHalfspace_clearance i d z hz
    exact c.accelerationField_norm_sub_le_candidateMaximum_convex
      positions hconvex d hd hclear x y hpos.1 hpos.2
  · let positions : Set Vec3 := {z | z i ≤ -d}
    have hconvex : Convex ℝ positions := by
      simpa only [positions] using cartesianNegativeSafeHalfspace_convex i d
    have hclear : ∀ z ∈ positions, d ≤ ‖z‖ := by
      intro z hz
      exact cartesianNegativeSafeHalfspace_clearance i d z hz
    exact c.accelerationField_norm_sub_le_candidateMaximum_convex
      positions hconvex d hd hclear x y hneg.1 hneg.2

/-- The verified long-separation case R038 and the common-face
case R039 together cover all endpoint pairs satisfying
either condition. The excluded case is a *short* pair
without any shared safe supporting face. -/
theorem NewtonianPointSource.accelerationField_norm_sub_le_candidateMaximum_far_or_common_face
    (c : NewtonianPointSource) (x y : Vec3) (d : ℝ)
    (hd : 0 < d)
    (hx : d ≤ ‖x‖) (hy : d ≤ ‖y‖)
    (hcases : d ≤ ‖x - y‖ ∨
      ∃ i : Fin 3,
        (d ≤ x i ∧ d ≤ y i) ∨
        (x i ≤ -d ∧ y i ≤ -d)) :
    ‖c.accelerationField x - c.accelerationField y‖ ≤
      ((1 / d ^ 3) * (c.gravitationalParameter * candidateMaximum)) *
        ‖x - y‖ := by
  rcases hcases with hfar | hface
  · exact c.accelerationField_norm_sub_le_candidateMaximum_long
      x y d hd hx hy hfar
  · exact c.accelerationField_norm_sub_le_candidateMaximum_common_face
      x y d hd hface

end NewtonianLipschitz
