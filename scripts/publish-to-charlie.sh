#!/usr/bin/env bash
# Upload packaged Astronomer knowledge docs to Charlie central, publish a
# product_version release, and activate it.
#
# Requires a Charlie **config_admin** API key (Bearer). Agent enrollment
# credentials (cr_/ce_) are rejected with auth.forbidden.
#
# Required env:
#   CHARLIE_API_KEY          config_admin bearer token
# Optional env:
#   CHARLIE_BASE_URL         default https://charlie.dev.alphabravo.io
#   CHARLIE_PRODUCT_ID       default from versions/<ver>/_meta.yaml or built-in dev id
#   CHARLIE_COLLECTION_ID    default from _meta.yaml or built-in dev id
#   CHARLIE_PRODUCT_HEADER   default astronomer (X-Charlie-Product)
#   CHARLIE_ENVIRONMENT      default development
#   CHARLIE_TENANT           default astronomer-native-179
#
# Usage:
#   CHARLIE_API_KEY=... ./scripts/publish-to-charlie.sh 0.3.5
set -euo pipefail

VERSION="${1:?product documentation version required, e.g. 0.3.5}"
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
META="$ROOT/versions/$VERSION/_meta.yaml"
DOCS_JSON="$ROOT/dist/astronomer-knowledge-$VERSION.documents.json"

if [[ -z "${CHARLIE_API_KEY:-}" ]]; then
  echo "CHARLIE_API_KEY is required (Charlie config_admin bearer)." >&2
  echo "Agent credentials cannot publish knowledge." >&2
  exit 1
fi

BASE="${CHARLIE_BASE_URL:-https://charlie.dev.alphabravo.io}"
BASE="${BASE%/}"

# Defaults for the astronomer.dev native test install; override via env or _meta.yaml.
PRODUCT_ID="${CHARLIE_PRODUCT_ID:-product_1a8a43aab5b28bf94f330d1bff3a23c4}"
COLLECTION_ID="${CHARLIE_COLLECTION_ID:-collection_5274991d6d4f7cd95c6ca50a6ea241f5}"
PRODUCT_HDR="${CHARLIE_PRODUCT_HEADER:-astronomer}"
ENVIRONMENT="${CHARLIE_ENVIRONMENT:-development}"
TENANT="${CHARLIE_TENANT:-astronomer-native-179}"

if [[ -f "$META" ]]; then
  # shellcheck disable=SC2016
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
  echo "missing $DOCS_JSON — running package script..."
  "$ROOT/scripts/package-charlie-knowledge.sh" "$VERSION"
fi

AUTH="Authorization: Bearer ${CHARLIE_API_KEY}"
HDRS=(-H "$AUTH" -H "Content-Type: application/json" \
  -H "X-Charlie-Product: $PRODUCT_HDR" \
  -H "X-Charlie-Environment: $ENVIRONMENT" \
  -H "X-Charlie-Tenant: $TENANT")

echo "base=$BASE product=$PRODUCT_ID collection=$COLLECTION_ID version=$VERSION"

# 1) Upload each document (upsert by document_key when supported; otherwise new version).
python3 - "$DOCS_JSON" "$BASE" "$PRODUCT_ID" "$COLLECTION_ID" <<'PY'
import json, os, sys, urllib.request

docs_path, base, product, collection = sys.argv[1:5]
docs = json.loads(open(docs_path, encoding="utf-8").read())
api_key = os.environ["CHARLIE_API_KEY"]
product_hdr = os.environ.get("CHARLIE_PRODUCT_HEADER", "astronomer")
environment = os.environ.get("CHARLIE_ENVIRONMENT", "development")
tenant = os.environ.get("CHARLIE_TENANT", "astronomer-native-179")
url = f"{base}/charlie/v1/products/{product}/knowledge-collections/{collection}/documents"
version_ids = []
for doc in docs:
    body = {
        "document_key": doc["document_key"],
        "title": doc["title"],
        "content_type": doc.get("content_type", "text/markdown"),
        "content": doc["content"],
        "metadata": doc.get("metadata") or {},
    }
    # Some APIs use "body"/"text" — openapi KnowledgeDocumentUpload may use content.
    data = json.dumps(body).encode()
    req = urllib.request.Request(url, data=data, method="POST", headers={
        "Authorization": f"Bearer {api_key}",
        "Content-Type": "application/json",
        "X-Charlie-Product": product_hdr,
        "X-Charlie-Environment": environment,
        "X-Charlie-Tenant": tenant,
    })
    try:
        with urllib.request.urlopen(req, timeout=60) as resp:
            out = json.loads(resp.read().decode())
    except Exception as e:
        err = e.read().decode() if hasattr(e, "read") else str(e)
        print(f"UPLOAD_FAIL {doc['document_key']}: {getattr(e, 'code', '')} {err}", file=sys.stderr)
        sys.exit(1)
    ver = None
    if isinstance(out.get("current_version"), dict):
        ver = out["current_version"].get("id")
    ver = ver or out.get("id")
    print(f"uploaded {doc['document_key']} -> {out.get('id')} version={ver}")
    if ver:
        version_ids.append(ver)
print(json.dumps({"document_version_ids": version_ids}))
open(os.environ.get("PUBLISH_STATE", "/tmp/charlie-publish-state.json"), "w").write(
    json.dumps({"document_version_ids": version_ids, "upload_responses_count": len(docs)}, indent=2)
)
PY

# 2) Publish release
RELEASE_BODY=$(python3 -c 'import json,sys; print(json.dumps({"product_version": sys.argv[1]}))' "$VERSION")
RELEASE_JSON=$(curl -sS -X POST \
  "$BASE/charlie/v1/products/$PRODUCT_ID/knowledge-collections/$COLLECTION_ID/releases" \
  "${HDRS[@]}" \
  -d "$RELEASE_BODY")
echo "publish_response=$RELEASE_JSON"
RELEASE_ID=$(echo "$RELEASE_JSON" | python3 -c 'import sys,json; d=json.load(sys.stdin); print(d.get("id") or d.get("data",{}).get("id") or "")')
if [[ -z "$RELEASE_ID" ]]; then
  echo "failed to parse release id" >&2
  exit 1
fi
echo "release_id=$RELEASE_ID"

# 3) Activate
ACTIVATE_JSON=$(curl -sS -X POST \
  "$BASE/charlie/v1/products/$PRODUCT_ID/knowledge-collections/$COLLECTION_ID/releases/$RELEASE_ID/activate" \
  "${HDRS[@]}")
echo "activate_response=$ACTIVATE_JSON"

# 4) List indexes (best-effort)
curl -sS "$BASE/charlie/v1/knowledge-indexes" "${HDRS[@]}" | python3 -m json.tool 2>/dev/null | head -80 || true

echo
echo "Done. Confirm indexes ready, then smoke-query knowledge for product_version=$VERSION."
echo " monorepo TEST-RUN checklist: versions/$VERSION/TEST-RUN.md"
