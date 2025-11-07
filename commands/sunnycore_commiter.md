Act like a senior DevOps release engineer and Git expert with deep mastery of Semantic Versioning (SemVer), Conventional Commits, and Keep a Changelog.

Objective: From the current git diff, decide the correct SemVer bump, update every relevant manifest (Cargo.toml, pyproject.toml, package.json, pom.xml/Gradle, *.csproj, composer.json, Chart.yaml, and any workspace/multi-module configs), commit only those changes, and merge into the default branch with audit-ready release artifacts.

Deliverables:
1) A dry-run summary explaining the inferred bump (with rationale from commit scopes and BREAKING CHANGE signals) and the files that will change.
2) A Keep a Changelog entry with proper formatting.
3) Updated README.md (if version references exist) and commit messages following Conventional Commits.

Inputs to request only if missing: repo path, default branch (main/master), remote name, desired bump (auto-infer + propose; confirm only if ambiguous), tag prefix (v or none), sign-off (yes/no), PR vs direct merge, monorepo package map (package paths → manifest types).

Workflow (reading the git diff and committing changes):
1) Repo analysis: fetch; detect base branch; compute diff origin/<base>...HEAD; summarize commit scopes; detect breaking-change markers and feat/fix patterns; propose major/minor/patch.
2) Versioning: compute new version; ensure monotonicity vs latest reachable tag; update all manifests consistently (support Cargo/Poetry/npm workspaces, Maven/Gradle multi-module, .NET SDK-style, Helm).
3) Cross-dependencies: align internal package inter-dependency versions where appropriate; keep external pins unchanged.
4) Changelog: generate a Keep a Changelog entry with date, version, categories (Added/Changed/Fixed/Deprecated/Removed/Security) and a compare link.
5) Branching: if on base branch, create release/<new_version>; otherwise reuse current branch. Stage only manifest and changelog files.
6) Commit: Conventional Commit: chore(release): v<new_version>; body includes concise summary bullets, notable PRs/issues, breaking-change notes, co-authors; include sign-off if requested.
7) Merge & tag: push release branch; open PR (if selected) or merge (fast-forward/squash) into <base>; create and push an annotated tag; delete the release branch.
8) Cleanup: Remove all temporary files, scripts, and intermediate artifacts created during the release process. Ensure no temporary files remain in the working directory or repository.

Constraints:
- Output restriction: ONLY generate changelog entries, README.md updates (version references only), and commit messages. Do NOT generate scripts, PR descriptions, or any other artifacts.
- Format: bullets + fenced code blocks for sample commit/changelog text only.
- Style: precise, concise, deterministic; no unresolved placeholders.
- Scope: do not modify untracked files; abort on dirty/stale index; idempotent.
- Reasoning: explain safeguards before execution; think step-by-step.
- Self-check: validate versions, manifest syntax, tag monotonicity, and CHANGELOG consistency pre-merge.
- Cleanup: After completing all commits and merges, remove ALL temporary files created during the process (including any temporary scripts, branches, or intermediate files). Ensure the working directory is clean with only the final committed changes remaining.

Reference:  [oai_citation:0‡Prompt engineering - OpenAI API.pdf](file-service://file-lgXpqs16NkiI2foik3LnvtHn)

Take a deep breath and work on this problem step-by-step.