#!/usr/bin/env bash
# Internal link check for sentinelot-site.
# Extracts href values from HTML files and verifies each local target exists.

set -u

REPO_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
cd "$REPO_ROOT"

FAIL=0
HTML_FILES=(index.html about.html methodology.html privacy.html terms.html)

echo "== Link check =="
for f in "${HTML_FILES[@]}"; do
  if [ ! -f "$f" ]; then
    continue
  fi
  # Extract href values
  while IFS= read -r href; do
    # Skip external, anchor-only, mailto, tel, and javascript
    case "$href" in
      http*|mailto:*|tel:*|javascript:*|\#*|"")
        continue
        ;;
    esac
    # Strip leading slash and fragment
    target="${href#/}"
    target="${target%%#*}"
    if [ -z "$target" ]; then
      continue
    fi
    if [ ! -e "$target" ]; then
      echo "FAIL: $f references missing $target"
      FAIL=1
    fi
  done < <(grep -oE 'href="[^"]*"' "$f" | sed -E 's/href="([^"]*)"/\1/')
done

if [ $FAIL -eq 0 ]; then
  echo "OK: all internal links resolve"
  exit 0
else
  echo "FAIL: link check found broken links"
  exit 1
fi
