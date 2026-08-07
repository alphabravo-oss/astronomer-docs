# Contributing to Astronomer Docs

## Purpose

These docs explain **Astronomer the product**: architecture, install, cluster adoption, agents, GitOps, security, and day-2 operations.

They are **not** integration guides for third-party assistants or internal bridge protocols. Keep that material in the product monorepo (engineering plans, agent contracts) if needed.

## Adding a product version

1. Copy the previous tree: `cp -a versions/X.Y.Z versions/X.Y.W`
2. Update `_meta.yaml` and any hard-coded version strings.
3. Align install, chart, and CRD notes with the matching Astronomer release.
4. Run `./scripts/package-version.sh X.Y.W` and fix packaging errors.
5. Open a PR. Prefer short, task-oriented pages over monologues.
6. After merge, cut a GitHub Release `vX.Y.W` with packaged artifacts if useful.

## Style (RKE2-like)

- Lead with **what the operator does** and **how the system behaves**.
- Use concrete component names (`server`, `worker`, `frontend`, agent, Argo CD).
- No secrets, credentials, or customer data.
- Prefer tables for options and decision trees.
- Link to the product chart/README when deep configuration belongs in source.

## What belongs where

| Here (`astronomer-docs`) | In `astronomer` code / eng docs |
| --- | --- |
| How to install and operate the product | Implementation details, plans, test harnesses |
| Architecture and responsibility split | Internal API contracts between services |
| Day-2 runbooks for the management plane | Unit/integration test matrices |
| CRD and chart overview for operators | Generated OpenAPI / code comments |
