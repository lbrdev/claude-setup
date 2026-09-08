#!/usr/bin/env bash
# Scans the repository tree for secrets, personal paths and private names.
# Runs from the pre-commit hook and by hand before a push.
set -uo pipefail
cd "$(dirname "$0")/.." || exit 1
DICT="scripts/private-words.txt"
fail=0

scan() { # heading, regex
  local hits
  hits=$(grep -rIinE "$2" . \
    --exclude-dir=.git --exclude-dir=node_modules \
    --exclude=private-words.txt --exclude=check-leaks.sh 2>/dev/null)
  if [ -n "$hits" ]; then
    printf '\n[!] %s\n%s\n' "$1" "$hits"
    fail=1
  fi
}

scan "Tokens and keys" \
  '(gh[pousr]_[A-Za-z0-9]{16,}|sk-[A-Za-z0-9]{20,}|xox[baprs]-[A-Za-z0-9-]{10,}|AKIA[0-9A-Z]{16}|-----BEGIN [A-Z ]*PRIVATE KEY|Bearer [A-Za-z0-9._-]{25,})'

scan "Absolute paths into a home directory" \
  '/(Users|home)/[a-z][A-Za-z0-9._-]+/'

scan "UUIDs (may be API keys or session ids)" \
  '\b[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}\b'

scan "originSessionId" 'originSessionId'

if [ -f "$DICT" ]; then
  hits=$(grep -rIinFf "$DICT" . \
    --exclude-dir=.git --exclude-dir=node_modules \
    --exclude=private-words.txt --exclude=check-leaks.sh 2>/dev/null)
  if [ -n "$hits" ]; then
    printf '\n[!] Private names from %s\n%s\n' "$DICT" "$hits"
    fail=1
  fi
fi

if [ "$fail" -eq 0 ]; then
  echo "check-leaks: clean"
else
  printf '\ncheck-leaks: MATCHES FOUND — deal with them before committing.\n'
  printf 'False positive? Tighten the regex or add an explicit exclusion.\n'
fi
exit "$fail"
