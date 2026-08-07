#!/usr/bin/env bash
# Package versioned Markdown under versions/<ver> into dist artifacts.
#
# Usage:
#   ./scripts/package-version.sh 0.3.5
#   OUT=/tmp/out ./scripts/package-version.sh 0.3.5
set -euo pipefail
VERSION="${1:?product documentation version required, e.g. 0.3.5}"
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
SRC="$ROOT/versions/$VERSION"
OUT_DIR="${OUT:-$ROOT/dist}"
if [[ ! -d "$SRC" ]]; then
  echo "missing version tree: $SRC" >&2
  exit 1
fi
mkdir -p "$OUT_DIR"
MANIFEST="$OUT_DIR/astronomer-docs-$VERSION.manifest.txt"
COMBINED="$OUT_DIR/astronomer-docs-$VERSION.md"
: >"$MANIFEST"
: >"$COMBINED"
{
  echo "# Astronomer documentation $VERSION"
  echo
  echo "Generated $(date -u +%Y-%m-%dT%H:%M:%SZ). Product version: $VERSION"
  echo
} >>"$COMBINED"
while IFS= read -r -d '' f; do
  rel="${f#"$SRC/"}"
  echo "$rel" >>"$MANIFEST"
  {
    echo
    echo "---"
    echo
    echo "<!-- source: $rel -->"
    echo
    cat "$f"
    echo
  } >>"$COMBINED"
done < <(find "$SRC" -type f \( -name '*.md' -o -name '*.yaml' -o -name '*.yml' \) \
  ! -name '_meta.yaml' -print0 | sort -z)

python3 - "$SRC" "$OUT_DIR" "$VERSION" <<'PY'
import json, pathlib, sys
src, out, version = map(pathlib.Path, sys.argv[1:4])
docs = []
for path in sorted(src.rglob("*")):
    if not path.is_file() or path.name == "_meta.yaml" or path.name.startswith("_meta"):
        continue
    if path.suffix.lower() not in {".md", ".yaml", ".yml"}:
        continue
    rel = path.relative_to(src).as_posix()
    docs.append({
        "document_key": f"astronomer/{version}/{rel}",
        "title": path.stem.replace("-", " ").title(),
        "content_type": "text/markdown" if path.suffix.lower() == ".md" else "text/yaml",
        "metadata": {
            "product": "astronomer",
            "product_version": str(version),
            "path": rel,
            "kind": "product-docs",
        },
        "content": path.read_text(encoding="utf-8"),
    })
bundle = out / f"astronomer-docs-{version}.documents.json"
bundle.write_text(json.dumps(docs, indent=2), encoding="utf-8")
print(f"wrote {bundle} ({len(docs)} documents)")
PY
echo "manifest: $MANIFEST"
echo "combined: $COMBINED"
