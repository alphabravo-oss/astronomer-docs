# Backup and disaster recovery

Astronomer’s durable product state lives primarily in **Postgres**. Cluster live state remains on each managed cluster’s etcd; agent connectivity can be rebuilt if you still have registration practices and keys.

## What to protect

| Asset | Why |
| --- | --- |
| **Postgres** | Users, RBAC, audit, inventory, credentials, operation history |
| **Fernet key** | Decrypts sensitive columns — backup with the same rigor as the database |
| **JWT signing key** | Session/token trust (rotation possible but disruptive if lost unexpectedly) |
| **Helm values / Git** | Reconstruct install intent |
| **Object storage backups** | Chart backup jobs when configured to S3-compatible storage |

## Management-plane backups

The chart supports management-plane backup jobs to S3-compatible storage (when enabled and configured). Operators should:

1. Enable and schedule backups for production.
2. Verify objects land in the expected bucket/prefix.
3. Restrict who can read backup objects.
4. Document restore ownership and RTO/RPO targets.

## Restore drills

Run **restore drills** on a schedule (non-production restore target when possible):

1. Restore Postgres from backup.
2. Present the same Fernet key material the backup expects.
3. Bring up the plane with matching chart version.
4. Validate login, inventory, and a sample cluster connection.
5. Record gaps and fix automation.

A backup that has never been restored is a hypothesis, not a control.

## Failure scenarios

| Scenario | Orientation |
| --- | --- |
| Lost management-plane cluster | Rebuild cluster → restore Postgres + keys → reinstall chart → re-establish ingress/DNS |
| Lost Fernet key only | Encrypted fields unrecoverable without key backup — treat as critical secret |
| Downstream cluster wiped | Re-provision cluster outside Astronomer → re-adopt → re-apply GitOps baselines |
| Regional outage | Depends on your multi-region design; Astronomer HA is within-cluster unless you design multi-site |

## Related pages

- [Install](./install.md)
- [Management plane](./management-plane.md)
- [Architecture](./architecture.md)
