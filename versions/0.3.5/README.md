# Astronomer 0.3.5 documentation

Enterprise Kubernetes **operations** for clusters you already run.

| Guide | What it covers |
| --- | --- |
| [Architecture](./architecture.md) | Management plane, Postgres, Redis, agents, Argo CD split |
| [Install](./install.md) | Helm install, keys, production vs dev posture |
| [Adopt clusters](./adopt-clusters.md) | Registration, health, projects, labels |
| [Agents](./agents.md) | Outbound agent model, privilege profiles, connectivity |
| [GitOps](./gitops.md) | Built-in Argo CD, ApplicationSets, baselines |
| [Security and RBAC](./security-and-rbac.md) | Identity, projects, permissions, audit |
| [Operations](./operations.md) | Explorer, workloads, logs, shell, alerts |
| [Management plane](./management-plane.md) | Caring for the Astronomer install itself |
| [Backup and DR](./backup-and-dr.md) | Backups, restore drills, resilience |
| [CRDs](./reference/crds.md) | `management.astronomer.io/v1alpha1` overview |
| [Chart overview](./reference/chart-overview.md) | Helm chart capabilities at a glance |

**Product version:** `0.3.5`  
**Source:** [alphabravo-oss/astronomer](https://github.com/alphabravo-oss/astronomer)

## Product promise

| Outcome | What Astronomer delivers |
| --- | --- |
| Adopt clusters safely | Registration, agent manifests, privilege profiles, health state |
| Standardize the fleet | Baselines, ApplicationSets, curated tools, consistent labels |
| Operate with confidence | Explorer, workload actions, logs, shell, proxy, events |
| Govern at scale | Projects, RBAC, SSO/OIDC, TOTP, API tokens, audit |
| Secure the control plane | Encryption, redaction, NetworkPolicy, least-privilege agents |
| Prove resilience | HA chart options, backups, restore drills, runbooks |

## What Astronomer is not

Astronomer is **not** a cluster provisioner. It does not replace Terraform, Cluster API, cloud node pools, or RKE2/k3s installers. It is the day-2 operating plane **after** clusters exist.
