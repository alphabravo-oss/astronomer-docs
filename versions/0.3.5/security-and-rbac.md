# Security and RBAC

Astronomer treats identity, authorization, audit, and secret handling as **product surfaces**, not add-ons.

## Authentication

- Local accounts (email-first) with secure browser sessions
- OIDC/OAuth providers, SSO presets, group mappings, logout flows
- TOTP enrollment, recovery codes
- API tokens with revocation
- Password reset and account security workflows

Configure SSO for production teams; reserve local admin for break-glass.

## Authorization

- Project- and cluster-scoped RBAC
- Permission-aware UI (actions hidden or disabled when denied)
- Agent privilege profiles further bound **what can be done on a cluster** even when the user is allowed

Effective authority for a cluster operation is the intersection of:

1. User (or token) RBAC in Astronomer
2. Agent privilege profile on that cluster
3. Any additional product policy (e.g. high-risk route controls)

## Audit

Material actions are audited, including:

- Sensitive reads and writes
- Secret access patterns
- Service proxy mutations
- Argo operations
- RBAC and admin changes

Use audit search and SIEM forwarders where your compliance program requires export.

## Secrets and credentials

- Product encryption for sensitive columns (Fernet key)
- Hashing for tokens where appropriate
- Redaction in logs and support bundles
- External secret references / Vault connection surfaces when configured
- Chart and Argo resources should not become secret dump sites

**Never** lose the Fernet key without a recovery plan.

## Network and workload security (management plane)

- NetworkPolicy defaults
- Non-root, dropped capabilities, seccomp, read-only root filesystem where practical
- TLS on external endpoints
- Image scanning and compliance baselines as configured

## Related pages

- [Agents](./agents.md) — privilege profiles
- [Operations](./operations.md) — permission-gated day-2 actions
- [Management plane](./management-plane.md)
