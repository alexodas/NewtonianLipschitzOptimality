module

public import NewtonianLipschitz.PhysicalTangentialNormalized

public section

/-!
# Tangential derivative with arbitrary signs and first-axis clearance

R044 established the genuine 5/4 Newtonian derivative bound at
normalized points (1,u,v), u,v>=0. This module transfers that
physical estimate to arbitrary signed positions with |x0|>=d>0,
using previously verified sign invariance and positive rescaling
of every actual Jacobian entry.

The other safe coordinate axes and the integration to two-point
safe-plane estimates are separate obligations. No unrestricted
global nonconvex estimate is asserted in this file.
-/

open Matrix

namespace NewtonianLipschitz

/-- For arbitrary signed x whose first Cartesian coordinate
is at least d in magnitude, the ACTUAL Newtonian Jacobian's
two tangent columns have restricted absolute row sum at
most (5/4)*μ/d³. -/
theorem newtonianJacobianMatrix_first_safe_axis_tangent_columns_le
    (μ d : ℝ) (x : Vec3) (k : Fin 3)
    (hμ : 0 ≤ μ) (hd : 0 < d) (hx : d ≤ |x 0|) :
    |newtonianJacobianMatrix μ x k 1| +
        |newtonianJacobianMatrix μ x k 2| ≤
      (1 / d ^ 3) * (μ * (5 / 4 : ℝ)) := by
  let z : Vec3 := coordinateAbs x
  have hzi (i : Fin 3) : z i = |x i| := by
    exact coordinateAbs_apply x i
  have hza : d ≤ z 0 := by
    rwa [hzi]
  have ha : 0 < z 0 := lt_of_lt_of_le hd hza
  let u : ℝ := z 1 / z 0
  let v : ℝ := z 2 / z 0
  have hu : 0 ≤ u :=
    div_nonneg (by rw [hzi]; exact abs_nonneg _) ha.le
  have hv : 0 ≤ v :=
    div_nonneg (by rw [hzi]; exact abs_nonneg _) ha.le
  have hnormal :
      (z 0) • normalizedVector u v = z := by
    exact positive_first_coordinate_normalization z ha
  have hz_nonzero : normalizedVector u v ≠ 0 := by
    intro hz
    have h := congrArg (fun q : Vec3 => q 0) hz
    simp only [normalizedVector_zero, Pi.zero_apply] at h
    norm_num at h
  have hfactor : 0 ≤ (1 : ℝ) / (z 0) ^ 3 := by
    positivity
  have hinv : (1 : ℝ) / (z 0) ^ 3 ≤ 1 / d ^ 3 := by
    have hpow : d ^ 3 ≤ (z 0) ^ 3 :=
      pow_le_pow_left₀ hd.le hza 3
    apply (div_le_div_iff₀ (pow_pos ha 3) (pow_pos hd 3)).2
    simpa only [one_mul] using hpow
  have hentry (j : Fin 3) :
      |newtonianJacobianMatrix μ x k j| =
        (1 / (z 0) ^ 3) *
          |newtonianJacobianMatrix μ (normalizedVector u v) k j| := by
    calc
      |newtonianJacobianMatrix μ x k j| =
          |newtonianJacobianMatrix μ z k j| := by
        exact (newtonianJacobianMatrix_entry_abs_coordinateAbs μ x k j).symm
      _ = |newtonianJacobianMatrix μ
              ((z 0) • normalizedVector u v) k j| := by
        rw [hnormal]
      _ = |(1 / (z 0) ^ 3) *
              newtonianJacobianMatrix μ (normalizedVector u v) k j| := by
        rw [newtonianJacobianMatrix_entry_positive_smul
          μ (z 0) (normalizedVector u v) k j ha hz_nonzero]
      _ = (1 / (z 0) ^ 3) *
            |newtonianJacobianMatrix μ (normalizedVector u v) k j| := by
        rw [abs_mul, abs_of_nonneg hfactor]
  have hnormbound :
      |newtonianJacobianMatrix μ (normalizedVector u v) k 1| +
        |newtonianJacobianMatrix μ (normalizedVector u v) k 2| ≤
          μ * (5 / 4 : ℝ) :=
    newtonianJacobianMatrix_normalized_tangent_columns_le
      μ u v hμ hu hv k
  calc
    |newtonianJacobianMatrix μ x k 1| +
        |newtonianJacobianMatrix μ x k 2| =
          (1 / (z 0) ^ 3) *
            (|newtonianJacobianMatrix μ (normalizedVector u v) k 1| +
              |newtonianJacobianMatrix μ (normalizedVector u v) k 2|) := by
      rw [hentry 1, hentry 2]
      ring
    _ ≤ (1 / (z 0) ^ 3) * (μ * (5 / 4 : ℝ)) :=
      mul_le_mul_of_nonneg_left hnormbound hfactor
    _ ≤ (1 / d ^ 3) * (μ * (5 / 4 : ℝ)) :=
      mul_le_mul_of_nonneg_right hinv
        (mul_nonneg hμ (by norm_num))

/-- The true Newtonian Frechet derivative has 5/4
tangential directional factor under arbitrary signs and
positive Cartesian clearance on the first coordinate.
The physical Euclidean denominator is unchanged. -/
theorem NewtonianPointSource.accelerationField_fderiv_first_safe_axis_tangent_le
    (c : NewtonianPointSource) (x h : Vec3) (d : ℝ)
    (hd : 0 < d) (hx : d ≤ |x 0|) (hh : h 0 = 0) :
    ‖(fderiv ℝ c.accelerationField x) h‖ ≤
      ((1 / d ^ 3) *
        (c.gravitationalParameter * (5 / 4 : ℝ))) * ‖h‖ := by
  have hx_ne : x ≠ 0 := by
    intro hz
    have hz0 := congrArg (fun q : Vec3 => q 0) hz
    simp only [Pi.zero_apply] at hz0
    rw [hz0, abs_zero] at hx
    linarith
  rw [c.accelerationField_fderiv_eq_jacobianMatrix x h hx_ne]
  exact matrix3_mulVec_tangent_zero_norm_le
    (newtonianJacobianMatrix c.gravitationalParameter x) h hh
    ((1 / d ^ 3) * (c.gravitationalParameter * (5 / 4 : ℝ)))
    (mul_nonneg (by positivity)
      (mul_nonneg c.gravitationalParameter_nonneg (by norm_num)))
    (fun k =>
      newtonianJacobianMatrix_first_safe_axis_tangent_columns_le
        c.gravitationalParameter d x k
        c.gravitationalParameter_nonneg hd hx)

end NewtonianLipschitz
