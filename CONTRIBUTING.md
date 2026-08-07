# Contributing to Astronomer Docs

## Adding a product version

1. Copy the previous version tree: `cp -a versions/X.Y.Z versions/X.Y.W`
2. Update `_meta.yaml` `product_version` and every doc that hard-codes the version.
3. Align playbooks and tool names with the MCP catalog in that Astronomer release.
4. Run `./scripts/package-charlie-knowledge.sh X.Y.W` and fix any packaging errors.
5. Open a PR. Prefer small, task-oriented Markdown pages over large monologues.
6. After merge, cut a GitHub Release `vX.Y.W` with the packaged artifacts if desired.

## Style

- Task-oriented playbooks Charlie (and humans) can follow.
- No secrets, credentials, or customer data.
- Prefer short pages that chunk well for RAG.
- Link tools by exact MCP names used in product code.
