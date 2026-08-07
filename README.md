# Astronomer Docs

Versioned product documentation for **[Astronomer](https://github.com/alphabravo-oss/astronomer)** — enterprise Kubernetes operations for clusters you already run.

This repository is the public docs home for Astronomer releases, in the same spirit as [RKE2 docs](https://docs.rke2.io) for RKE2: **what the product is, how it is built, how you install it, and how you operate it.**

Product source code lives in [`alphabravo-oss/astronomer`](https://github.com/alphabravo-oss/astronomer).

## What Astronomer is

Astronomer is a self-hosted **management plane** for platform teams:

- **Adopt** existing clusters (RKE2, k3s, EKS, AKS, GKE, bare metal, CAPI, …)
- **Govern** with projects, RBAC, SSO, audit, and policy
- **Deploy** with built-in Argo CD and ApplicationSets
- **Operate** workloads, logs, shell, explorer, and fleet health day-2

It does **not** provision nodes or replace your infrastructure toolchain. You keep Terraform / cloud / RKE2 install flows; Astronomer takes over after the cluster exists.

## Layout

```
versions/
  0.3.5/                    # docs for product version 0.3.5
    _meta.yaml              # version metadata
    README.md               # version index
    architecture.md
    install.md
    adopt-clusters.md
    agents.md
    gitops.md
    security-and-rbac.md
    operations.md
    management-plane.md
    backup-and-dr.md
    reference/
      crds.md
      chart-overview.md
scripts/
  package-version.sh        # build dist artifacts for a version
```

## Current version

| Product version | Browse |
| --- | --- |
| **0.3.5** | [versions/0.3.5](./versions/0.3.5/) · [Release](https://github.com/alphabravo-oss/astronomer-docs/releases/tag/v0.3.5) |

## Versioning

- Folder name = Astronomer **product documentation version** (semver), matching the chart/app version where practical.
- Older trees stay published so installs on older versions keep matching docs.
- When you ship `0.3.6`, copy `versions/0.3.5` → `versions/0.3.6` and update content.

## Packaging a version

```bash
./scripts/package-version.sh 0.3.5
# writes dist/astronomer-docs-0.3.5.{md,documents.json,manifest.txt}
```

Artifacts are plain Markdown suitable for websites, offline bundles, or any search/index pipeline. They describe **Astronomer**, not an external assistant.

## Contributing

See [CONTRIBUTING.md](./CONTRIBUTING.md).

## License

GNU Affero General Public License v3.0 — same as [Astronomer](https://github.com/alphabravo-oss/astronomer).
