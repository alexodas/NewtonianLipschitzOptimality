module

public import NewtonianLipschitz.JacobianNormalization

public section

/-!
# Sharp Jacobian row bounds with a maximal Y or Z coordinate

These statements transfer the already verified first-coordinate
normalization bound through a cyclic relabeling of Cartesian axes.
They apply to nonnegative displacements. Arbitrary coordinate
signs and a universal maximum-norm statement are later steps.
-/

namespace NewtonianLipschitz

/-- Three cyclic relabelings bring every Cartesian index back
to itself. -/
theorem cycleIndex_three (i : Fin 3) :
    cycleIndex (cycleIndex (cycleIndex i)) = i := by
  fin_cases i <;>
    simp only [cycleIndex_zero, cycleIndex_one, cycleIndex_two]

/-- Every row has the sharp candidate bound when Y is positive
and dominates the other two nonnegative Cartesian coordinates. -/
theorem newtonianJacobianMatrix_secondMax_le_candidateMaximum
    (μ : ℝ) (x : Vec3) (i : Fin 3)
    (hμ : 0 ≤ μ)
    (hx1 : 0 < x 1)
    (hx00 : 0 ≤ x 0) (hx0 : x 0 ≤ x 1)
    (hx20 : 0 ≤ x 2) (hx2 : x 2 ≤ x 1) :
    (∑ j : Fin 3, |newtonianJacobianMatrix μ x i j|) ≤
      (1 / (x 1) ^ 3) * (μ * candidateMaximum) := by
  have hy0 : 0 < (cycleVec x) 0 := by
    simpa only [cycleVec_zero] using hx1
  have hy10 : 0 ≤ (cycleVec x) 1 := by
    simpa only [cycleVec_one] using hx20
  have hy1 : (cycleVec x) 1 ≤ (cycleVec x) 0 := by
    simpa only [cycleVec_one, cycleVec_zero] using hx2
  have hy20 : 0 ≤ (cycleVec x) 2 := by
    simpa only [cycleVec_two] using hx00
  have hy2 : (cycleVec x) 2 ≤ (cycleVec x) 0 := by
    simpa only [cycleVec_two, cycleVec_zero] using hx0
  have hbound :=
    newtonianJacobianMatrix_firstMax_le_candidateMaximum
      μ (cycleVec x) (cycleIndex (cycleIndex i))
      hμ hy0 hy10 hy1 hy20 hy2
  rw [newtonianJacobianMatrix_cycle_rowSum
    μ x (cycleIndex (cycleIndex i)),
    cycleIndex_three i] at hbound
  simpa only [cycleVec_zero] using hbound

/-- Every row has the sharp candidate bound when Z is positive
and dominates the other two nonnegative Cartesian coordinates. -/
theorem newtonianJacobianMatrix_thirdMax_le_candidateMaximum
    (μ : ℝ) (x : Vec3) (i : Fin 3)
    (hμ : 0 ≤ μ)
    (hx2 : 0 < x 2)
    (hx00 : 0 ≤ x 0) (hx0 : x 0 ≤ x 2)
    (hx10 : 0 ≤ x 1) (hx1 : x 1 ≤ x 2) :
    (∑ j : Fin 3, |newtonianJacobianMatrix μ x i j|) ≤
      (1 / (x 2) ^ 3) * (μ * candidateMaximum) := by
  have hz0 : 0 < (cycleVec (cycleVec x)) 0 := by
    simpa only [cycleVec_zero, cycleVec_one] using hx2
  have hz10 : 0 ≤ (cycleVec (cycleVec x)) 1 := by
    simpa only [cycleVec_one, cycleVec_two] using hx00
  have hz1 :
      (cycleVec (cycleVec x)) 1 ≤
        (cycleVec (cycleVec x)) 0 := by
    simpa only [cycleVec_zero, cycleVec_one, cycleVec_two] using hx0
  have hz20 : 0 ≤ (cycleVec (cycleVec x)) 2 := by
    simpa only [cycleVec_two, cycleVec_zero] using hx10
  have hz2 :
      (cycleVec (cycleVec x)) 2 ≤
        (cycleVec (cycleVec x)) 0 := by
    simpa only [cycleVec_zero, cycleVec_one, cycleVec_two] using hx1
  have hbound :=
    newtonianJacobianMatrix_firstMax_le_candidateMaximum
      μ (cycleVec (cycleVec x)) (cycleIndex i)
      hμ hz0 hz10 hz1 hz20 hz2
  rw [newtonianJacobianMatrix_cycle_rowSum
        μ (cycleVec x) (cycleIndex i),
      newtonianJacobianMatrix_cycle_rowSum
        μ x (cycleIndex (cycleIndex i)),
      cycleIndex_three i] at hbound
  simpa only [cycleVec_zero, cycleVec_one, cycleVec_two] using hbound

end NewtonianLipschitz
