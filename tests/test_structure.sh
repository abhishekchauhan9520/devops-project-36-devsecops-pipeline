#!/usr/bin/env bash
set -euo pipefail

required=(
  README.md
  Dockerfile
  app/app.py
  app/requirements.txt
  infra/main.tf
  infra/variables.tf
  .github/workflows/devsecops.yml
)

for file in "${required[@]}"; do
  [[ -f "$file" ]] || { echo "missing: $file" >&2; exit 1; }
done

for forbidden in '.env' 'credentials.json' 'service-account.json'; do
  [[ ! -e "$forbidden" ]] || { echo "forbidden credential file: $forbidden" >&2; exit 1; }
done

grep -q 'github/codeql-action/init@v4' .github/workflows/devsecops.yml
grep -q 'gitleaks/gitleaks-action@v3' .github/workflows/devsecops.yml
grep -q 'aquasecurity/trivy-action@v0.36.0' .github/workflows/devsecops.yml
grep -q 'bridgecrewio/checkov-action@v12' .github/workflows/devsecops.yml
grep -q 'actions/attest-build-provenance@v3' .github/workflows/devsecops.yml
grep -q "soft_fail: false" .github/workflows/devsecops.yml

echo 'Project 36 structure/security assertions passed.'
