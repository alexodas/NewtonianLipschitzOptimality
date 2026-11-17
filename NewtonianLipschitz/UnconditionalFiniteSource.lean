module

public import NewtonianLipschitz.SafePlaneFiniteDifference

public section

/-!
# Exact one-source optimality and unconditional finite-source estimates

R047 proved the global C3 bound for one exact Newtonian point source
outside the nonconvex Cartesian cube. R037 independently proved that
every universal admissible two-point coefficient for the unit source
must be at least C3.

This module closes their logical loop with a sharp "if and only if"
for the unit source, and discharges R041's explicit one-source premise,
obtaining unconditional upper bounds for finite sums of exact nonlinear
differential accelerations. The physical source-position and mass
parameter interface of the planned Comparator theorem is separate.
-/

namespace NewtonianLipschitz

/-- Exact global optimality for one unit Newtonian source.
A real coefficient K controls every pair of unit-cube-safe endpoints
if and only if K is at least the exact coefficient C3. -/
theorem unitSource_safe_global_bound_iff_candidateMaximum_le
    (K : ℝ) :
    (∀ x y : Vec3,
      (1 : ℝ) ≤ ‖x‖ →
      (1 : ℝ) ≤ ‖y‖ →
      ‖NewtonianPointSource.unitAxis.accelerationField x -
        NewtonianPointSource.unitAxis.accelerationField y‖ ≤
          K * ‖x - y‖) ↔ candidateMaximum ≤ K := by
  constructor
  · exact candidateMaximum_le_of_universal_safe_secant_bound K
  · intro hCK x y hx hy
    have hglobal :=
      oneSourceGlobalCandidateBound_proved
        NewtonianPointSource.unitAxis x y 1
        (by norm_num) hx hy
    have hsharp :
        ‖NewtonianPointSource.unitAxis.accelerationField x -
          NewtonianPointSource.unitAxis.accelerationField y‖ ≤
            candidateMaximum * ‖x - y‖ := by
      simpa only [NewtonianPointSource.unitAxis_gravitationalParameter_eq_one,
        one_pow, div_one, one_mul] using hglobal
    exact hsharp.trans
      (mul_le_mul_of_nonneg_right hCK (norm_nonneg _))

/-- Unconditional finite-source bound using the SUM of actual
nonnegative gravitational parameters at time t. The source
accelerations are exact nonlinear force differences. -/
theorem NewtonianPointSource.finiteDifferentialAcceleration_norm_le_sum_global
    (sources : List (ℝ → NewtonianPointSource))
    (t : ℝ) (q : Vec3) (d : ℝ) (hd : 0 < d)
    (hsafe : ∀ source ∈ sources,
      d ≤ ‖(source t).displacement‖ ∧
      d ≤ ‖(source t).displacement + q‖) :
    ‖NewtonianPointSource.finiteDifferentialAcceleration sources t q‖ ≤
      ((1 / d ^ 3) *
        ((sources.map (fun source =>
          (source t).gravitationalParameter)).sum * candidateMaximum)) *
        ‖q‖ :=
  NewtonianPointSource.finiteDifferentialAcceleration_norm_le_of_oneSourceGlobal
    oneSourceGlobalCandidateBound_proved sources t q d hd hsafe

/-- Unconditional finite-source N*M*C3/d³ inequality for the
true sum of Newtonian differential accelerations, without an
extra global one-source hypothesis. M bounds each actual source
gravitational parameter at the observation time. -/
theorem NewtonianPointSource.finiteDifferentialAcceleration_norm_le_length_mul_global
    (sources : List (ℝ → NewtonianPointSource))
    (t : ℝ) (q : Vec3) (d M : ℝ) (hd : 0 < d)
    (hsafe : ∀ source ∈ sources,
      d ≤ ‖(source t).displacement‖ ∧
      d ≤ ‖(source t).displacement + q‖)
    (hcap : ∀ source ∈ sources,
      (source t).gravitationalParameter ≤ M) :
    ‖NewtonianPointSource.finiteDifferentialAcceleration sources t q‖ ≤
      ((1 / d ^ 3) *
        (((sources.length : ℝ) * M) * candidateMaximum)) * ‖q‖ :=
  NewtonianPointSource.finiteDifferentialAcceleration_norm_le_length_mul_of_oneSourceGlobal
    oneSourceGlobalCandidateBound_proved sources t q d M hd hsafe hcap

end NewtonianLipschitz
