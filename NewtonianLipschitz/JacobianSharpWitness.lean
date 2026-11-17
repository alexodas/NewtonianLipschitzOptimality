module

public import NewtonianLipschitz.JacobianOperatorNorm

public section

/-!
# Attainment of the candidate Jacobian row bound

At the diagonal normalized displacement (1,t,t), the first
row sum equals the scalar candidate coefficient. The critical
parameter therefore gives an explicit unit-Cartesian-norm
displacement whose physical Jacobian first row attains
candidateMaximum.

R029 later proves exact operator-norm attainment; R036–R037
prove the necessary finite-difference coefficient lower bound.
The sharp nonconvex global upper bound remains open.
-/

namespace NewtonianLipschitz

/-- The normalized diagonal Euclidean radius coincides with
the square-root expression in the candidate denominator. -/
theorem normalized_diagonal_radius (t : ℝ) :
    euclideanRadius (normalizedVector t t) =
      Real.sqrt (1 + 2 * t ^ 2) := by
  rw [euclideanRadius_eq_coordinates]
  simp only [normalizedVector_zero, normalizedVector_one,
    normalizedVector_two]
  congr 1
  ring

/-- Exact first absolute Jacobian row sum on the nonnegative
diagonal, expressed using the scalar candidate function. -/
theorem newtonianJacobianMatrix_diagonal_firstRow_eq_coefficient
    (μ t : ℝ) (hμ : 0 ≤ μ) (ht0 : 0 ≤ t) (ht1 : t ≤ 1) :
    (∑ j : Fin 3,
      |newtonianJacobianMatrix μ (normalizedVector t t) 0 j|) =
        μ * candidateCoefficient t := by
  calc
    (∑ j : Fin 3,
      |newtonianJacobianMatrix μ (normalizedVector t t) 0 j|)
        = (μ / euclideanRadius (normalizedVector t t) ^ 5) *
            dominantRowNumerator t t :=
          newtonianJacobianMatrix_normalized_firstRow_abs_sum
            μ t t hμ ht0 ht1 ht0 ht1
    _ = μ * candidateCoefficient t := by
      rw [normalized_diagonal_radius,
        dominantRowNumerator_diagonal, candidateCoefficient_eq]
      ring

/-- The critical diagonal displacement has Cartesian norm one. -/
theorem criticalDiagonal_cartesian_norm_eq_one :
    ‖normalizedVector candidateCriticalPoint candidateCriticalPoint‖ =
      (1 : ℝ) := by
  obtain ⟨ht0, ht1, _⟩ := candidateCriticalPoint_spec
  have ht_nonneg : 0 ≤ candidateCriticalPoint := by linarith
  have ht_le_one : candidateCriticalPoint ≤ 1 := by linarith
  rw [cartesian_norm_eq_max_abs]
  simp only [normalizedVector_zero, normalizedVector_one,
    normalizedVector_two, abs_one, abs_of_nonneg ht_nonneg,
    max_self, max_eq_left ht_le_one]

/-- The sharp candidate row bound is attained by an actual
Newtonian Jacobian at a Cartesian unit displacement. -/
theorem newtonianJacobianMatrix_critical_firstRow_eq_candidateMaximum :
    (∑ j : Fin 3,
      |newtonianJacobianMatrix (1 : ℝ)
        (normalizedVector candidateCriticalPoint candidateCriticalPoint)
          0 j|) = candidateMaximum := by
  obtain ⟨ht0, ht1, _⟩ := candidateCriticalPoint_spec
  have ht_nonneg : 0 ≤ candidateCriticalPoint := by linarith
  have ht_le_one : candidateCriticalPoint ≤ 1 := by linarith
  have hrow :=
    newtonianJacobianMatrix_diagonal_firstRow_eq_coefficient
      1 candidateCriticalPoint (by norm_num) ht_nonneg ht_le_one
  simpa only [one_mul, candidateMaximum_eq] using hrow

end NewtonianLipschitz
