#!/usr/bin/env bash
# Optional: upload packaged Astronomer *product* docs to a Charlie knowledge
# collection. Docs themselves remain product documentation; this is only a
# distribution path for search/index consumers.
#
# Prefer reading docs on GitHub. This script is not required to use Astronomer.
#
# Required env:
#   CHARLIE_API_KEY
# Optional: CHARLIE_BASE_URL, CHARLIE_PRODUCT_ID, CHARLIE_COLLECTION_ID, ...
set -euo pipefail

VERSION="${1:?product documentation version required, e.g. 0.3.5}"
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
META="$ROOT/versions/$VERSION/_meta.yaml"
DOCS_JSON="$ROOT/dist/astronomer-docs-$VERSION.documents.json"
if [[ ! -f "$DOCS_JSON" && -f "$ROOT/dist/astronomer-knowledge-$VERSION.documents.json" ]]; then
  DOCS_JSON="$ROOT/dist/astronomer-knowledge-$VERSION.documents.json"
fi

if [[ -z "${CHARLIE_API_KEY:-}" ]]; then
  echo "CHARLIE_API_KEY is required for this optional upload path." >&2
  exit 1
fi

BASE="${CHARLIE_BASE_URL:-https://charlie.dev.alphabravo.io}"
BASE="${BASE%/}"
PRODUCT_ID="${CHARLIE_PRODUCT_ID:-product_1a8a43aab5b28bf94f330d1bff3a23c4}"
COLLECTION_ID="${CHARLIE_COLLECTION_ID:-collection_5274991d6d4f7cd95c6ca50a6ea241f5}"
PRODUCT_HDR="${CHARLIE_PRODUCT_HEADER:-astronomer}"
ENVIRONMENT="${CHARLIE_ENVIRONMENT:-development}"
TENANT="${CHARLIE_TENANT:-astronomer-native-179}"

if [[ -f "$META" ]]; then
  while IFS=': ' read -r key val; do
    key="${key// /}"
    val="${val//\"/}"
    case "$key" in
      product_id) PRODUCT_ID="${CHARLIE_PRODUCT_ID:-$val}" ;;
      knowledge_collection_id) COLLECTION_ID="${CHARLIE_COLLECTION_ID:-$val}" ;;
      product_slug) PRODUCT_HDR="${CHARLIE_PRODUCT_HEADER:-$val}" ;;
      environment_id) ENVIRONMENT="${CHARLIE_ENVIRONMENT:-$val}" ;;
      tenant_id) TENANT="${CHARLIE_TENANT:-$val}" ;;
      charlie_central_base_url) BASE="${CHARLIE_BASE_URL:-$val}" ; BASE="${BASE%/}" ;;
    esac
  done < <(grep -E '^(product_id|knowledge_collection_id|product_slug|environment_id|tenant_id|charlie_central_base_url):' "$META" || true)
fi

if [[ ! -f "$DOCS_JSON" ]]; then
  echo "missing $DOCS_JSON — packaging..."
  "$ROOT/scripts/package-version.sh" "$VERSION"
  DOCS_JSON="$ROOT/dist/astronomer-docs-$VERSION.documents.json"
fi

echo "optional knowledge upload: base=$BASE product=$PRODUCT_ID collection=$COLLECTION_ID version=$VERSION"

python3 - "$DOCS_JSON" "$BASE" "$PRODUCT_ID" "$COLLECTION_ID" "$VERSION" <<'PY'
import json, os, sys, urllib.request

docs_path, base, product, collection, version = sys.argv[1:6]
docs = json.loads(open(docs_path, encoding="utf-8").read())
api_key = os.environ["CHARLIE_API_KEY"]
product_hdr = os.environ.get("CHARLIE_PRODUCT_HEADER", "astronomer")
environment = os.environ.get("CHARLIE_ENVIRONMENT", "development")
tenant = os.environ.get("CHARLIE_TENANT", "astronomer-native-179")

def call(method, path, body=None):
    data = None if body is None else json.dumps(body).encode()
    req = urllib.request.Request(
        base + path, data=data, method=method,
        headers={
            "Authorization": f"Bearer {api_key}",
            "Content-Type": "application/json",
            "X-Charlie-Product": product_hdr,
            "X-Charlie-Environment": environment,
            "X-Charlie-Tenant": tenant,
        },
    )
    with urllib.request.urlopen(req, timeout=120) as resp:
        raw = resp.read().decode()
        return json.loads(raw) if raw else {}

for doc in docs:
    meta = {k: str(v) for k, v in (doc.get("metadata") or {}).items()}
    meta.setdefault("kind", "product-docs")
    body = {
        "document_key": doc["document_key"],
        "title": doc["title"],
        "content_type": doc["content_type"],
        "metadata": meta,
        "content": doc["content"],
    }
    call("POST", f"/charlie/v1/products/{product}/knowledge-collections/{collection}/documents", body)
    print("uploaded", doc["document_key"])

rel = call("POST", f"/charlie/v1/products/{product}/knowledge-releases", {
    "product_version": version,
    "collection_id": collection,
})
rid = (rel.get("release") or rel).get("id") or rel.get("id")
print("release", rid)
if rid:
    act = call("POST", f"/charlie/v1/products/{product}/knowledge-releases/{rid}/activate", {})
    print("activate", act)
PY
