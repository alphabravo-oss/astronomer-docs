# Astronomer Docs

Versioned product documentation for [Astronomer](https://github.com/alphabravo-oss/astronomer) — enterprise Kubernetes operations for adopted clusters.

This repository is the **public docs home** for Astronomer releases. It holds:

1. **Charlie knowledge packs** — Markdown scope, playbooks, and tool references that Charlie (the product agent) retrieves by `product_version` when answering SRE questions.
2. **Human-readable runbooks** for the same topics (same source; no separate copy).

Product code and the MCP tool surface live in [`alphabravo-oss/astronomer`](https://github.com/alphabravo-oss/astronomer). Docs here must only describe capabilities that exist for that product version.

## Layout

```
versions/
  0.3.5/                 # product documentation version (semver)
    _meta.yaml
    scope.md             # hard product safety boundary
    playbooks/           # investigation / remediation runbooks
    reference/           # MCP tools, modes, authority
scripts/
  package-charlie-knowledge.sh
```

## Current published version

| Product version | Status | Contents |
| --- | --- | --- |
| **0.3.5** | Published | Charlie SRE scope, crashloop/tunnel/readiness playbooks, MCP + modes reference |

Browse: [`versions/0.3.5/`](./versions/0.3.5/)

## Versioning rules

- Folder name = Astronomer **product documentation version** (e.g. `0.3.5`), not a git describe string.
- When Astronomer ships `0.3.6`, add `versions/0.3.6/` and leave older trees in place for still-running installs.
- Charlie sessions pin retrieval to the install’s product version; they do not silently use “latest.”

## Packaging for Charlie RAG

```bash
./scripts/package-charlie-knowledge.sh 0.3.5
# writes dist/astronomer-knowledge-0.3.5.{md,documents.json,manifest.txt}
```

Then upload documents to the Charlie product collection, publish a knowledge release with `product_version=0.3.5`, activate it, and wait for indexes to become ready.

GitHub Releases for this repo may attach the same `dist/` artifacts for operators who package offline.

## What belongs here vs product code

| In this repo | In `astronomer` code |
| --- | --- |
| How to investigate crashloops | Actual pod list / logs tools |
| When to propose restart vs read-only | Mode and approval enforcement |
| Fleet tunnel triage steps | Tunnel health tools |
| Operator narrative | Bounded JSON facts |

Docs must **not** invent tools. Playbooks only reference the MCP catalog for that product version.

## License

GNU Affero General Public License v3.0 — same as [Astronomer](https://github.com/alphabravo-oss/astronomer).
