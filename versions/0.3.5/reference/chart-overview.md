# Helm chart overview

Astronomer ships as a Kubernetes Helm chart. This page is a **capability map**; authoritative keys live in the chart `values.yaml` / schema for your version.

## Production-oriented capabilities

- Server, worker, and frontend replica controls
- PodDisruptionBudgets, anti-affinity, topology spread
- NetworkPolicy with explicit ingress/egress
- Ingress / Gateway and TLS integration
- cert-manager and Let's Encrypt compatibility
- External Postgres and Redis for production
- Bootstrap admin credential generation or operator-provided password
- Non-root security contexts, dropped capabilities, seccomp, read-only root filesystem where practical
- Migration, preflight, backup, and restore-drill jobs
- Management-plane backup to S3-compatible storage
- Production value validation and chart render tests

## Typical value areas

| Area | Examples |
| --- | --- |
| Images | repository, tag, digests, pull secrets |
| Scaling | replicas, resources, HPA (if enabled) |
| Persistence | Postgres/Redis PVC size and storage class |
| Ingress | host, TLS secret, annotations |
| Features | feature flags for product modules |
| Security | NetworkPolicy toggles, pod security context |
| Backups | schedule, destination, credentials via secrets |

## Bundled vs external data stores

| Profile | Postgres / Redis |
| --- | --- |
| Dev / CI / smoke | Bundled chart components acceptable |
| Production | External managed or HA services recommended |

## Related pages

- [Install](../install.md)
- [Architecture](../architecture.md)
