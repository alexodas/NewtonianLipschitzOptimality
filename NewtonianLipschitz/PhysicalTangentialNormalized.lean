module

public import NewtonianLipschitz.SafePlaneReduction

public section

/-!
# True Newtonian tangential Jacobian on a normalized safe plane

The algebra in R042 is connected here to entries of the ACTUAL
Newtonian Jacobian. At the normalized point (1,u,v), with u,v>=0,
the two columns corresponding to tangential directions (h0=0)
have maximum absolute row sum bounded by 5*μ/4.

The normalization step to arbitrary signed coordinates, arbitrary
safe axis, and physical clearance d is left for a later theorem.
This module does not yet establish a global nonconvex result.
-/

namespace NewtonianLipschitz

/-- The exact physical Euclidean radius of (1,u,v) is at least
one, and its fifth power controls the square of (1+u²+v²). -/
theorem tangential_normalized_radius_bounds
    (u v : ℝ) :
    let r := euclideanRadius (normalizedVector u v)
    1 ≤ r ∧
      (1 + u ^ 2 + v ^ 2) ^ 2 ≤ r ^ 5 := by
  dsimp
  let r := euclideanRadius (normalizedVector u v)
  have hr0 : 0 ≤ r := by
    dsimp [r]
    rw [euclideanRadius_eq_physical_norm]
    exact norm_nonneg _
  have hsq : r ^ 2 = 1 + u ^ 2 + v ^ 2 :=
    normalizedVector_radius_sq u v
  have hr1 : 1 ≤ r := by
    nlinarith [sq_nonneg u, sq_nonneg v]
  constructor
  · exact hr1
  · have hp : 0 ≤ r ^ 4 * (r - 1) :=
      mul_nonneg (by positivity) (sub_nonneg.mpr hr1)
    have heq : (1 + u ^ 2 + v ^ 2) ^ 2 = r ^ 4 := by
      rw [← hsq]
      ring
    rw [heq]
    nlinarith

/-- The first restricted Jacobian-row numerator is bounded
by 5/4 times the TRUE Euclidean radius to the fifth power.
This is the nonnegative square-root step left implicit in R042. -/
theorem tangential_normalized_first_numerator_le_radius
    (u v : ℝ) (hu : 0 ≤ u) (hv : 0 ≤ v) :
    3 * (u + v) ≤
      (5 / 4 : ℝ) * euclideanRadius (normalizedVector u v) ^ 5 := by
  let r := euclideanRadius (normalizedVector u v)
  have hr1 : 1 ≤ r :=
    (tangential_normalized_radius_bounds u v).1
  have hrpos : 0 < r := lt_of_lt_of_le (by norm_num) hr1
  have hsq : r ^ 2 = 1 + u ^ 2 + v ^ 2 :=
    normalizedVector_radius_sq u v
  have hpower :
      r ^ 10 = (1 + u ^ 2 + v ^ 2) ^ 5 := by
    rw [← hsq]
    ring
  have hbase :=
    tangential_first_row_squared_le_five_four
      u v (u ^ 2 + v ^ 2) rfl
  have hsqbound :
      (3 * (u + v)) ^ 2 ≤
        ((5 / 4 : ℝ) * r ^ 5) ^ 2 := by
    calc
      (3 * (u + v)) ^ 2 ≤
          ((5 / 4 : ℝ) ^ 2) *
            (1 + (u ^ 2 + v ^ 2)) ^ 5 := hbase
      _ = ((5 / 4 : ℝ) * r ^ 5) ^ 2 := by
        rw [show 1 + (u ^ 2 + v ^ 2) =
          1 + u ^ 2 + v ^ 2 by ring, ← hpower]
        ring
  have hfirst : 0 ≤ 3 * (u + v) := by positivity
  have hsecond : 0 < (5 / 4 : ℝ) * r ^ 5 := by positivity
  by_contra hnot
  have hstrict : (5 / 4 : ℝ) * r ^ 5 < 3 * (u + v) :=
    lt_of_not_ge hnot
  have hprod :
      0 < (3 * (u + v) - (5 / 4 : ℝ) * r ^ 5) *
        (3 * (u + v) + (5 / 4 : ℝ) * r ^ 5) :=
    mul_pos (sub_pos.mpr hstrict) (by linarith)
  nlinarith

/-- The second or third restricted Jacobian-row numerator
is bounded by the fifth power of the true physical radius. -/
theorem tangential_normalized_lateral_numerator_le_radius
    (u v : ℝ) (hu : 0 ≤ u) (hv : 0 ≤ v) :
    |2 * u ^ 2 - 1 - v ^ 2| + 3 * u * v ≤
      (5 / 4 : ℝ) * euclideanRadius (normalizedVector u v) ^ 5 := by
  have hquad :=
    (tangential_normalized_radius_bounds u v).2
  have hnum :=
    tangential_lateral_row_le_five_four_quadratic u v hu hv
  calc
    |2 * u ^ 2 - 1 - v ^ 2| + 3 * u * v ≤
        (5 / 4 : ℝ) * (1 + u ^ 2 + v ^ 2) ^ 2 := hnum
    _ ≤ (5 / 4 : ℝ) *
          euclideanRadius (normalizedVector u v) ^ 5 :=
      mul_le_mul_of_nonneg_left hquad (by norm_num)

/-- The two tangent columns of the true Newtonian 3D Jacobian
have total absolute row sum at most 5*μ/4, even if u,v>1.
This is a physical matrix estimate, not just polynomial algebra. -/
theorem newtonianJacobianMatrix_normalized_tangent_columns_le
    (μ u v : ℝ) (hμ : 0 ≤ μ)
    (hu : 0 ≤ u) (hv : 0 ≤ v) (k : Fin 3) :
    |newtonianJacobianMatrix μ (normalizedVector u v) k 1| +
      |newtonianJacobianMatrix μ (normalizedVector u v) k 2| ≤
        μ * (5 / 4 : ℝ) := by
  let r := euclideanRadius (normalizedVector u v)
  have hr1 : 1 ≤ r :=
    (tangential_normalized_radius_bounds u v).1
  have hrpos : 0 < r := lt_of_lt_of_le (by norm_num) hr1
  have hK : 0 ≤ μ / r ^ 5 := by
    exact div_nonneg hμ (pow_nonneg hrpos.le _)
  have hcancel :
      (μ / r ^ 5) * ((5 / 4 : ℝ) * r ^ 5) =
        μ * (5 / 4 : ℝ) := by
    field_simp [ne_of_gt hrpos] <;> ring
  fin_cases k
  · have hrow :
        |newtonianJacobianMatrix μ (normalizedVector u v) 0 1| +
          |newtonianJacobianMatrix μ (normalizedVector u v) 0 2| =
            (μ / r ^ 5) * (3 * (u + v)) := by
      rw [newtonianJacobianMatrix_normalized_zero_one,
        newtonianJacobianMatrix_normalized_zero_two]
      change |(μ / r ^ 5) * (3 * u)| +
          |(μ / r ^ 5) * (3 * v)| =
          (μ / r ^ 5) * (3 * (u + v))
      rw [abs_mul, abs_mul, abs_of_nonneg hK,
        abs_of_nonneg (by positivity : 0 ≤ 3 * u),
        abs_of_nonneg (by positivity : 0 ≤ 3 * v)]
      ring
    calc
      _ = (μ / r ^ 5) * (3 * (u + v)) := hrow
      _ ≤ (μ / r ^ 5) * ((5 / 4 : ℝ) * r ^ 5) :=
        mul_le_mul_of_nonneg_left
          (tangential_normalized_first_numerator_le_radius u v hu hv) hK
      _ = μ * (5 / 4 : ℝ) := hcancel
  · have hrow :
        |newtonianJacobianMatrix μ (normalizedVector u v) 1 1| +
          |newtonianJacobianMatrix μ (normalizedVector u v) 1 2| =
            (μ / r ^ 5) *
              (|2 * u ^ 2 - 1 - v ^ 2| + 3 * u * v) := by
      rw [newtonianJacobianMatrix_normalized_one_one,
        newtonianJacobianMatrix_normalized_one_two]
      change |(μ / r ^ 5) * (2 * u ^ 2 - 1 - v ^ 2)| +
          |(μ / r ^ 5) * (3 * u * v)| =
          (μ / r ^ 5) * (|2 * u ^ 2 - 1 - v ^ 2| + 3 * u * v)
      rw [abs_mul, abs_mul, abs_of_nonneg hK,
        abs_of_nonneg (by positivity : 0 ≤ 3 * u * v)]
      ring
    calc
      _ = (μ / r ^ 5) *
            (|2 * u ^ 2 - 1 - v ^ 2| + 3 * u * v) := hrow
      _ ≤ (μ / r ^ 5) * ((5 / 4 : ℝ) * r ^ 5) :=
        mul_le_mul_of_nonneg_left
          (tangential_normalized_lateral_numerator_le_radius u v hu hv) hK
      _ = μ * (5 / 4 : ℝ) := hcancel
  · have hrow :
        |newtonianJacobianMatrix μ (normalizedVector u v) 2 1| +
          |newtonianJacobianMatrix μ (normalizedVector u v) 2 2| =
            (μ / r ^ 5) *
              (|2 * v ^ 2 - 1 - u ^ 2| + 3 * v * u) := by
      rw [newtonianJacobianMatrix_normalized_two_one,
        newtonianJacobianMatrix_normalized_two_two]
      change |(μ / r ^ 5) * (3 * v * u)| +
          |(μ / r ^ 5) * (2 * v ^ 2 - 1 - u ^ 2)| =
          (μ / r ^ 5) * (|2 * v ^ 2 - 1 - u ^ 2| + 3 * v * u)
      rw [abs_mul, abs_mul, abs_of_nonneg hK,
        abs_of_nonneg (by positivity : 0 ≤ 3 * v * u)]
      ring
    have hlat :
        |2 * v ^ 2 - 1 - u ^ 2| + 3 * v * u ≤
          (5 / 4 : ℝ) * r ^ 5 := by
      have ht :=
        tangential_normalized_lateral_numerator_le_radius v u hv hu
      rw [show euclideanRadius (normalizedVector v u) =
        r by
          dsimp [r]
          rw [euclideanRadius_eq_coordinates,
              euclideanRadius_eq_coordinates]
          simp only [normalizedVector_zero, normalizedVector_one,
            normalizedVector_two]
          congr 1
          ring] at ht
      exact ht
    calc
      _ = (μ / r ^ 5) *
            (|2 * v ^ 2 - 1 - u ^ 2| + 3 * v * u) := hrow
      _ ≤ (μ / r ^ 5) * ((5 / 4 : ℝ) * r ^ 5) :=
        mul_le_mul_of_nonneg_left hlat hK
      _ = μ * (5 / 4 : ℝ) := hcancel

/-- A matrix with small tangent-column row sums acts with the
same bound on every direction whose first coordinate vanishes. -/
theorem matrix3_mulVec_tangent_zero_norm_le
    (A : Matrix (Fin 3) (Fin 3) ℝ) (h : Vec3)
    (hzero : h 0 = 0) (B : ℝ) (hB : 0 ≤ B)
    (hrows : ∀ k : Fin 3, |A k 1| + |A k 2| ≤ B) :
    ‖A *ᵥ h‖ ≤ B * ‖h‖ := by
  apply (pi_norm_le_iff_of_nonneg
    (mul_nonneg hB (norm_nonneg h))).2
  intro k
  have h1 : |h 1| ≤ ‖h‖ := by
    simpa only [Real.norm_eq_abs] using
      (norm_le_pi_norm h (1 : Fin 3))
  have h2 : |h 2| ≤ ‖h‖ := by
    simpa only [Real.norm_eq_abs] using
      (norm_le_pi_norm h (2 : Fin 3))
  have hterm1 : |A k 1 * h 1| ≤ |A k 1| * ‖h‖ := by
    rw [abs_mul]
    exact mul_le_mul_of_nonneg_left h1 (abs_nonneg _)
  have hterm2 : |A k 2 * h 2| ≤ |A k 2| * ‖h‖ := by
    rw [abs_mul]
    exact mul_le_mul_of_nonneg_left h2 (abs_nonneg _)
  have hbound : |(A *ᵥ h) k| ≤ (|A k 1| + |A k 2|) * ‖h‖ := by
    calc
      |(A *ᵥ h) k| = |A k 1 * h 1 + A k 2 * h 2| := by
        simp only [Matrix.mulVec, dotProduct, Fin.sum_univ_three,
          hzero, mul_zero, zero_add]
      _ ≤ |A k 1 * h 1| + |A k 2 * h 2| := abs_add_le _ _
      _ ≤ |A k 1| * ‖h‖ + |A k 2| * ‖h‖ :=
        add_le_add hterm1 hterm2
      _ = (|A k 1| + |A k 2|) * ‖h‖ := by ring
  calc
    ‖(A *ᵥ h) k‖ = |(A *ᵥ h) k| := Real.norm_eq_abs _
    _ ≤ (|A k 1| + |A k 2|) * ‖h‖ := hbound
    _ ≤ B * ‖h‖ := mul_le_mul_of_nonneg_right
      (hrows k) (norm_nonneg h)

/-- The physical Frechet derivative, not a surrogate scalar,
satisfies the 5/4 tangent action estimate at (1,u,v), u,v>=0. -/
theorem NewtonianPointSource.accelerationField_fderiv_normalized_tangent_le
    (c : NewtonianPointSource) (u v : ℝ)
    (hu : 0 ≤ u) (hv : 0 ≤ v)
    (h : Vec3) (hzero : h 0 = 0) :
    ‖(fderiv ℝ c.accelerationField
      (normalizedVector u v)) h‖ ≤
      (c.gravitationalParameter * (5 / 4 : ℝ)) * ‖h‖ := by
  have hx : normalizedVector u v ≠ 0 := by
    intro hzero_vec
    have hz := congrArg (fun z : Vec3 => z 0) hzero_vec
    simp only [normalizedVector_zero, Pi.zero_apply] at hz
    norm_num at hz
  rw [c.accelerationField_fderiv_eq_jacobianMatrix
    (normalizedVector u v) h hx]
  exact matrix3_mulVec_tangent_zero_norm_le
    (newtonianJacobianMatrix c.gravitationalParameter
      (normalizedVector u v)) h hzero
      (c.gravitationalParameter * (5 / 4 : ℝ))
      (mul_nonneg c.gravitationalParameter_nonneg (by norm_num))
      (fun k => newtonianJacobianMatrix_normalized_tangent_columns_le
        c.gravitationalParameter u v
        c.gravitationalParameter_nonneg hu hv k)

end NewtonianLipschitz
