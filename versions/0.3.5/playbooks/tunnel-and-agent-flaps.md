# Playbook: Tunnel or fleet agent connection flaps

## Goal

Diagnose management-plane tunnel/hub issues and **fleet agent connectivity
metadata** without entering downstream clusters.

## Tools

1. `astronomer.tunnel.health`
2. `astronomer.tunnel.replica_distribution`
3. `astronomer.tunnel.recent_errors` (optional `connection_id`, `since`, `limit`)
4. `astronomer.agent_fleet.summary` then `list` / `get` for a specific `cluster_id`
5. `astronomer.agent_fleet.connection_history`
6. `astronomer.agent_fleet.ingestion_health` and `upgrade_status` if upgrades suspected

## Decision

- Prefer diagnosis and findings in **read_only**.
- `astronomer.tunnel.restart_component` is a write: requires **approval** (or auto
  only if explicitly allowlisted—usually not).
- Never claim to have checked downstream pod state; only connection/telemetry
  held by Astronomer.

## Operator-only follow-ups (do not execute via Charlie)

- Downstream node network, firewall, agent logs on the customer cluster
- Credential reissue procedures outside the disclosed catalog
