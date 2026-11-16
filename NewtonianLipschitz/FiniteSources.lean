module

public import NewtonianLipschitz.Field

public section

/-!
# Finite exact Newtonian differential-force sums

These algebraic definitions are independent of time evolution,
dynamical initial conditions and scenario modeling assumptions.
-/

namespace NewtonianLipschitz

noncomputable def NewtonianPointSource.finiteDifferentialAcceleration
    (sources : List (ℝ → NewtonianPointSource)) (t : ℝ) (q : Vec3) : Vec3 :=
  (sources.map (fun source =>
    (source t).exactDifferentialAcceleration q)).sum

@[simp] theorem NewtonianPointSource.finiteDifferentialAcceleration_nil
    (t : ℝ) (q : Vec3) :
    NewtonianPointSource.finiteDifferentialAcceleration [] t q = 0 := by
  simp [NewtonianPointSource.finiteDifferentialAcceleration]

@[simp] theorem NewtonianPointSource.finiteDifferentialAcceleration_cons
    (source : ℝ → NewtonianPointSource)
    (sources : List (ℝ → NewtonianPointSource)) (t : ℝ) (q : Vec3) :
    NewtonianPointSource.finiteDifferentialAcceleration (source :: sources) t q =
      (source t).exactDifferentialAcceleration q +
        NewtonianPointSource.finiteDifferentialAcceleration sources t q := by
  simp [NewtonianPointSource.finiteDifferentialAcceleration]

end NewtonianLipschitz
