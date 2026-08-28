#!/usr/bin/env bash
set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
dockerfile="$repo_root/Dockerfile"
workflow="$repo_root/.github/workflows/build.yml"

rg -F 'FROM ${UBUNTU_BASE_IMAGE}' "$dockerfile" >/dev/null
rg -F 'ARG UV_VERSION=0.10.7' "$dockerfile" >/dev/null
rg -F 'ARG UV_SHA256=9ac6cee4e379a5abfca06e78a777b26b7ba1f81cb7935b97054d80d85ac00774' "$dockerfile" >/dev/null
rg -F 'sha256sum --check --strict' "$dockerfile" >/dev/null
rg -F 'uv python install 3.10.19 3.11.14' "$dockerfile" >/dev/null
rg -F 'import ssl' "$dockerfile" >/dev/null
rg -F 'postgresql-16' "$dockerfile" >/dev/null
rg -F 'redis-server' "$dockerfile" >/dev/null
if rg -n '^(COPY|ADD)[[:space:]]|astral\.sh/.*/install\.sh|[|][[:space:]]*sh([[:space:]]|$)' "$dockerfile"; then exit 1; fi

rg -F "if: github.actor == 'lilch'" "$workflow" >/dev/null
rg -F 'runs-on: ubuntu-24.04' "$workflow" >/dev/null
rg -F 'packages: write' "$workflow" >/dev/null
rg -F 'docker build --platform linux/amd64' "$workflow" >/dev/null
rg -F 'docker run --rm --network none --platform linux/amd64' "$workflow" >/dev/null
rg -F 'docker logout ghcr.io' "$workflow" >/dev/null
rg -F 'docker manifest inspect "$runner_digest"' "$workflow" >/dev/null
if rg -n 'pull_request:|push:|schedule:' "$workflow"; then exit 1; fi
