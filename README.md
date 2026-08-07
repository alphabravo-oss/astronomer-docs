# Astronomer Docs

Versioned product documentation for [Astronomer](https://github.com/alphabravo-oss/astronomer) — enterprise Kubernetes operations for adopted clusters.

This repository is the **public docs home** for Astronomer releases. It holds:

1. **Charlie knowledge packs** — Markdown scope, playbooks, and tool references Charlie retrieves by `product_version`.
2. **Test-run operator notes** — environment IDs, publish steps, and live prompt checklists (`TEST-RUN.md` per version).

Product code and the MCP tool surface live in [`alphabravo-oss/astronomer`](https://github.com/alphabravo-oss/astronomer). Docs here must only describe capabilities that exist for that product version.

## Layout

```
versions/
  0.3.5/                 # product documentation version (semver)
    _meta.yaml           # Charlie IDs + maturity (not uploaded to RAG)
    TEST-RUN.md          # operator checklist for the dev test install
    scope.md             # hard product safety boundary
    playbooks/           # investigation / remediation runbooks
    reference/           # MCP tools, modes, authority
scripts/
  package-charlie-knowledge.sh
  publish-to-charlie.sh  # needs CHARLIE_API_KEY (config_admin)
```

## Current published version

| Product version | Status | Browse |
| --- | --- | --- |
| **0.3.5** | Test-run published | [versions/0.3.5](./versions/0.3.5/) · [TEST-RUN](./versions/0.3.5/TEST-RUN.md) · [Release](https://github.com/alphabravo-oss/astronomer-docs/releases/tag/v0.3.5) |

## Versioning rules

- Folder name = Astronomer **product documentation version** (e.g. `0.3.5`), not a git describe string.
- When Astronomer ships `0.3.6`, add `versions/0.3.6/` and leave older trees in place for still-running installs.
- Charlie sessions pin retrieval to the install’s product version; they do not silently use “latest.”

## Packaging for Charlie RAG

```bash
./scripts/package-charlie-knowledge.sh 0.3.5
# writes dist/astronomer-knowledge-0.3.5.{md,documents.json,manifest.txt}
# (excludes TEST-RUN.md and _meta.yaml from the RAG corpus)
```

### Publish + activate (Charlie central)

Requires a **config_admin** API key. Agent enrollment tokens are rejected.

```bash
export CHARLIE_BASE_URL=https://charlie.dev.alphabravo.io
export CHARLIE_API_KEY='…'   # config_admin only
./scripts/publish-to-charlie.sh 0.3.5
```

See [versions/0.3.5/TEST-RUN.md](./versions/0.3.5/TEST-RUN.md) for collection IDs, smoke prompts, and exit criteria.

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
