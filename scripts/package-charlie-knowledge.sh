#!/usr/bin/env bash
# Deprecated alias — product docs are packaged with package-version.sh.
# Kept so older CI/docs links do not break; does not imply docs are Charlie-specific.
set -euo pipefail
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
echo "note: package-charlie-knowledge.sh is deprecated; use package-version.sh" >&2
exec "$ROOT/scripts/package-version.sh" "$@"
