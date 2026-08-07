# Architecture

Astronomer is a Kubernetes-native **management plane**. At a high level it is one install that:

1. Stores product state in **Postgres**
2. Runs async work on **Redis / asynq**
3. Serves UI and API from **server + frontend**
4. Connects to adopted clusters through **outbound agents**
5. Delivers fleet software with **built-in Argo CD**

## Responsibility split

| Layer | Owns |
| --- | --- |
| **Postgres** | Users, sessions, RBAC, audit history, projects, cluster inventory, credentials, durable operation records |
| **Redis / asynq** | Job queue and scheduler — not the durable source of operator intent |
| **Kubernetes + Argo CD** | Declarative deployment convergence for management-plane and fleet baselines |
| **Target clusters** | Live Kubernetes objects (source of truth for workloads on that cluster) |
| **CRDs** (optional) | Kubernetes-native intent for clusters, projects, baselines, agent profiles |
| **Agents** | Cluster-local work through authenticated, scoped, audited channels |

That split is deliberate: product history and identity live in Postgres; etcd stays on each cluster; Argo CD is not an account database.

## Management-plane components

Typical Helm release components (names depend on release prefix):

| Component | Role |
| --- | --- |
| **server** | HTTP API, auth, RBAC checks, cluster/agent control plane logic |
| **worker** | Background jobs (adoption, sync helpers, notifications, maintenance) |
| **frontend** | Operator UI |
| **postgres** | Bundled DB for dev/small installs (external Postgres for production) |
| **redis** | Queue backend (external Redis for production) |
| **Argo CD** | Built-in GitOps engine used by Astronomer for self-management and fleet |

Supporting jobs (chart-dependent): migrations, preflight, backup, restore-drill.

## Fleet connectivity model

Adopted clusters run a lightweight **Astronomer agent** that opens an **outbound** connection to the management plane.

- No requirement to open inbound firewall paths to every cluster
- Supports API proxying, log streaming, service proxy, health, and controlled operations
- Agent **privilege profile** bounds what the agent may do on the cluster

## Data flow (operator action)

```text
Operator (browser / API / kubectl CRD)
        │
        ▼
   Astronomer server  ──authn/authz/audit──► Postgres
        │
        ├── enqueue work ──► Redis/asynq ──► worker
        │
        └── agent channel ──► adopted cluster agent ──► cluster API
        │
        └── Argo CD ──► ApplicationSets / Applications on targets
```

## Security posture (architecture-level)

- Non-root containers, dropped capabilities, seccomp, read-only root filesystem where practical
- NetworkPolicy ingress/egress boundaries on the management plane
- Secrets encrypted at rest (product Fernet key); JWT signing key for sessions/API
- Secret redaction on logs and support bundles
- High-risk routes are permission-gated and audited

## Related pages

- [Install](./install.md) — deploy the plane
- [Agents](./agents.md) — privilege and connectivity detail
- [GitOps](./gitops.md) — Argo CD usage
- [Management plane](./management-plane.md) — day-2 care of the install itself
