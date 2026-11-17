module

public import NewtonianLipschitz.CartesianBoxSharp

public section

/-!
# Minimality of the pointwise Newtonian derivative coefficient

R029 proves exact equality of the physical Frechet operator
norm with candidateMaximum at the critical Cartesian diagonal.
Evaluating an arbitrary proposed universal pointwise bound
at this single unit-clearance witness forces its coefficient
to be at least candidateMaximum.

This is a formal minimality theorem for derivative estimates,
not yet a minimality result for global two-point inequalities
outside nonconvex source-centered safety cubes.
-/

namespace NewtonianLipschitz

/-- Any coefficient bounding every point-source Frechet
operator norm at nonzero Cartesian separation must be
at least the exact candidate maximum. -/
theorem candidateMaximum_le_of_universal_fderiv_opNorm_bound
    (K : ℝ)
    (hK : ∀ (c : NewtonianPointSource) (x : Vec3),
      x ≠ 0 →
        ‖fderiv ℝ c.accelerationField x‖ ≤
          (1 / ‖x‖ ^ 3) * (c.gravitationalParameter * K)) :
    candidateMaximum ≤ K := by
  let x : Vec3 :=
    normalizedVector candidateCriticalPoint candidateCriticalPoint
  have hnorm : ‖x‖ = (1 : ℝ) :=
    criticalDiagonal_cartesian_norm_eq_one
  have hx : x ≠ 0 := by
    intro hzero
    rw [hzero, norm_zero] at hnorm
    norm_num at hnorm
  have hbound := hK NewtonianPointSource.unitAxis x hx
  have hmu :
      NewtonianPointSource.unitAxis.gravitationalParameter =
        (1 : ℝ) :=
    NewtonianPointSource.unitAxis_gravitationalParameter_eq_one
  rw [hnorm, one_pow, div_one, one_mul, hmu, one_mul] at hbound
  have heq :
      ‖fderiv ℝ NewtonianPointSource.unitAxis.accelerationField x‖ =
        candidateMaximum :=
    NewtonianPointSource.unitAxis_fderiv_opNorm_eq_candidateMaximum
  rw [heq] at hbound
  exact hbound

/-- A strictly smaller coefficient cannot bound the actual
Frechet operator norm for all nonzero source displacements. -/
theorem candidateMaximum_no_smaller_universal_fderiv_bound
    (K : ℝ) (hK : K < candidateMaximum) :
    ¬ ∀ (c : NewtonianPointSource) (x : Vec3),
        x ≠ 0 →
          ‖fderiv ℝ c.accelerationField x‖ ≤
            (1 / ‖x‖ ^ 3) * (c.gravitationalParameter * K) := by
  intro hbound
  have hminimal :=
    candidateMaximum_le_of_universal_fderiv_opNorm_bound K hbound
  linarith

end NewtonianLipschitz
