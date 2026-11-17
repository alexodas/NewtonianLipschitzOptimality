module

public import NewtonianLipschitz.DerivativeCoefficientMinimality

public section

/-!
# A direction attaining the physical derivative norm

At the critical normalized diagonal, the physical Frechet
derivative has operator norm exactly candidateMaximum (R029).
A concrete signed Cartesian direction with norm at most one
has derivative-action norm equal to that same coefficient.

This prepares a local finite-difference lower-bound argument,
not the full two-point theorem for the nonconvex cube exterior.
-/

open Matrix

namespace NewtonianLipschitz

/-- The derivative at the unit-parameter critical diagonal
has a Cartesian direction of norm at most one whose
derivative action has norm equal to C3. -/
theorem NewtonianPointSource.unitAxis_fderiv_exists_attaining_direction :
    ∃ h : Vec3, ‖h‖ ≤ 1 ∧
      ‖(fderiv ℝ NewtonianPointSource.unitAxis.accelerationField
        (normalizedVector candidateCriticalPoint candidateCriticalPoint)) h‖ =
          candidateMaximum := by
  let c := NewtonianPointSource.unitAxis
  let x := normalizedVector candidateCriticalPoint candidateCriticalPoint
  let A := newtonianJacobianMatrix c.gravitationalParameter x
  have hnorm : ‖x‖ = (1 : ℝ) :=
    criticalDiagonal_cartesian_norm_eq_one
  have hx : x ≠ 0 := by
    intro hzero
    rw [hzero, norm_zero] at hnorm
    norm_num at hnorm
  obtain ⟨h, hh, hrowAction⟩ :=
    matrix3_exists_rowSum_attaining_direction A 0
  have hrow :
      (∑ j : Fin 3, |A 0 j|) = candidateMaximum := by
    change (∑ j : Fin 3,
      |newtonianJacobianMatrix c.gravitationalParameter x 0 j|) =
        candidateMaximum
    rw [NewtonianPointSource.unitAxis_gravitationalParameter_eq_one]
    exact newtonianJacobianMatrix_critical_firstRow_eq_candidateMaximum
  have haction :
      (fderiv ℝ c.accelerationField x) h = A *ᵥ h := by
    rw [c.accelerationField_fderiv_eq_jacobianMatrix x h hx]
  have hcomponent : (A *ᵥ h) 0 ≤ ‖A *ᵥ h‖ := by
    have habs : (A *ᵥ h) 0 ≤ |(A *ᵥ h) 0| :=
      le_abs_self _
    have hpi : |(A *ᵥ h) 0| ≤ ‖A *ᵥ h‖ := by
      simpa only [Real.norm_eq_abs] using
        (norm_le_pi_norm (A *ᵥ h) 0)
    exact habs.trans hpi
  have hlower :
      candidateMaximum ≤
        ‖(fderiv ℝ c.accelerationField x) h‖ := by
    calc
      candidateMaximum = ∑ j : Fin 3, |A 0 j| := hrow.symm
      _ = (A *ᵥ h) 0 := hrowAction.symm
      _ ≤ ‖A *ᵥ h‖ := hcomponent
      _ = ‖(fderiv ℝ c.accelerationField x) h‖ := by
        rw [haction]
  have hoperator :
      ‖fderiv ℝ c.accelerationField x‖ = candidateMaximum :=
    NewtonianPointSource.unitAxis_fderiv_opNorm_eq_candidateMaximum
  have hupper :
      ‖(fderiv ℝ c.accelerationField x) h‖ ≤
        candidateMaximum := by
    calc
      ‖(fderiv ℝ c.accelerationField x) h‖
          ≤ ‖fderiv ℝ c.accelerationField x‖ * ‖h‖ :=
            (fderiv ℝ c.accelerationField x).le_opNorm h
      _ ≤ candidateMaximum * 1 := by
        rw [hoperator]
        exact mul_le_mul_of_nonneg_left hh candidateMaximum_nonneg
      _ = candidateMaximum := mul_one _
  exact ⟨h, hh, le_antisymm hupper hlower⟩

end NewtonianLipschitz
