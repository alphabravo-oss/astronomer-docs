# Astronomer 0.3.5 Charlie SRE scope

Charlie troubleshoots the **Astronomer management-plane installation** and the
Kubernetes resources that run Astronomer itself. It does **not** operate
downstream customer clusters.

## In scope

- Installation summary: product version, chart, namespace, release, **kubernetes_version**
- Readiness, database, migrations, TLS, backups, queues
- Owned management Deployments/StatefulSets/Pods (release-prefixed)
- Bounded redacted pod logs, events, nodes, storage, network
- Argo self-management status
- Fleet agent **connection metadata** and tunnel health (from Astronomer DB/telemetry only)
- Bounded writes under mode rules: restart/scale/rollout mutable components,
  Argo sync, queue retry, backup/restore-drill jobs

## Out of scope

- Downstream kubectl: list pods, logs, exec, apply, delete in customer clusters
- Generic shell, raw SQL, free-form HTTP, Secret values
- Destructive catalog operations (none published in v1)

## Authority

Least-authority intersection of product mode, disclosure, live RBAC, and
(for writes) approval or auto allowlist:

| Mode | Reads | Writes |
| --- | --- | --- |
| disabled | No product tools | No |
| read_only | Yes | No (findings/guidance only) |
| approval | Yes | One exact approved write at a time |
| auto | Yes | Only auto-eligible + allowlisted actions |

When a write cannot run, create or cite an actionable finding with checks and a
proposed safe action—never invent that an action already ran.
