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
  simp only [normalizedVector_zero, normalizedVector_one, normalizedVector_two]
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
    rw [candidateMaximum_eq]
    exact candidateCoefficient_le_at_criticalPoint t ht
  calc
    (∑ j : Fin 3,
      |newtonianJacobianMatrix μ (normalizedVector u v) 0 j|)
        ≤ (μ / euclideanRadius (normalizedVector u v) ^ 5) *
            dominantRowNumerator t t := hrow
    _ = μ * candidateCoefficient t := hcoe
    _ ≤ μ * candidateMaximum :=
      mul_le_mul_of_nonneg_left hmax hμ


/-!
## The second row of the physical normalized Jacobian

This is one of the two lateral rows. The comparison uses the
previously checked algebraic row-dominance lemma.
-/

/-- Exact entry in row one and column zero. -/
theorem newtonianJacobianMatrix_normalized_one_zero
    (μ u v : ℝ) :
    newtonianJacobianMatrix μ (normalizedVector u v) 1 0 =
      (μ / euclideanRadius (normalizedVector u v) ^ 5) *
        (3 * u) := by
  rw [newtonianJacobianMatrix_entry]
  norm_num <;> ring

/-- Exact diagonal entry in the second row. -/
theorem newtonianJacobianMatrix_normalized_one_one
    (μ u v : ℝ) :
    newtonianJacobianMatrix μ (normalizedVector u v) 1 1 =
      (μ / euclideanRadius (normalizedVector u v) ^ 5) *
        (2 * u ^ 2 - 1 - v ^ 2) := by
  rw [newtonianJacobianMatrix_entry, normalizedVector_radius_sq]
  simp only [normalizedVector_one, ite_true]
  ring

/-- Exact entry in row one and column two. -/
theorem newtonianJacobianMatrix_normalized_one_two
    (μ u v : ℝ) :
    newtonianJacobianMatrix μ (normalizedVector u v) 1 2 =
      (μ / euclideanRadius (normalizedVector u v) ^ 5) *
        (3 * u * v) := by
  rw [newtonianJacobianMatrix_entry]
  norm_num <;> ring

/-- Exact absolute sum of the second Jacobian row. -/
theorem newtonianJacobianMatrix_normalized_secondRow_abs_sum
    (μ u v : ℝ) (hμ : 0 ≤ μ)
    (hu0 : 0 ≤ u) (hv0 : 0 ≤ v) :
    (∑ j : Fin 3,
      |newtonianJacobianMatrix μ (normalizedVector u v) 1 j|) =
      (μ / euclideanRadius (normalizedVector u v) ^ 5) *
        lateralRowNumerator u v := by
  have hr : 0 ≤ euclideanRadius (normalizedVector u v) := by
    rw [euclideanRadius_eq_physical_norm]
    exact norm_nonneg _
  have hk : 0 ≤ μ / euclideanRadius (normalizedVector u v) ^ 5 :=
    div_nonneg hμ (pow_nonneg hr _)
  have h3u : 0 ≤ 3 * u :=
    mul_nonneg (by norm_num) hu0
  have h3uv : 0 ≤ 3 * u * v :=
    mul_nonneg h3u hv0
  rw [Fin.sum_univ_three,
    newtonianJacobianMatrix_normalized_one_zero,
    newtonianJacobianMatrix_normalized_one_one,
    newtonianJacobianMatrix_normalized_one_two]
  rw [abs_of_nonneg (mul_nonneg hk h3u),
    abs_of_nonneg (mul_nonneg hk h3uv),
    abs_mul, abs_of_nonneg hk]
  rw [lateralRowNumerator_eq]
  ring

/-- The second physical row satisfies the exact scalar candidate
bound in the nonnegative normalized octant. -/
theorem newtonianJacobianMatrix_normalized_secondRow_le_candidateMaximum
    (μ u v : ℝ) (hμ : 0 ≤ μ)
    (hu0 : 0 ≤ u) (hu1 : u ≤ 1)
    (hv0 : 0 ≤ v) (hv1 : v ≤ 1) :
    (∑ j : Fin 3,
      |newtonianJacobianMatrix μ (normalizedVector u v) 1 j|) ≤
      μ * candidateMaximum := by
  have hr : 0 ≤ euclideanRadius (normalizedVector u v) := by
    rw [euclideanRadius_eq_physical_norm]
    exact norm_nonneg _
  have hk : 0 ≤ μ / euclideanRadius (normalizedVector u v) ^ 5 :=
    div_nonneg hμ (pow_nonneg hr _)
  calc
    (∑ j : Fin 3,
      |newtonianJacobianMatrix μ (normalizedVector u v) 1 j|)
        = (μ / euclideanRadius (normalizedVector u v) ^ 5) *
            lateralRowNumerator u v :=
          newtonianJacobianMatrix_normalized_secondRow_abs_sum
            μ u v hμ hu0 hv0
    _ ≤ (μ / euclideanRadius (normalizedVector u v) ^ 5) *
          dominantRowNumerator u v :=
        mul_le_mul_of_nonneg_left
          (lateralRowNumerator_le_dominant u v hu0 hu1 hv0 hv1) hk
    _ = (∑ j : Fin 3,
          |newtonianJacobianMatrix μ (normalizedVector u v) 0 j|) :=
        (newtonianJacobianMatrix_normalized_firstRow_abs_sum
          μ u v hμ hu0 hu1 hv0 hv1).symm
    _ ≤ μ * candidateMaximum :=
        newtonianJacobianMatrix_normalized_firstRow_le_candidateMaximum
          μ u v hμ hu0 hu1 hv0 hv1


/-!
## The third row and the complete normalized row bound
-/

/-- Entry (2,0) in nonnegative normalized coordinates. -/
theorem newtonianJacobianMatrix_normalized_two_zero
    (μ u v : ℝ) :
    newtonianJacobianMatrix μ (normalizedVector u v) 2 0 =
      (μ / euclideanRadius (normalizedVector u v) ^ 5) *
        (3 * v) := by
  rw [newtonianJacobianMatrix_entry]
  norm_num <;> ring

/-- Entry (2,1) in nonnegative normalized coordinates. -/
theorem newtonianJacobianMatrix_normalized_two_one
    (μ u v : ℝ) :
    newtonianJacobianMatrix μ (normalizedVector u v) 2 1 =
      (μ / euclideanRadius (normalizedVector u v) ^ 5) *
        (3 * v * u) := by
  rw [newtonianJacobianMatrix_entry]
  norm_num <;> ring

/-- Entry (2,2) in nonnegative normalized coordinates. -/
theorem newtonianJacobianMatrix_normalized_two_two
    (μ u v : ℝ) :
    newtonianJacobianMatrix μ (normalizedVector u v) 2 2 =
      (μ / euclideanRadius (normalizedVector u v) ^ 5) *
        (2 * v ^ 2 - 1 - u ^ 2) := by
  rw [newtonianJacobianMatrix_entry, normalizedVector_radius_sq]
  simp only [normalizedVector_two, ite_true]
  ring

/-- The third absolute-row sum is the swapped lateral numerator. -/
theorem newtonianJacobianMatrix_normalized_thirdRow_abs_sum
    (μ u v : ℝ) (hμ : 0 ≤ μ)
    (hu0 : 0 ≤ u) (hv0 : 0 ≤ v) :
    (∑ j : Fin 3,
      |newtonianJacobianMatrix μ (normalizedVector u v) 2 j|) =
      (μ / euclideanRadius (normalizedVector u v) ^ 5) *
        lateralRowNumerator v u := by
  have hr : 0 ≤ euclideanRadius (normalizedVector u v) := by
    rw [euclideanRadius_eq_physical_norm]
    exact norm_nonneg _
  have hk : 0 ≤ μ / euclideanRadius (normalizedVector u v) ^ 5 :=
    div_nonneg hμ (pow_nonneg hr _)
  have h3v : 0 ≤ 3 * v :=
    mul_nonneg (by norm_num) hv0
  have h3vu : 0 ≤ 3 * v * u :=
    mul_nonneg h3v hu0
  rw [Fin.sum_univ_three,
    newtonianJacobianMatrix_normalized_two_zero,
    newtonianJacobianMatrix_normalized_two_one,
    newtonianJacobianMatrix_normalized_two_two]
  rw [abs_of_nonneg (mul_nonneg hk h3v),
    abs_of_nonneg (mul_nonneg hk h3vu),
    abs_mul, abs_of_nonneg hk]
  rw [lateralRowNumerator_eq]
  ring

/-- The third physical row also obeys the exact scalar candidate
bound on the positive normalized octant. -/
theorem newtonianJacobianMatrix_normalized_thirdRow_le_candidateMaximum
    (μ u v : ℝ) (hμ : 0 ≤ μ)
    (hu0 : 0 ≤ u) (hu1 : u ≤ 1)
    (hv0 : 0 ≤ v) (hv1 : v ≤ 1) :
    (∑ j : Fin 3,
      |newtonianJacobianMatrix μ (normalizedVector u v) 2 j|) ≤
      μ * candidateMaximum := by
  have hr : 0 ≤ euclideanRadius (normalizedVector u v) := by
    rw [euclideanRadius_eq_physical_norm]
    exact norm_nonneg _
  have hk : 0 ≤ μ / euclideanRadius (normalizedVector u v) ^ 5 :=
    div_nonneg hμ (pow_nonneg hr _)
  calc
    (∑ j : Fin 3,
      |newtonianJacobianMatrix μ (normalizedVector u v) 2 j|)
        = (μ / euclideanRadius (normalizedVector u v) ^ 5) *
            lateralRowNumerator v u :=
          newtonianJacobianMatrix_normalized_thirdRow_abs_sum
            μ u v hμ hu0 hv0
    _ ≤ (μ / euclideanRadius (normalizedVector u v) ^ 5) *
          dominantRowNumerator u v :=
        mul_le_mul_of_nonneg_left
          (lateralRowNumerator_swapped_le_dominant
            u v hu0 hu1 hv0 hv1) hk
    _ = (∑ j : Fin 3,
          |newtonianJacobianMatrix μ (normalizedVector u v) 0 j|) :=
        (newtonianJacobianMatrix_normalized_firstRow_abs_sum
          μ u v hμ hu0 hu1 hv0 hv1).symm
    _ ≤ μ * candidateMaximum :=
        newtonianJacobianMatrix_normalized_firstRow_le_candidateMaximum
          μ u v hμ hu0 hu1 hv0 hv1

/-- All three rows of the exact physical Jacobian obey the sharp
candidate bound in the nonnegative normalized octant. -/
theorem newtonianJacobianMatrix_normalized_allRows_le_candidateMaximum
    (μ u v : ℝ) (hμ : 0 ≤ μ)
    (hu0 : 0 ≤ u) (hu1 : u ≤ 1)
    (hv0 : 0 ≤ v) (hv1 : v ≤ 1) (i : Fin 3) :
    (∑ j : Fin 3,
      |newtonianJacobianMatrix μ (normalizedVector u v) i j|) ≤
      μ * candidateMaximum := by
  fin_cases i
  · exact newtonianJacobianMatrix_normalized_firstRow_le_candidateMaximum
      μ u v hμ hu0 hu1 hv0 hv1
  · exact newtonianJacobianMatrix_normalized_secondRow_le_candidateMaximum
      μ u v hμ hu0 hu1 hv0 hv1
  · exact newtonianJacobianMatrix_normalized_thirdRow_le_candidateMaximum
      μ u v hμ hu0 hu1 hv0 hv1

end NewtonianLipschitz
