#!/usr/bin/env bash
# Installs a pre-commit hook that runs check-leaks.sh before every commit.
set -euo pipefail
cd "$(dirname "$0")/.."
mkdir -p .git/hooks
cat > .git/hooks/pre-commit <<'HOOK'
#!/usr/bin/env bash
exec ./scripts/check-leaks.sh
HOOK
chmod +x .git/hooks/pre-commit
echo "pre-commit installed"
