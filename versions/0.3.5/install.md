# Install

Astronomer installs with a **Helm chart** onto a Kubernetes cluster you control (the management plane). Downstream clusters are **adopted later**; they are not provisioned by this chart.

## Prerequisites

- A Kubernetes cluster for the management plane (any conformant distribution)
- `helm` 3.x and `kubectl`
- Capacity for Postgres and Redis (bundled for dev; external recommended for production)
- Storage for persistent volumes if using bundled databases

## Critical keys (generate once)

The chart does not ship product key material. Generate and **retain**:

```bash
# JWT signing key (sessions / API tokens)
openssl rand -base64 32 > ./jwt-key

# Fernet key (encrypts sensitive columns). Losing this makes ciphertext undecryptable.
python3 -c "from cryptography.fernet import Fernet; print(Fernet.generate_key().decode())" > ./fernet-key
```

Store these in a secret management system. Rotation procedures belong in your ops runbooks; never commit keys to git.

## Basic install

From a checkout of the [Astronomer chart](https://github.com/alphabravo-oss/astronomer) (paths may vary by packaging):

```bash
helm upgrade --install astronomer ./deploy/chart \
  --namespace astronomer --create-namespace \
  --set-file secrets.jwtKey=./jwt-key \
  --set-file secrets.fernetKey=./fernet-key
  # plus hostname, ingress, and storage values for your environment
```

Exact value keys live in the chart’s `values.yaml` and schema for the release you install. Prefer explicit values files over long CLI flags for production.

## Bootstrap admin

On first boot the chart can generate or accept a bootstrap admin password. Retrieve it from the documented secret (commonly an `astronomer-bootstrap` style secret in the install namespace) and sign in through the UI.

Change the password and configure SSO as soon as practical.

## Development vs production

| Concern | Development / smoke | Production |
| --- | --- | --- |
| Postgres | Bundled chart Postgres | Managed or HA external Postgres |
| Redis | Bundled | External / HA Redis |
| Replicas | 1 of each | Multiple server/worker/frontend with PDBs |
| TLS | Optional / local | Required; cert-manager or external certs |
| Ingress | Local / nip.io | Production DNS + TLS |
| Backups | Optional | Scheduled management-plane backups + restore drills |
| NetworkPolicy | Chart defaults | Review and tighten to your network |

The bundled databases are for development, CI, and small smoke environments.

## Post-install checks

1. Pods in the install namespace are Ready (server, worker, frontend, deps).
2. UI loads over HTTPS (or your chosen local URL).
3. Login works with the bootstrap admin.
4. Migrations completed (no stuck migrate job; schema not dirty).
5. You can open **Clusters** and start an adoption (see [Adopt clusters](./adopt-clusters.md)).

## Upgrades

- Read the release notes for the target version.
- Back up Postgres (and note Fernet/JWT key locations) before upgrade.
- `helm upgrade` with the new chart; watch migrate jobs and Argo self-management if enabled.
- Validate UI login, agent connectivity counts, and a sample cluster explorer view.

## Uninstall (careful)

`helm uninstall` removes chart resources but may leave PVCs, secrets, and Argo applications depending on configuration. Treat uninstall of a production plane as a DR event: export audit needs, confirm backups, then remove.

## Related pages

- [Architecture](./architecture.md)
- [Backup and DR](./backup-and-dr.md)
- [Chart overview](./reference/chart-overview.md)
