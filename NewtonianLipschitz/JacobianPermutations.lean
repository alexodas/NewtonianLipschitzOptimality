module

public import NewtonianLipschitz.JacobianSymmetries

public section

/-!
# Permutations of the X, Y, Z axes in the exact Newtonian Jacobian

A cyclic relabeling and a Y/Z transposition generate all
permutations of the three Cartesian axes. These lemmas show
that the physical Euclidean radius and the corresponding
absolute-row sums transform exactly as expected.

The later R024–R027 results combine these identities with
normalization and positive scaling to obtain the sharp
pointwise derivative bound. The global nonconvex two-point
estimate remains a separate open question.
-/

namespace NewtonianLipschitz

/-- Cyclically relabel the axes X -> Y -> Z -> X. -/
def cycleIndex (i : Fin 3) : Fin 3 :=
  if i = 0 then 1 else if i = 1 then 2 else 0

@[simp] theorem cycleIndex_zero : cycleIndex 0 = 1 := by decide
@[simp] theorem cycleIndex_one : cycleIndex 1 = 2 := by decide
@[simp] theorem cycleIndex_two : cycleIndex 2 = 0 := by decide

/-- Three cyclic relabelings return every Cartesian index to itself.
Proved where the defining equation of cycleIndex is available. -/
theorem cycleIndex_three (i : Fin 3) :
    cycleIndex (cycleIndex (cycleIndex i)) = i := by
  fin_cases i <;> decide

/-- Cyclic coordinate rotation from (X,Y,Z) to (Y,Z,X). -/
def cycleVec (x : Vec3) : Vec3 := ![x 1, x 2, x 0]

@[simp] theorem cycleVec_zero (x : Vec3) : cycleVec x 0 = x 1 := by rfl
@[simp] theorem cycleVec_one (x : Vec3) : cycleVec x 1 = x 2 := by rfl
@[simp] theorem cycleVec_two (x : Vec3) : cycleVec x 2 = x 0 := by rfl

/-- The Euclidean source radius is invariant under cyclic relabeling. -/
theorem euclideanRadius_cycleVec (x : Vec3) :
    euclideanRadius (cycleVec x) = euclideanRadius x := by
  rw [euclideanRadius_eq_coordinates (cycleVec x),
    euclideanRadius_eq_coordinates x]
  simp only [cycleVec_zero, cycleVec_one, cycleVec_two]
  congr 1
  ring

/-- An exact entry is carried to the corresponding row and column
under a cyclic relabeling of the Cartesian coordinate axes. -/
theorem newtonianJacobianMatrix_cycle_entry
    (μ : ℝ) (x : Vec3) (i j : Fin 3) :
    newtonianJacobianMatrix μ (cycleVec x) i j =
      newtonianJacobianMatrix μ x (cycleIndex i) (cycleIndex j) := by
  rw [newtonianJacobianMatrix_entry μ (cycleVec x) i j,
    newtonianJacobianMatrix_entry μ x (cycleIndex i) (cycleIndex j),
    euclideanRadius_cycleVec]
  fin_cases i <;> fin_cases j <;>
    simp [cycleIndex, cycleVec]

/-- A cyclic permutation merely relabels the absolute row sums. -/
theorem newtonianJacobianMatrix_cycle_rowSum
    (μ : ℝ) (x : Vec3) (i : Fin 3) :
    (∑ j : Fin 3, |newtonianJacobianMatrix μ (cycleVec x) i j|) =
      ∑ j : Fin 3,
        |newtonianJacobianMatrix μ x (cycleIndex i) j| := by
  simp only [Fin.sum_univ_three,
    newtonianJacobianMatrix_cycle_entry,
    cycleIndex_zero, cycleIndex_one, cycleIndex_two]
  abel

/-- Swap the Y and Z axes, leaving X unchanged. -/
def swapYZIndex (i : Fin 3) : Fin 3 :=
  if i = 0 then 0 else if i = 1 then 2 else 1

@[simp] theorem swapYZIndex_zero : swapYZIndex 0 = 0 := by decide
@[simp] theorem swapYZIndex_one : swapYZIndex 1 = 2 := by decide
@[simp] theorem swapYZIndex_two : swapYZIndex 2 = 1 := by decide

/-- Apply the Y/Z transposition to a physical Cartesian displacement. -/
def swapYZVec (x : Vec3) : Vec3 := ![x 0, x 2, x 1]

@[simp] theorem swapYZVec_zero (x : Vec3) : swapYZVec x 0 = x 0 := by rfl
@[simp] theorem swapYZVec_one (x : Vec3) : swapYZVec x 1 = x 2 := by rfl
@[simp] theorem swapYZVec_two (x : Vec3) : swapYZVec x 2 = x 1 := by rfl

/-- The physical source radius is invariant under swapping Y and Z. -/
theorem euclideanRadius_swapYZVec (x : Vec3) :
    euclideanRadius (swapYZVec x) = euclideanRadius x := by
  rw [euclideanRadius_eq_coordinates (swapYZVec x),
    euclideanRadius_eq_coordinates x]
  simp only [swapYZVec_zero, swapYZVec_one, swapYZVec_two]
  congr 1
  ring

/-- The actual Newtonian Jacobian entries transform exactly
under a Y/Z axis transposition. -/
theorem newtonianJacobianMatrix_swapYZ_entry
    (μ : ℝ) (x : Vec3) (i j : Fin 3) :
    newtonianJacobianMatrix μ (swapYZVec x) i j =
      newtonianJacobianMatrix μ x (swapYZIndex i) (swapYZIndex j) := by
  rw [newtonianJacobianMatrix_entry μ (swapYZVec x) i j,
    newtonianJacobianMatrix_entry μ x (swapYZIndex i) (swapYZIndex j),
    euclideanRadius_swapYZVec]
  fin_cases i <;> fin_cases j <;>
    simp [swapYZIndex, swapYZVec]

/-- The sum of absolute matrix entries in each row is unchanged
up to relabeling when Y and Z are interchanged. -/
theorem newtonianJacobianMatrix_swapYZ_rowSum
    (μ : ℝ) (x : Vec3) (i : Fin 3) :
    (∑ j : Fin 3, |newtonianJacobianMatrix μ (swapYZVec x) i j|) =
      ∑ j : Fin 3,
        |newtonianJacobianMatrix μ x (swapYZIndex i) j| := by
  simp only [Fin.sum_univ_three,
    newtonianJacobianMatrix_swapYZ_entry,
    swapYZIndex_zero, swapYZIndex_one, swapYZIndex_two]
  abel

end NewtonianLipschitz
