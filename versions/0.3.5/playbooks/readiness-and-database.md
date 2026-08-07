# Playbook: Installation not ready / database issues

## Goal

Separate “component not ready” from “schema/database” problems.

## Tools

1. `astronomer.installation.readiness`
2. `astronomer.installation.summary` — versions and component health
3. `astronomer.database.health`
4. `astronomer.migrations.status`
5. `astronomer.queue.health` and `astronomer.queue.failed_tasks`
6. `astronomer.management.pods` / `events` if a specific component is not ready
7. `astronomer.backups.status` if restore/drill related

## Decision

- Schema **dirty** or version behind expected → stop recommending app restarts;
  escalate to migration/operator runbooks.
- Queue backlog of failed tasks → list with `failed_tasks`; `queue.retry_task` is
  a write (approval/auto policy).
- Component unready with CrashLoop → follow crashloop playbook.
