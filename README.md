# NewtonianLipschitzOptimality

**Lean 4 formalization of sharp spatial Lipschitz bounds for the three-dimensional Newtonian point-source gravitational field in the Cartesian supremum norm.**

## Executive summary

The project aims to determine and formally verify the smallest universal Lipschitz coefficient for the exact three-dimensional Newtonian gravitational field under precisely stated noncollision and geometric-separation assumptions, distinguishing local, convex-domain and nonconvex-domain guarantees. **The research is initiated and directed by Alessandro Odasso, who is not a mathematician and is interested in evaluating the capabilities and limitations of large language models (LLMs) in scientific research.** GPT-6 assists with mathematical exploration, Lean formalization and verification infrastructure under his direction.

## Mathematical question

For the exact point-source field `g_μ(x) = -(μ / ‖x‖₂³) • x`, with `μ ≥ 0` and `x ≠ 0`, study the smallest dimensionless coefficient `C` for estimates of the form

```text
‖g_μ(x) - g_μ(y)‖∞ ≤ (C * μ / d³) * ‖x - y‖∞
```

on specified collision-free sets with a **certified Cartesian supremum-norm clearance** `d > 0`. The norm on the left and right is the same supremum norm; the inverse-cube gravitational law uses the physical Euclidean radius.

**Distinct questions must remain distinct:** the largest supremum-norm Jacobian bound, a Lipschitz bound on convex safe regions, an optimal universal coefficient for those regions, and a global Lipschitz coefficient on the nonconvex exterior of a cube are not automatically equivalent. The last question requires its own proof rather than an unjustified line-segment argument.

A current *unverified research candidate* for the pointwise derivative and convex-domain coefficient is `C ≈ 2.5775644212`. This decimal, and its claimed optimality, are **not yet Lean-verified theorems**. The repository must not present either as an established mathematical contribution before both the universal inequality and a matching sharpness example are formally proved.

## Why the result may matter — intended audience

An **optimal, formally checked deterministic sensitivity bound** for the exact Newtonian inverse-cube field, measured in the Cartesian supremum norm, could sharpen the error budgets used by rigorous numerical methods. Its usefulness depends on the *precise geometric clearance and domain assumptions* of the theorem, as well as on how a given application propagates those bounds. The following are **potential research audiences and use cases**, not integrations or certified applications delivered by this repository.

- **Rigorous dynamical systems and interval arithmetic:** developers and users of validated ODE integration, interval enclosures and Taylor models (e.g. CAPD, VNODE-LP, COSY Infinity / Taylor Models), for whom explicit force-sensitivity constants can enter validated propagation estimates. No integration with those libraries has been implemented or tested here.
- **Planetary defense and asteroid impact monitoring:** researchers studying rigorous propagation of orbital and parameter uncertainty through gravitational close approaches. Any application must establish the required positive source separation throughout the relevant region; the proposed theorem alone does not certify an encounter, impact or orbital trajectory.
- **Aerospace engineering and space situational awareness:** analysts of satellite–debris conjunctions and collision risk who may benefit from deterministic bounds in uncertainty propagation. **A Lipschitz constant does not itself certify a collision probability**: statistical uncertainty models, additional forces, trajectory enclosures and independent numerical validation are separate requirements.
- **Cartesian-grid \(N\)-body algorithms:** researchers building rigorously bounded Octree / Barnes–Hut-type approximations, where an explicit force regularity estimate may be one component of a certified error analysis. Tree approximation errors, truncation effects and near-field treatment require additional proofs.

The mathematical coefficient, if ultimately proved optimal, would be optimal **only for the stated norm, clearance and domain class**. The nonconvex global-domain problem is separate. No originality claim or validated improvement in these application areas is made at this stage.

## Results acquired and verification status

The baseline Newtonian library has been **Lean-compiled in [Action #10](https://github.com/alexodas/NewtonianLipschitzOptimality/actions/runs/43980863205)**. Further work toward the sharp coefficient is in review: [Action #11](https://github.com/alexodas/NewtonianLipschitzOptimality/actions/runs/43982849584) failed on one row-comparison elaboration issue, which is corrected in the present branch. **The current branch's new lemmas remain pending a green full-build run.** The repository does not yet prove the candidate optimal coefficient or its sharpness.

Claims are recorded as **proposed**, **Lean-compiled**, **independently kernel-checked**, or **externally reviewed**, with the exact declaration, source and verification evidence. Individual modules may have compiled in an otherwise unsuccessful workflow, but that does **not** qualify the full proposed revision as verified.

## Theorem status ledger

The table records **mathematical declarations**, not inferred results or historical result labels. The source of truth for compilation is a successful full CI run on the relevant commit.

| Exact Lean declaration | Source | Verification / role |
|---|---|---|
| `NewtonianPointSource.accelerationField_fderiv_full` | `NewtonianLipschitz/Derivative.lean` | **Lean-compiled**, Action #10: exact Fréchet derivative of the physical inverse-cube force |
| `NewtonianPointSource.accelerationField_fderiv_norm_le_ten_of_clearance` | `NewtonianLipschitz/BaselineBounds.lean` | **Lean-compiled**, Action #10: conservative coefficient 10, not sharp |
| `NewtonianPointSource.accelerationField_lipschitzOnWith_of_clearance` | `NewtonianLipschitz/ConvexBaseline.lean` | **Lean-compiled**, Action #10: conservative bound on convex noncollision domains |
| `NewtonianPointSource.accelerationField_fderiv_norm_le_seven_of_clearance` | `NewtonianLipschitz/ImprovedBounds.lean` | **Pending complete successful CI**, optional nonoptimal coefficient 7; not on critical path |
| `NewtonianPointSource.accelerationField_lipschitzOnWith_seven` | `NewtonianLipschitz/ConvexImproved.lean` | **Pending complete successful CI**, optional convex-domain improvement |
| `lateralRowNumerator_le_dominant`, `lateralRowNumerator_swapped_le_dominant`, `dominantRowNumerator_le_diagonal` | `NewtonianLipschitz/JacobianRows.lean` | **Pending CI**, algebraic reductions for the sharp Jacobian bound |
| `stationaryCubic_strictAntiOn_unitInterval`, `stationaryCubic_root_unique_on_unitInterval` | `NewtonianLipschitz/CubicCandidate.lean` | **Pending complete successful CI**, analysis of the proposed stationary polynomial |

**Not established:** the exact supremum operator norm, the candidate coefficient as a proved maximum, a matching sharpness witness, a global sharp bound on the nonconvex cube exterior, independent Comparator verification or external peer review.

## Direct proof strategy

The **shortest proof-directed route** is to bound the exact Cartesian
Jacobian in the supremum operator norm. By scaling, signs and coordinate
permutations, normalize a nonzero point to a nonnegative vector
`(1,u,v)` with `0 ≤ u,v ≤ 1`. Next show that the row of the maximal
coordinate dominates, and at fixed `u²+v²` the largest numerator occurs
at `u=v=t`. This reduces the full upper-bound problem to the exact
one-variable function

```text
f(t) = (2 + 6t - 2t²) / (1 + 2t²)^(5/2),    0 ≤ t ≤ 1.
```

Identify its maximum via the stationary cubic
`2t³ - 8t² - 4t + 1 = 0`, then **separately prove sharpness** by producing
admissible configurations whose difference quotients approach the
claimed derivative norm. Apply the exact derivative bound to convex
collision-free domains using the existing mean-value infrastructure.
The nonconvex global-domain question has a distinct geometric obligation.

No further effort on incremental constants such as 7 is a research
milestone unless it directly resolves a dependency of the sharp proof.

## Roadmap

| Milestone | Mathematical / verification obligation | Status |
|---|---|---|
| **M01 — Foundation** | Exact physical field, Fréchet derivative, norm bridges and conservative convex-domain certificate | **Verified in Lean, Action #10** |
| **M02 — Jacobian reduction** | Exact row formula, coordinate/sign symmetry, dominant row and diagonal reduction at fixed radius | **In progress**; partial algebraic lemmas pending CI |
| **M03 — Sharp upper bound** | Prove the maximum of `f(t)`, existence and uniqueness of its critical root, and the resulting sharp universal derivative coefficient | **Open** |
| **M04 — Optimality** | Produce a matching directional derivative / nearby-point witness excluding every smaller coefficient | **Open** |
| **M05 — Domain theorem** | Apply the sharp coefficient on precisely quantified convex safe domains; investigate nonconvex exterior bounds separately | **Open** |
| **M06 — Scientific and archival validation** | Audit theorem ledger, proofs, assumptions, references, novelty, Palomar metadata, standalone Comparator and full CI before merge | **Open** |

**Update rule:** every mathematical PR revision must refresh this table
and the theorem ledger with accurate evidence. Keep the history of
successful verifications, never convert a candidate into an acquired
theorem because its numerical value looks plausible, and review the
entire README before the eventual merge.

## Repository structure and reproducibility

- `NewtonianLipschitz/Basic.lean` — Cartesian coordinates, physical vectors and the Euclidean norm bridge.
- `NewtonianLipschitz/Field.lean` — exact point-source acceleration and differential force.
- `NewtonianLipschitz/Smoothness.lean` — physical and Cartesian differentiability away from collision.
- `NewtonianLipschitz/Norms.lean` — proved norm-conversion inequalities.
- `NewtonianLipschitz/Derivative.lean` — full Fréchet derivative of the exact point-source field.
- `NewtonianLipschitz/Clearance.lean` — explicit geometric anchor-to-clearance lemmas.
- `NewtonianLipschitz/FiniteSources.lean` — finite exact differential-force sums.
- `NewtonianLipschitz/BaselineBounds.lean` — explicit conservative derivative estimates recovered from existing checked mathematics.
- `NewtonianLipschitz/ConvexBaseline.lean` — nonoptimal Lipschitz bounds on convex safe domains.
- `NewtonianLipschitz/ImprovedBounds.lean` — proposed new conservative derivative coefficient 7, pending CI.
- `NewtonianLipschitz/ConvexImproved.lean` — convex-domain companion coefficient 7, pending CI.
- `NewtonianLipschitz/JacobianRows.lean` — dominant-row and diagonal-reduction algebra toward the exact coefficient, pending CI.
- `NewtonianLipschitz/CubicCandidate.lean` — exact definitions for an unproved optimization candidate.
- `NewtonianLipschitz.lean` — substantive library entry point.
- `lean-toolchain`, `lakefile.toml`, `lake-manifest.json` — pinned Lean 4 / Mathlib environment.
- `.github/workflows/lean.yml` — full Lean build and source/documentation checks.
- `.github/workflows/comparator.yml` — **manual, readiness-gated** independent Comparator run after selecting a proved theorem.
- `Challenge.lean`, `Solution.lean`, `comparator.json` — initialized but **unselected** future Comparator interface; no verification is implied.
- `formalization.yaml` and `PALOMAR.md` — Palomar-oriented **draft placeholders**, not a submission-ready theorem record.
- `scripts/` — proof-hole, integrity, documentation and future independent-kernel checks.
- `LICENSE` — Apache License, Version 2.0.

Run locally with:

```sh
lake exe cache get
python3 scripts/check-repository.py
python3 scripts/check-documentation.py
python3 scripts/check-no-proof-holes.py
lake build NewtonianLipschitz
```

The independent Comparator infrastructure is present but **disabled until an actual, compiled theorem is selected**. The separate manual workflow deliberately fails without a nonempty theorem selection; no Comparator pass is claimed. Palomar files are placeholders and must be finalized against the Registry standard only after the target proof exists.

## Methodology — transparent LLM-assisted research

This README doubles as a scientific status report and an operational record of the next research step. The human project lead determines the research objectives and approves changes of direction. AI systems may propose approaches, generate code, identify mistakes and suggest literature; their outputs are hypotheses requiring independent checking, not scientific authority. Odasso's role as project director **does not imply professional mathematical credentials**.

**Formal-proof discipline:** maintain explicit definitions, hypotheses, norm conventions and quantifier order. Do not introduce `sorry`, `admit` or additional axioms into substantive proofs. A successful Lean build checks the stated formal declarations; it does not establish that a model matches a real physical system, nor that a theorem is new, optimal unless sharpness is proved, or suitable for publication.

**Verification and review:** use pull requests for substantive results, inspect the diff, require a green full-build workflow on the exact proposed head before merging, and distinguish CI success from independent kernel checking. Preserve failed approaches in Git history without reporting them as results. Record scope restrictions and counterexamples, especially where nonconvex geometry prevents a standard mean-value argument.

**Documentation freshness:** before each result-changing merge, audit the executive summary, result claims, roadmap, methodology, source comments, proof-hole checks and relevant workflow settings. Update statements made obsolete by new mathematics, without silently upgrading evidence from numerical observation to formal proof. Assess originality through explicit comparison with the literature and eventual independent specialist review; no mathematical priority or scientific discovery is claimed at project creation.

## License

Apache License, Version 2.0 (`Apache-2.0`). See [LICENSE](LICENSE).
