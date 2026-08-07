# MCP tool quick reference (0.3.5)

Prefer tools by name. All reads are management-plane only.

## First questions

| User ask | Tool |
| --- | --- |
| K8s / Astronomer version | `installation.summary` |
| Is the install healthy? | `installation.readiness` then `pods` |
| Which pods? CrashLoop? | `management.pods` |
| Rollout stuck? | `management.rollout_status` |
| Logs | `management.pod_logs` (after pods) |
| Events | `management.events` |
| Nodes | `management.nodes` |
| Fleet agents | `agent_fleet.*` + `tunnel.*` |

## Writes (mode-gated)

Restart / rollout / scale / tunnel restart / run_job need **approval** unless
policy says otherwise. Auto-eligible by catalog: `argocd.self_management_sync`,
`queue.retry_task` only (still require mode=auto + central allowlist).
