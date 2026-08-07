# Operations

Day-2 work in Astronomer is centered on the **operator UI** and supported APIs: see fleet health, open a cluster, inspect resources, act within policy.

## Multi-cluster operations

- Browse live Kubernetes resources across adopted clusters (namespaces, nodes, workloads, network, storage, RBAC objects, CRDs, …)
- Common workload actions: inspect, scale, restart, edit, delete — when RBAC and agent privilege allow
- Stream pod logs
- Open controlled shell sessions on approved clusters
- Proxy approved in-cluster services without publishing every internal dashboard
- Track adoption progress, failures, retries, and baseline application state

## Observability

- Platform-wide health summary
- Monitoring backend and shared observability stack workflows
- Alerting, notification templates, SMTP, webhooks, SIEM forwarders
- Logging pipeline configuration and management-plane log tailing
- Support bundle export with redaction

## Background work

- Queue and dead-letter inspection for background jobs
- Task-outbox visibility for committed work not yet on the worker queue
- Retry or remediate failed tasks according to product allowlists and RBAC

## Practical operator habits

1. **Start from inventory health** — disconnected agents explain empty explorers.
2. **Confirm project and permissions** — “button missing” is often RBAC, not a bug.
3. **Prefer GitOps for fleet changes** — use explorer for diagnosis and break-glass.
4. **Scale and restart carefully** — especially on management-plane components and production workloads.
5. **Capture support bundles** with redaction when escalating incidents.

## Related pages

- [Adopt clusters](./adopt-clusters.md)
- [GitOps](./gitops.md)
- [Management plane](./management-plane.md)
