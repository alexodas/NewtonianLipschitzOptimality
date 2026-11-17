module

public import NewtonianLipschitz.JacobianMatrix
public import NewtonianLipschitz.ScalarMaximum

public section

/-!
# Exact sharp candidate bound on the normalized first Jacobian row

This module joins the proved diagonal row bound to the proved
one-variable scalar maximum. Its conclusion is a real matrix-row
inequality, not yet the complete Cartesian operator-norm inequality
for every nonzero vector.
-/

namespace NewtonianLipschitz

/-- The diagonal parameter associated with two normalized Cartesian
coordinates lies in the unit interval. -/
theorem diagonalParameter_mem_unitInterval
    (u v : ℝ) (hu0 : 0 ≤ u) (hu1 : u ≤ 1)
    (hv0 : 0 ≤ v) (hv1 : v ≤ 1) :
    diagonalParameter u v ∈ Set.Icc (0 : ℝ) 1 := by
  obtain ⟨ht0, hsq⟩ := diagonalParameter_sq u v
  have hu : 0 ≤ (1 - u) * (1 + u) :=
    mul_nonneg (by linarith) (by linarith)
  have hv : 0 ≤ (1 - v) * (1 + v) :=
    mul_nonneg (by linarith) (by linarith)
  constructor
  · exact ht0
  · nlinarith [hu, hv]

/-- The normalized Euclidean radius depends only on the diagonal
parameter constructed from the two smaller coordinates. -/
theorem normalizedVector_radius_eq_diagonal
    (u v : ℝ) :
    euclideanRadius (normalizedVector u v) =
      Real.sqrt (1 + 2 * (diagonalParameter u v) ^ 2) := by
  obtain ⟨ht0, hsq⟩ := diagonalParameter_sq u v
  rw [euclideanRadius_eq_coordinates]
  change Real.sqrt ((1 : ℝ) ^ 2 + u ^ 2 + v ^ 2) =
    Real.sqrt (1 + 2 * (diagonalParameter u v) ^ 2)
  congr 1
  nlinarith [hsq]

/-- The first absolute-row sum of the actual Newtonian Jacobian,
at the normalized positive-octant point, is bounded by the exact
scalar maximum times the gravitational parameter. -/
theorem newtonianJacobianMatrix_normalized_firstRow_le_candidateMaximum
    (μ u v : ℝ) (hμ : 0 ≤ μ)
    (hu0 : 0 ≤ u) (hu1 : u ≤ 1)
    (hv0 : 0 ≤ v) (hv1 : v ≤ 1) :
    (∑ j : Fin 3,
      |newtonianJacobianMatrix μ (normalizedVector u v) 0 j|) ≤
      μ * candidateMaximum := by
  let t := diagonalParameter u v
  have ht : t ∈ Set.Icc (0 : ℝ) 1 :=
    diagonalParameter_mem_unitInterval u v hu0 hu1 hv0 hv1
  have hrow :=
    newtonianJacobianMatrix_normalized_firstRow_le_diagonal
      μ u v hμ hu0 hu1 hv0 hv1
  have hr :
      euclideanRadius (normalizedVector u v) =
        Real.sqrt (1 + 2 * t ^ 2) :=
    normalizedVector_radius_eq_diagonal u v
  have hcoe :
      (μ / euclideanRadius (normalizedVector u v) ^ 5) *
        dominantRowNumerator t t = μ * candidateCoefficient t := by
    rw [dominantRowNumerator_diagonal, candidateCoefficient_eq, hr]
    ring
  have hmax :
      candidateCoefficient t ≤ candidateMaximum := by
    exact candidateCoefficient_le_at_criticalPoint t ht
  calc
    (∑ j : Fin 3,
      |newtonianJacobianMatrix μ (normalizedVector u v) 0 j|)
        ≤ (μ / euclideanRadius (normalizedVector u v) ^ 5) *
            dominantRowNumerator t t := hrow
    _ = μ * candidateCoefficient t := hcoe
    _ ≤ μ * candidateMaximum :=
      mul_le_mul_of_nonneg_left hmax hμ

end NewtonianLipschitz
