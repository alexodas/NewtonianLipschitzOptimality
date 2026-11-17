module

public import NewtonianLipschitz.CrossFaceTwoHop

public section

/-!
# Exact algebraic certificates for safe-plane directional estimates

This file isolates the rational, radical-free inequalities behind a
proposed 5/4 upper bound on the Newtonian derivative in directions
tangent to a safe coordinate plane. These results are about scalar
numerators and their denominators; the transfer to the physical
Jacobian, and the desired nonconvex global bound, are separate
proof obligations.

It also certifies that the previously proved exact scalar maximum
C3 is strictly larger than 5/2. No decimal approximation is used.
-/

namespace NewtonianLipschitz

/-- An explicit sum-of-nonnegative-terms certificate for the
radial denominator inequality, valid without upper bounds on t. -/
theorem tangential_denominator_fifth_power_ge_twelve
    (t : ℝ) (ht : 0 ≤ t) :
    12 * t ≤ (1 + t) ^ 5 := by
  have hidentity :
      (1 + t) ^ 5 - 12 * t =
        (1 - 4 * t) ^ 2 +
          t * (1 - 3 * t) ^ 2 +
          t ^ 3 + 5 * t ^ 4 + t ^ 5 := by
    ring
  have hnonneg :
      0 ≤ (1 - 4 * t) ^ 2 +
        t * (1 - 3 * t) ^ 2 +
        t ^ 3 + 5 * t ^ 4 + t ^ 5 := by
    positivity
  linarith

/-- The first tangential row numerator is below the 5/4
coefficient after squaring the positive radial denominator.
The variables u,v represent normalized absolute coordinates. -/
theorem tangential_first_row_squared_le_five_four
    (u v t : ℝ) (ht : t = u ^ 2 + v ^ 2) :
    (3 * (u + v)) ^ 2 ≤
      ((5 / 4 : ℝ) ^ 2) * (1 + t) ^ 5 := by
  have ht0 : 0 ≤ t := by
    rw [ht]
    positivity
  have hcs : (u + v) ^ 2 ≤ 2 * t := by
    rw [ht]
    nlinarith [sq_nonneg (u - v)]
  have hfirst : (3 * (u + v)) ^ 2 ≤ 18 * t := by
    nlinarith [hcs]
  have hradial := tangential_denominator_fifth_power_ge_twelve t ht0
  have hsecond :
      18 * t ≤ ((5 / 4 : ℝ) ^ 2) * (1 + t) ^ 5 := by
    nlinarith [hradial, ht0]
  exact hfirst.trans hsecond

/-- Each lateral tangential row numerator obeys a simpler
quadratic bound, with no restriction u,v ≤ 1.
This is the second scalar ingredient for a 5/4 safe-plane
derivative estimate. -/
theorem tangential_lateral_row_le_five_four_quadratic
    (u v : ℝ) (hu : 0 ≤ u) (hv : 0 ≤ v) :
    |2 * u ^ 2 - 1 - v ^ 2| + 3 * u * v ≤
      (5 / 4 : ℝ) * (1 + u ^ 2 + v ^ 2) ^ 2 := by
  let t : ℝ := u ^ 2 + v ^ 2
  have h_abs :
      |2 * u ^ 2 - 1 - v ^ 2| ≤
        1 + 2 * u ^ 2 + v ^ 2 := by
    apply abs_le.mpr
    constructor <;> nlinarith [sq_nonneg u, sq_nonneg v]
  have h_product : 3 * u * v ≤ (3 / 2 : ℝ) * t := by
    dsimp [t]
    nlinarith [sq_nonneg (u - v)]
  have h_base :
      1 + 2 * u ^ 2 + v ^ 2 ≤ 1 + 2 * t := by
    dsimp [t]
    nlinarith [sq_nonneg v]
  have h_quadratic :
      1 + (7 / 2 : ℝ) * t ≤ (5 / 4 : ℝ) * (1 + t) ^ 2 := by
    nlinarith [sq_nonneg (5 * t - 2)]
  calc
    |2 * u ^ 2 - 1 - v ^ 2| + 3 * u * v
        ≤ (1 + 2 * u ^ 2 + v ^ 2) + 3 * u * v :=
          add_le_add h_abs le_rfl
    _ ≤ (1 + 2 * t) + (3 / 2 : ℝ) * t :=
          add_le_add h_base h_product
    _ = 1 + (7 / 2 : ℝ) * t := by ring
    _ ≤ (5 / 4 : ℝ) * (1 + t) ^ 2 := h_quadratic
    _ = (5 / 4 : ℝ) * (1 + u ^ 2 + v ^ 2) ^ 2 := by
      rw [show t = u ^ 2 + v ^ 2 from rfl]
      ring

/-- Exact rational separation between the sharp local
Newtonian coefficient and the two-hop 5/4+5/4 estimate.
The comparison is independent of the approximate decimal C3. -/
theorem candidateMaximum_gt_five_halves :
    (5 / 2 : ℝ) < candidateMaximum := by
  let r : ℝ := Real.sqrt ((27 : ℝ) / 25)
  have hrpos : 0 < r := by
    dsimp [r]
    exact Real.sqrt_pos.mpr (by norm_num)
  have hrsq : r ^ 2 = (27 : ℝ) / 25 := by
    dsimp [r]
    exact Real.sq_sqrt (by norm_num)
  have hrupper : r ≤ (26 : ℝ) / 25 := by
    nlinarith [hrsq]
  have hrpow : r ^ 5 ≤ ((26 : ℝ) / 25) ^ 5 :=
    pow_le_pow_left₀ hrpos.le hrupper 5
  have hnumeric :
      (5 / 2 : ℝ) * r ^ 5 < (78 : ℝ) / 25 := by
    have hrprod :
        (5 / 2 : ℝ) * r ^ 5 ≤
          (5 / 2 : ℝ) * ((26 : ℝ) / 25) ^ 5 :=
      mul_le_mul_of_nonneg_left hrpow (by norm_num)
    have hrconst :
        (5 / 2 : ℝ) * ((26 : ℝ) / 25) ^ 5 <
          (78 : ℝ) / 25 := by norm_num
    exact lt_of_le_of_lt hrprod hrconst
  have heval :
      candidateCoefficient (1 / 5 : ℝ) =
        ((78 : ℝ) / 25) / r ^ 5 := by
    rw [candidateCoefficient_eq]
    have hinside :
        1 + 2 * (1 / 5 : ℝ) ^ 2 = (27 : ℝ) / 25 := by
      norm_num
    rw [hinside]
    change (2 + 6 * (1 / 5 : ℝ) - 2 * (1 / 5 : ℝ) ^ 2) /
        r ^ 5 = ((78 : ℝ) / 25) / r ^ 5
    congr 1
    norm_num
  have hone :
      (5 / 2 : ℝ) < candidateCoefficient (1 / 5 : ℝ) := by
    rw [heval]
    exact (lt_div_iff₀ (pow_pos hrpos 5)).2 hnumeric
  have hmax :
      candidateCoefficient (1 / 5 : ℝ) ≤ candidateMaximum := by
    rw [candidateMaximum_eq]
    exact candidateCoefficient_le_at_criticalPoint (1 / 5 : ℝ)
      ⟨by norm_num, by norm_num⟩
  exact hone.trans_le hmax

end NewtonianLipschitz
