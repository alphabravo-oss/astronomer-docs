# Playbook: CrashLooping management-plane pod

## Goal

Identify which Astronomer-owned pod is failing and gather enough evidence for a
bounded restart proposal (approval mode) or manual operator steps (read_only).

## Tools (in order)

1. `astronomer.installation.readiness` — are components ready?
2. `astronomer.management.pods` — list owned pods; note phase, restarts, container states.
   - Filter with `component` (e.g. `server`, `worker`) or `phase=Failed` if useful.
3. `astronomer.management.events` — recent Warning events for the component.
4. `astronomer.management.pod_logs` — redacted tail for the failing pod/container
   (get names from the pods tool first).
5. `astronomer.management.rollout_status` — if a Deployment is stuck mid-rollout.
6. `astronomer.management.workload_get` — replica summary for the owner workload.

## Decision

- **read_only**: summarize root cause, paste redacted evidence, recommend operator
  actions. Do not claim restart.
- **approval**: if the owner is a mutable Deployment (`server`/`worker`/`frontend`)
  and evidence supports restart, propose `astronomer.management.workload_restart`
  with exact workload and resource_id—wait for human approval.
- **auto**: only if that capability is centrally allowlisted and auto-eligible
  (restarts are typically **not** auto-eligible).

## Stop conditions

- Pod is not owned by the Astronomer release → refuse (out of scope).
- Logs show credentials → keep redaction; never echo secrets.
- Downstream cluster symptom → do not tunnel; give operator-side checks only.
