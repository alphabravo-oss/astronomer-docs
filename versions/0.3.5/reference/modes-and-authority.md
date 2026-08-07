# Modes and authority (0.3.5)

Authority is **not** chosen by the model. Product mode + disclosure + live RBAC
gate every tool call.

- **read_only**: diagnose freely with reads; no product writes; produce findings.
- **approval**: propose exact writes; human must approve once; verify after.
- **auto**: only allowlisted auto-eligible actions without human click; else fall back to approval/finding.
- **disabled**: no chat tools.

Chat sessions inherit product authoritative mode. Raising mode requires Charlie
admin (disclosure acknowledged, not emergency-disabled).
