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

## Results acquired and verification status

**Initial state: project infrastructure and foundational definitions only.** The repository does not yet contain a formal proof of the candidate optimal coefficient, its sharpness, or a comparison with published literature sufficient to establish mathematical originality.

Claims will be recorded as **proposed**, **Lean-compiled**, **independently kernel-checked**, or **externally reviewed** only when corresponding evidence exists. Successful compilation of a definition is not proof of a later theorem; a numerical calculation is not a formal proof. Future results must cite exact Lean declarations and successful CI runs.

## Roadmap

1. Define the three-dimensional field, Euclidean radius, supremum norm and collision-free domains; reuse existing mathematical foundations without importing unrelated physical models.
2. Formalize its exact Fréchet derivative and induced supremum operator norm.
3. Establish a universal sharp upper bound, with the coefficient specified exactly rather than by an unexplained decimal approximation.
4. Prove sharpness with admissible configurations excluding every smaller coefficient.
5. Transfer the result to convex noncollision domains and, separately, investigate the nonconvex exterior of a cube.
6. Only after the main theorem is established, investigate finite-source sums or uniformly bounded scenario families, and compare the exact statement with prior literature.

These are research objectives, **not completed theorems**. The order may change after formal verification or mathematical criticism.

## Repository structure and reproducibility

- `NewtonianLipschitz/Basic.lean` — coordinate vectors and the physical radius.
- `NewtonianLipschitz/Field.lean` — exact gravitational field.
- `NewtonianLipschitz.lean` — substantive library entry point.
- `lean-toolchain`, `lakefile.toml`, `lake-manifest.json` — pinned Lean 4 / Mathlib environment.
- `.github/workflows/lean.yml` — full Lean build and source/documentation checks.
- `scripts/` — checks against proof placeholders and inaccurate project documentation.
- `LICENSE` — Apache License, Version 2.0.

Run locally with:

```sh
lake exe cache get
python3 scripts/check-repository.py
python3 scripts/check-documentation.py
python3 scripts/check-no-proof-holes.py
lake build NewtonianLipschitz
```

An independent Challenge/Solution Comparator stage may be added when a substantive selected theorem and faithful standalone challenge exist. **No independent kernel comparison is claimed for the initial scaffold.**

## Methodology — transparent LLM-assisted research

This README doubles as a scientific status report and an operational record of the next research step. The human project lead determines the research objectives and approves changes of direction. AI systems may propose approaches, generate code, identify mistakes and suggest literature; their outputs are hypotheses requiring independent checking, not scientific authority. Odasso's role as project director **does not imply professional mathematical credentials**.

**Formal-proof discipline:** maintain explicit definitions, hypotheses, norm conventions and quantifier order. Do not introduce `sorry`, `admit` or additional axioms into substantive proofs. A successful Lean build checks the stated formal declarations; it does not establish that a model matches a real physical system, nor that a theorem is new, optimal unless sharpness is proved, or suitable for publication.

**Verification and review:** use pull requests for substantive results, inspect the diff, require a green full-build workflow on the exact proposed head before merging, and distinguish CI success from independent kernel checking. Preserve failed approaches in Git history without reporting them as results. Record scope restrictions and counterexamples, especially where nonconvex geometry prevents a standard mean-value argument.

**Documentation freshness:** before each result-changing merge, audit the executive summary, result claims, roadmap, methodology, source comments, proof-hole checks and relevant workflow settings. Update statements made obsolete by new mathematics, without silently upgrading evidence from numerical observation to formal proof. Assess originality through explicit comparison with the literature and eventual independent specialist review; no mathematical priority or scientific discovery is claimed at project creation.

## License

Apache License, Version 2.0 (`Apache-2.0`). See [LICENSE](LICENSE).
