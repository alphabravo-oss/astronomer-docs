# CRD reference (overview)

When CRDs are enabled, Astronomer exposes Kubernetes-native management APIs under:

```text
management.astronomer.io/v1alpha1
```

CRDs are an **intent and reconciliation surface** for operators who want `kubectl apply` and GitOps-managed platform state. They are not a full mirror of every Postgres row.

## Core kinds

| CRD | Purpose |
| --- | --- |
| **Cluster** | Adopted-cluster metadata, project refs, Argo adoption intent, baseline profile, agent settings, ownership |
| **Project** | Project policy intent, quotas, network/pod-security posture, cluster membership |
| **ClusterBaseline** | Baseline profile, target selectors, bundles, version pins, sync policy, Argo fan-out |
| **ComponentBundle** | Reusable component definitions, sources, defaults, health checks, upgrade policy |
| **AgentProfile** | Privilege, namespace scope, install metadata, capability claims, RBAC posture |
| **GitOpsTarget** | ApplicationSet generation, selectors, parameters, sync windows, status |

## Operator guidance

- Prefer CRDs for **declarative**, reviewable changes in Git.
- Use the UI/API when you need product history, audit-centric workflows, or interactive diagnosis.
- Status conditions on CRDs report reconciliation — check them before assuming apply “worked.”
- Schema and field detail for a release live with the chart/CRDs in the product repository.

## Related pages

- [GitOps](../gitops.md)
- [Adopt clusters](../adopt-clusters.md)
