module

public import NewtonianLipschitz.JacobianAxisBounds

public section

/-!
# Sharp candidate Jacobian row estimates for arbitrary coordinate signs

The verified bounds cover all three possible dominant
coordinates of a nonnegative displacement. This module takes
the maximum over those coordinates, then applies sign invariance.

The result concerns pointwise absolute Jacobian row sums,
not yet global differences of acceleration between two points.
-/

namespace NewtonianLipschitz

/-- Each row of the physical Jacobian has the sharp candidate
bound for a nonnegative displacement with positive maximum. -/
theorem newtonianJacobianMatrix_nonnegative_max_le_candidateMaximum
    (μ : ℝ) (x : Vec3) (i : Fin 3)
    (hμ : 0 ≤ μ)
    (h0 : 0 ≤ x 0) (h1 : 0 ≤ x 1) (h2 : 0 ≤ x 2)
    (hmax : 0 < max (x 0) (max (x 1) (x 2))) :
    (∑ j : Fin 3, |newtonianJacobianMatrix μ x i j|) ≤
      (1 / (max (x 0) (max (x 1) (x 2))) ^ 3) *
        (μ * candidateMaximum) := by
  rcases le_total (x 1) (x 0) with h10 | h01
  · rcases le_total (x 2) (x 0) with h20 | h02
    · have hm :
          max (x 0) (max (x 1) (x 2)) = x 0 := by
        exact max_eq_left (max_le h10 h20)
      have hx0 : 0 < x 0 := by
        simpa only [hm] using hmax
      simpa only [hm] using
        (newtonianJacobianMatrix_firstMax_le_candidateMaximum
          μ x i hμ hx0 h1 h10 h2 h20)
    · have h12 : x 1 ≤ x 2 := le_trans h10 h02
      have hm :
          max (x 0) (max (x 1) (x 2)) = x 2 := by
        rw [max_eq_right h12, max_eq_right h02]
      have hx2 : 0 < x 2 := by
        simpa only [hm] using hmax
      simpa only [hm] using
        (newtonianJacobianMatrix_thirdMax_le_candidateMaximum
          μ x i hμ hx2 h0 h02 h1 h12)
  · rcases le_total (x 2) (x 1) with h21 | h12
    · have hm :
          max (x 0) (max (x 1) (x 2)) = x 1 := by
        rw [max_eq_left h21, max_eq_right h01]
      have hx1 : 0 < x 1 := by
        simpa only [hm] using hmax
      simpa only [hm] using
        (newtonianJacobianMatrix_secondMax_le_candidateMaximum
          μ x i hμ hx1 h0 h01 h2 h21)
    · have h02 : x 0 ≤ x 2 := le_trans h01 h12
      have hm :
          max (x 0) (max (x 1) (x 2)) = x 2 := by
        rw [max_eq_right h12, max_eq_right h02]
      have hx2 : 0 < x 2 := by
        simpa only [hm] using hmax
      simpa only [hm] using
        (newtonianJacobianMatrix_thirdMax_le_candidateMaximum
          μ x i hμ hx2 h0 h02 h1 h12)

/-- A bound for every row of the actual Newtonian Jacobian,
with arbitrary signs and the maximum of absolute coordinates. -/
theorem newtonianJacobianMatrix_signed_max_le_candidateMaximum
    (μ : ℝ) (x : Vec3) (i : Fin 3)
    (hμ : 0 ≤ μ)
    (hmax :
      0 < max (|x 0|) (max (|x 1|) (|x 2|))) :
    (∑ j : Fin 3, |newtonianJacobianMatrix μ x i j|) ≤
      (1 / (max (|x 0|) (max (|x 1|) (|x 2|))) ^ 3) *
        (μ * candidateMaximum) := by
  have h0 : 0 ≤ coordinateAbs x 0 := by
    rw [coordinateAbs_apply]
    exact abs_nonneg _
  have h1 : 0 ≤ coordinateAbs x 1 := by
    rw [coordinateAbs_apply]
    exact abs_nonneg _
  have h2 : 0 ≤ coordinateAbs x 2 := by
    rw [coordinateAbs_apply]
    exact abs_nonneg _
  have hmax' :
      0 < max (coordinateAbs x 0)
        (max (coordinateAbs x 1) (coordinateAbs x 2)) := by
    simpa only [coordinateAbs_apply] using hmax
  have hbound :=
    newtonianJacobianMatrix_nonnegative_max_le_candidateMaximum
      μ (coordinateAbs x) i hμ h0 h1 h2 hmax'
  calc
    (∑ j : Fin 3, |newtonianJacobianMatrix μ x i j|)
      = ∑ j : Fin 3,
          |newtonianJacobianMatrix μ (coordinateAbs x) i j| :=
        (newtonianJacobianMatrix_rowSum_coordinateAbs μ x i).symm
    _ ≤ (1 / (max (|x 0|) (max (|x 1|) (|x 2|))) ^ 3) *
          (μ * candidateMaximum) := by
        simpa only [coordinateAbs_apply] using hbound

end NewtonianLipschitz
