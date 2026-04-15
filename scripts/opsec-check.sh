#!/usr/bin/env bash
# OPSEC guardrail for sentinelot-site. Run before every commit.
# Exits non-zero if any forbidden content is present in HTML files.

set -u

REPO_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
cd "$REPO_ROOT"

FAIL=0

FORBIDDEN_WORDS=(
  "Shodan"
  "shodan"
  "Censys"
  "censys"
  "SOAP"
  "Soap Engineering"
  "soap engineering"
  "Outer Eye"
  "outer eye"
  "memo"
  "Memo"
)

HTML_FILES=(index.html about.html methodology.html privacy.html terms.html)

echo "== OPSEC check =="
for f in "${HTML_FILES[@]}"; do
  if [ ! -f "$f" ]; then
    continue
  fi
  for word in "${FORBIDDEN_WORDS[@]}"; do
    if grep -Fn -- "$word" "$f" > /dev/null; then
      echo "FAIL: '$word' found in $f"
      grep -Fn -- "$word" "$f"
      FAIL=1
    fi
  done
done

echo ""
echo "== Em dash check =="
for f in "${HTML_FILES[@]}"; do
  if [ ! -f "$f" ]; then
    continue
  fi
  if grep -n $'\xe2\x80\x94' "$f" > /dev/null; then
    echo "FAIL: em dash found in $f"
    grep -n $'\xe2\x80\x94' "$f"
    FAIL=1
  fi
done

echo ""
if [ $FAIL -eq 0 ]; then
  echo "OK: no forbidden content found"
  exit 0
else
  echo "FAIL: OPSEC check found issues"
  exit 1
fi
