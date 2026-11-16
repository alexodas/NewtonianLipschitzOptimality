module

public import Mathlib

public section

/-!
# Candidate stationary polynomial and coefficient function

These are exact definitions for a research problem; no assertion of
critical-point uniqueness, maximality, or sharp Lipschitz regularity
has yet been proved.
-/

namespace NewtonianLipschitz

/-- Cubic equation associated with the candidate stationary point. -/
def stationaryCubic (y : ℝ) : ℝ :=
  2 * y ^ 3 - 8 * y ^ 2 - 4 * y + 1

/-- Dimensionless candidate coefficient as an exact real expression. -/
noncomputable def candidateCoefficient (y : ℝ) : ℝ :=
  (2 + 6 * y - 2 * y ^ 2) / (Real.sqrt (1 + 2 * y ^ 2)) ^ 5

end NewtonianLipschitz
