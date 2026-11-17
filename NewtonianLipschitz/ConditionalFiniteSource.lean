module

public import NewtonianLipschitz.CrossFaceTwoHop
public import NewtonianLipschitz.FiniteSources

public section

/-!
# Conditional single-source to finite-source Palomar reduction

The missing mathematical problem is the global C3 two-point
estimate for one Newtonian point source outside a nonconvex
safety cube. We encode that statement as a *proposition*,
not as a theorem or an assumption that is silently considered true.

R041 proves that **if** this remaining single-source
statement is eventually established, its exact finite-source
extension follows for the existing physical differential-force
sum. The total coefficient is the sum of the nonnegative
gravitational parameters, and it is at most N times a
uniform source cap.

No new assertion of the global single-source C3 estimate is
made here. The unproved one-source proposition is explicitly
an assumption of every conditional result below.
-/

namespace NewtonianLipschitz

/-- The still-open sharp global two-point bound for one source.
This is a *proposition*, not a proved assertion. It is stated
for every positive Cartesian clearance, and the connecting
segment need not avoid the forbidden cube. -/
abbrev oneSourceGlobalCandidateBound : Prop :=
  ∀ (c : NewtonianPointSource) (x y : Vec3) (d : ℝ),
    0 < d → d ≤ ‖x‖ → d ≤ ‖y‖ →
      ‖c.accelerationField x - c.accelerationField y‖ ≤
        ((1 / d ^ 3) *
          (c.gravitationalParameter * candidateMaximum)) * ‖x - y‖

/-- R041, part 1: a proof of the global one-source C3
estimate would automatically imply a bound for the exact
finite sum of nonlinear differential accelerations.

A source at time t has initial displacement c.displacement;
the second position has displacement c.displacement + q.
Both are assumed to satisfy the same Cartesian clearance d.
The bound uses the sum of actual gravitational parameters,
with no artificial linearization and no segment assumption. -/
theorem NewtonianPointSource.finiteDifferentialAcceleration_norm_le_of_oneSourceGlobal
    (hOne : oneSourceGlobalCandidateBound)
    (sources : List (ℝ → NewtonianPointSource))
    (t : ℝ) (q : Vec3) (d : ℝ) (hd : 0 < d) :
    (∀ source ∈ sources,
      d ≤ ‖(source t).displacement‖ ∧
      d ≤ ‖(source t).displacement + q‖) →
    ‖NewtonianPointSource.finiteDifferentialAcceleration sources t q‖ ≤
      ((1 / d ^ 3) *
        ((sources.map (fun source =>
          (source t).gravitationalParameter)).sum * candidateMaximum)) *
        ‖q‖ := by
  induction sources with
  | nil =>
      intro _
      simp [NewtonianPointSource.finiteDifferentialAcceleration]
  | cons source rest ih =>
      intro hsafe
      have hheadsafe :
          d ≤ ‖(source t).displacement‖ ∧
            d ≤ ‖(source t).displacement + q‖ :=
        hsafe source (by simp)
      have hrestsafe :
          ∀ s ∈ rest,
            d ≤ ‖(s t).displacement‖ ∧
              d ≤ ‖(s t).displacement + q‖ := by
        intro s hs
        exact hsafe s (by simp [hs])
      have hhead :
          ‖(source t).exactDifferentialAcceleration q‖ ≤
            ((1 / d ^ 3) *
              ((source t).gravitationalParameter * candidateMaximum)) *
                ‖q‖ := by
        rw [(source t).exactDifferentialAcceleration_eq_sub]
        simpa only [add_sub_cancel_left] using
          (hOne (source t)
            ((source t).displacement + q)
            (source t).displacement d hd hheadsafe.2 hheadsafe.1)
      have htail := ih hrestsafe
      calc
        ‖NewtonianPointSource.finiteDifferentialAcceleration
            (source :: rest) t q‖ =
          ‖(source t).exactDifferentialAcceleration q +
            NewtonianPointSource.finiteDifferentialAcceleration rest t q‖ := by
          rw [NewtonianPointSource.finiteDifferentialAcceleration_cons]
        _ ≤ ‖(source t).exactDifferentialAcceleration q‖ +
              ‖NewtonianPointSource.finiteDifferentialAcceleration rest t q‖ :=
          norm_add_le _ _
        _ ≤ ((1 / d ^ 3) *
              ((source t).gravitationalParameter * candidateMaximum)) * ‖q‖ +
            ((1 / d ^ 3) *
              ((rest.map (fun s =>
                (s t).gravitationalParameter)).sum * candidateMaximum)) * ‖q‖ :=
          add_le_add hhead htail
        _ = ((1 / d ^ 3) *
              (((source :: rest).map (fun s =>
                (s t).gravitationalParameter)).sum * candidateMaximum)) *
                ‖q‖ := by
          simp only [List.map_cons, List.sum_cons]
          ring

/-- Elementary finite-list cap on the sum of physical
gravitational parameters: each parameter at most M
implies total parameter at most N*M. -/
theorem sourceGravitationalParameter_sum_le_length_mul
    (sources : List (ℝ → NewtonianPointSource))
    (t M : ℝ) :
    (∀ source ∈ sources,
      (source t).gravitationalParameter ≤ M) →
    (sources.map (fun source =>
      (source t).gravitationalParameter)).sum ≤
        (sources.length : ℝ) * M := by
  induction sources with
  | nil =>
      intro _
      simp
  | cons source rest ih =>
      intro hcap
      have hhead : (source t).gravitationalParameter ≤ M :=
        hcap source (by simp)
      have hrest :
          ∀ s ∈ rest, (s t).gravitationalParameter ≤ M := by
        intro s hs
        exact hcap s (by simp [hs])
      have htail := ih hrest
      simp only [List.map_cons, List.sum_cons, List.length_cons,
        Nat.cast_succ] at *
      nlinarith

/-- R041, part 2: once the one-source global sharp estimate
is proved, N point sources with parameters at most M have
the sought N*M*C3/d³ coefficient for the exact sum.
This theorem is CONDITIONAL on hOne; it does not prove hOne. -/
theorem NewtonianPointSource.finiteDifferentialAcceleration_norm_le_length_mul_of_oneSourceGlobal
    (hOne : oneSourceGlobalCandidateBound)
    (sources : List (ℝ → NewtonianPointSource))
    (t : ℝ) (q : Vec3) (d M : ℝ) (hd : 0 < d)
    (hsafe : ∀ source ∈ sources,
      d ≤ ‖(source t).displacement‖ ∧
      d ≤ ‖(source t).displacement + q‖)
    (hcap : ∀ source ∈ sources,
      (source t).gravitationalParameter ≤ M) :
    ‖NewtonianPointSource.finiteDifferentialAcceleration sources t q‖ ≤
      ((1 / d ^ 3) *
        (((sources.length : ℝ) * M) * candidateMaximum)) * ‖q‖ := by
  have hfinite :=
    NewtonianPointSource.finiteDifferentialAcceleration_norm_le_of_oneSourceGlobal
      hOne sources t q d hd hsafe
  have hmass :=
    sourceGravitationalParameter_sum_le_length_mul sources t M hcap
  have hmul :
      ((sources.map (fun source =>
        (source t).gravitationalParameter)).sum * candidateMaximum) ≤
        ((sources.length : ℝ) * M) * candidateMaximum :=
    mul_le_mul_of_nonneg_right hmass candidateMaximum_nonneg
  have hcoef :
      ((1 / d ^ 3) *
        ((sources.map (fun source =>
          (source t).gravitationalParameter)).sum * candidateMaximum)) ≤
        ((1 / d ^ 3) *
          (((sources.length : ℝ) * M) * candidateMaximum)) :=
    mul_le_mul_of_nonneg_left hmul (by positivity)
  exact hfinite.trans
    (mul_le_mul_of_nonneg_right hcoef (norm_nonneg q))

end NewtonianLipschitz
