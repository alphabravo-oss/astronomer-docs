# GitOps (Argo CD)

Astronomer uses **Argo CD** as the fleet deployment engine — not a separate “Fleet” product model.

## What you get

- Built-in Argo CD integration for applications, projects, repositories, syncs, health, and resources
- Automatic registration of adopted clusters into Argo CD (when enabled)
- Cluster Secret labeling for deterministic **ApplicationSet** targeting
- Platform **baselines** fanned out through ApplicationSets
- Sync-wave conventions for namespaces → CRDs → operators → policies → workloads
- Visibility for drift, orphans, stale resources, and ownership

## Baselines and bundles

| Concept | Role |
| --- | --- |
| **Cluster baseline** | Desired profile for a set of clusters (selectors, bundles, version pins, sync policy) |
| **Component bundle** | Reusable component definition (source, namespace defaults, health checks, upgrade policy) |
| **GitOps target** | Declarative ApplicationSet generation with selectors and parameters |

Operators typically:

1. Define or select a baseline profile.
2. Ensure clusters carry the right labels / project membership.
3. Let ApplicationSets generate Applications on matching clusters.
4. Watch sync/health in UI and Argo CD.

## Day-2 GitOps operations

- Sync or refresh Applications when drift is intentional or accidental
- Inspect resource trees for failed hooks or stuck sync waves
- Gate high-risk syncs with RBAC and change windows
- Prefer Git changes over click-ops for anything you need to reproduce

## Self-management

The Astronomer install itself can be managed by Argo CD (self-management Application). Treat syncs of the management plane with the same care as production control-plane changes: backups first, staged upgrades, verified health.

## Related pages

- [Architecture](./architecture.md)
- [Adopt clusters](./adopt-clusters.md)
- [CRDs](./reference/crds.md)
