module

public import NewtonianLipschitz.JacobianSharpWitness

public section

/-!
# Exact sharpness witness for the Cartesian operator norm

A unit Cartesian direction can be chosen to attain the
absolute row sum of any three-by-three real matrix.
At the critical diagonal source separation, the first
Newtonian Jacobian row sum equals candidateMaximum.
The pointwise upper bound from R027 then gives equality
for the operator norm of the genuine Frechet derivative.

This does not itself prove the global two-point bound on
the nonconvex complement of source-centered cubes.
-/

open Matrix

namespace NewtonianLipschitz

/-- Every absolute row sum of a real 3 by 3 matrix can be
attained in that row by a direction of Cartesian norm at most one. -/
theorem matrix3_exists_rowSum_attaining_direction
    (A : Matrix (Fin 3) (Fin 3) ℝ) (i : Fin 3) :
    ∃ h : Vec3, ‖h‖ ≤ 1 ∧
      (A *ᵥ h) i = ∑ j : Fin 3, |A i j| := by
  let h : Vec3 := fun j => if 0 ≤ A i j then (1 : ℝ) else -1
  have hnorm : ‖h‖ ≤ (1 : ℝ) := by
    apply (pi_norm_le_iff_of_nonneg (by norm_num : (0 : ℝ) ≤ 1)).2
    intro j
    change ‖if 0 ≤ A i j then (1 : ℝ) else -1‖ ≤ 1
    split_ifs <;> norm_num
  refine ⟨h, hnorm, ?_⟩
  simp only [Matrix.mulVec, dotProduct]
  apply Finset.sum_congr rfl
  intro j _
  change A i j * (if 0 ≤ A i j then (1 : ℝ) else -1) =
    |A i j|
  split_ifs with hsign
  · simpa only [mul_one, abs_of_nonneg hsign]
  · have hneg : A i j ≤ 0 := le_of_lt (lt_of_not_ge hsign)
    rw [abs_of_nonpos hneg]
    ring

/-- At the exact critical diagonal source displacement,
the true Newtonian derivative has operator norm at least C3. -/
theorem NewtonianPointSource.unitAxis_fderiv_opNorm_ge_candidateMaximum :
    candidateMaximum ≤
      ‖fderiv ℝ NewtonianPointSource.unitAxis.accelerationField
        (normalizedVector candidateCriticalPoint candidateCriticalPoint)‖ := by
  let c := NewtonianPointSource.unitAxis
  let x := normalizedVector candidateCriticalPoint candidateCriticalPoint
  let A := newtonianJacobianMatrix c.gravitationalParameter x
  have hnorm : ‖x‖ = (1 : ℝ) :=
    criticalDiagonal_cartesian_norm_eq_one
  have hx : x ≠ 0 := by
    intro hzero
    rw [hzero, norm_zero] at hnorm
    norm_num at hnorm
  obtain ⟨h, hh, heq⟩ :=
    matrix3_exists_rowSum_attaining_direction A 0
  have hrow : (∑ j : Fin 3, |A 0 j|) = candidateMaximum := by
    change (∑ j : Fin 3,
      |newtonianJacobianMatrix c.gravitationalParameter x 0 j|) =
        candidateMaximum
    rw [NewtonianPointSource.unitAxis_gravitationalParameter_eq_one]
    exact newtonianJacobianMatrix_critical_firstRow_eq_candidateMaximum
  have hcoordinate : (A *ᵥ h) 0 ≤ ‖A *ᵥ h‖ := by
    have habs : (A *ᵥ h) 0 ≤ |(A *ᵥ h) 0| := le_abs_self _
    have hpi : |(A *ᵥ h) 0| ≤ ‖A *ᵥ h‖ := by
      simpa only [Real.norm_eq_abs] using (norm_le_pi_norm (A *ᵥ h) 0)
    exact habs.trans hpi
  calc
    candidateMaximum = (A *ᵥ h) 0 := by rw [heq, hrow]
    _ ≤ ‖A *ᵥ h‖ := hcoordinate
    _ = ‖(fderiv ℝ c.accelerationField x) h‖ := by
      rw [c.accelerationField_fderiv_eq_jacobianMatrix x h hx]
      rfl
    _ ≤ ‖fderiv ℝ c.accelerationField x‖ * ‖h‖ :=
      (fderiv ℝ c.accelerationField x).le_opNorm h
    _ ≤ ‖fderiv ℝ c.accelerationField x‖ * 1 :=
      mul_le_mul_of_nonneg_left hh (norm_nonneg _)
    _ = ‖fderiv ℝ c.accelerationField x‖ := by ring

/-- The exact candidate maximum is attained by the
Cartesian operator norm of the genuine Newtonian derivative. -/
theorem NewtonianPointSource.unitAxis_fderiv_opNorm_eq_candidateMaximum :
    ‖fderiv ℝ NewtonianPointSource.unitAxis.accelerationField
      (normalizedVector candidateCriticalPoint candidateCriticalPoint)‖ =
        candidateMaximum := by
  let x := normalizedVector candidateCriticalPoint candidateCriticalPoint
  let c := NewtonianPointSource.unitAxis
  have hnorm : ‖x‖ = (1 : ℝ) :=
    criticalDiagonal_cartesian_norm_eq_one
  have hx : x ≠ 0 := by
    intro hzero
    rw [hzero, norm_zero] at hnorm
    norm_num at hnorm
  apply le_antisymm
  · have hup :=
      c.accelerationField_fderiv_opNorm_le_candidateMaximum x hx
    simpa only [hnorm, one_pow, div_one, one_mul,
      NewtonianPointSource.unitAxis_gravitationalParameter_eq_one]
      using hup
  · exact NewtonianPointSource.unitAxis_fderiv_opNorm_ge_candidateMaximum

end NewtonianLipschitz
