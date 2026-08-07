# Adopt clusters

Astronomer manages clusters you already have. **Adoption** registers a cluster with the management plane and installs (or reuses) an agent so the plane can operate it.

## Ways to adopt

| Path | When to use |
| --- | --- |
| **UI** | Interactive registration: generate agent install material, watch health |
| **API** | Automation and pipelines |
| **CLI-oriented manifests** | Air-gapped or scripted installs of agent YAML |
| **GitOps / CRDs** | Declarative `Cluster` objects under `management.astronomer.io` |
| **GitOps registration sources** | Fleet-scale onboarding from known sources |

## What gets recorded

For each adopted cluster Astronomer tracks metadata such as:

- Phase and connectivity / health
- Labels, project membership, environment, region, provider
- Kubernetes distribution and version
- Agent version and **privilege profile**
- Baseline / ApplicationSet targeting state

## Adoption flow (operator view)

1. Create or select a **project** (optional but recommended for RBAC scope).
2. Start cluster registration (UI or API).
3. Choose an **agent privilege profile** appropriate for the cluster’s trust level.
4. Install the agent on the target cluster (manifest or documented method).
5. Wait for outbound connection and health to show **connected**.
6. Confirm Argo CD managed-cluster registration if GitOps baselines are enabled.
7. Open **cluster explorer** and verify live resource browse.

## Health and troubleshooting adoption

| Symptom | Things to check |
| --- | --- |
| Agent never connects | Outbound network from cluster to management plane URL; TLS/CA; install namespace and credentials |
| Connected but degraded | Agent version skew; privilege too low for intended ops; node pressure on the target |
| Registration stuck | Server/worker logs on the management plane; queue backlog; failed background tasks |
| Argo not targeting cluster | Cluster Secret labels for ApplicationSets; project/selectors on baselines |

## Projects

Projects group clusters for RBAC, quotas, and policy intent. Prefer putting production clusters in a restricted project and mapping groups carefully (see [Security and RBAC](./security-and-rbac.md)).

## Related pages

- [Agents](./agents.md)
- [GitOps](./gitops.md)
- [Operations](./operations.md)
