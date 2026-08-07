# Agents

Each managed cluster runs an **Astronomer agent**. The agent connects **outbound** to the management plane so you do not need inbound access to every cluster.

## Why outbound agents

- Fits locked-down enterprise networks
- Centralizes authentication and audit on the management plane
- Allows privilege to be **profiled** per cluster rather than “full admin always”

## Privilege profiles

Profiles bound what the agent may do on the target cluster. Common profiles include:

| Profile | Intent |
| --- | --- |
| `viewer` | Read-heavy inspection |
| `operator` | Day-2 workload operations |
| `namespace-viewer` | Scoped read in selected namespaces |
| `namespace-operator` | Scoped write in selected namespaces |
| `custom` | Tailored claims |
| `admin` | Broad cluster access (use sparingly) |

Pick the **least privilege** that still meets the team’s operational needs. Changing privilege is a security-sensitive change: treat it like granting cluster-admin via a product surface.

## Lifecycle

1. **Install** agent from registration material.
2. **Enroll / connect** outbound to the plane.
3. **Heartbeat / health** reported to inventory.
4. **Upgrade** agent versions with fleet practices (roll, canary, verify explorer).
5. **Decommission** when a cluster leaves management (remove agent, deregister cluster).

## Connectivity and tunnel health

Operators should watch:

- Connected vs disconnected / never-connected counts
- Flapping connections (often network or credential rotation issues)
- Agent version distribution across the fleet
- Ingestion / upgrade status for fleet tooling

When a cluster is offline, Astronomer cannot see live objects on that cluster until the agent reconnects. Historical inventory and last-known metadata may still exist in Postgres.

## Security notes

- Agent credentials are product-managed; rotate according to policy.
- Do not reuse registration packages beyond their intended lifetime.
- Namespace-scoped profiles need correct namespace bindings or operators will see empty explorers.

## Related pages

- [Adopt clusters](./adopt-clusters.md)
- [Architecture](./architecture.md)
- [Security and RBAC](./security-and-rbac.md)
