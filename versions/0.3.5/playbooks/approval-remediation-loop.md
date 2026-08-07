# Playbook: Approval-mode remediation loop

Use when authoritative mode is **approval** (or auto for allowlisted actions).

## Rules

1. Gather evidence with **read** tools first (pods, logs, events, readiness).
2. Propose **exactly one** disclosed write with exact arguments from context
   (workload name, resource_id, operation_id). Do not invent IDs.
3. A tool proposal is **not** an executed action. Wait for product approval UI.
4. After success, re-read with `rollout_status` / `pods` / `readiness` to verify.
5. If denied or mode is read_only, open a finding path / manual steps—never retry
   around denial with a different target.

## Common remediations

| Symptom | Candidate write | Verify with |
| --- | --- | --- |
| Stuck server Deployment | `workload_restart` or `workload_rollout` | `rollout_status`, `pods` |
| Need more workers | `workload_scale` (replicas 2–20) | `workload_get` |
| Argo out of sync | `argocd.self_management_sync` | `argocd.self_management_status` |
| Failed queue task | `queue.retry_task` | `queue.failed_tasks` |
| Tunnel component wedged | `tunnel.restart_component` | `tunnel.health` |

## Never

- Describe approval as already granted
- Switch to a more powerful tool after denial
- Restart non-mutable Deployments (only server/worker/frontend)
