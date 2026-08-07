# Management plane care

The Astronomer **management plane** is itself a Kubernetes application. Treat it like any other production control plane: watch health, capacity, migrations, and upgrades.

## Components to watch

| Area | Healthy signals |
| --- | --- |
| **API / server** | Ready pods, low error rate, successful logins |
| **Worker** | Queue not backloging; DLQ not growing without reason |
| **Frontend** | Serves UI; matches server version expectations |
| **Postgres** | Connectivity, disk headroom, no dirty migration flag |
| **Redis** | Connectivity; jobs flowing |
| **Argo self-management** | Application healthy and synced when used |
| **Ingress / TLS** | Certificates valid; DNS correct |

## Common incident themes

### CrashLooping management pod

1. Identify the failing Deployment/StatefulSet and pod.
2. Read recent **Warning** events for that component.
3. Tail logs for the failing container.
4. Check last change (upgrade, config, secret rotation, disk pressure).
5. Remediate (fix config, restore capacity, controlled rollout restart) only with change control.

### Database / migrations

- Dirty migration flags require careful operator intervention — do not “just re-run” blindly.
- Disk full on Postgres volumes presents as API and worker failures.
- Prefer restore drills **before** you need them (see [Backup and DR](./backup-and-dr.md)).

### Queue backlog / DLQ growth

- Worker replicas undersized or stuck
- Downstream dependency failures (SMTP, webhooks, cloud APIs)
- Poison messages — inspect failed task types before mass retry

### Identity outages

- OIDC provider downtime → break-glass local admin path if configured
- Clock skew breaks tokens and OIDC

## Scaling the plane

Mutable Deployments (commonly `server`, `worker`, `frontend`) can be scaled for load. Scale within capacity of Postgres, Redis, and your HA topology. Chart values and PDBs should guide minimums.

## Related pages

- [Install](./install.md)
- [Backup and DR](./backup-and-dr.md)
- [Architecture](./architecture.md)
