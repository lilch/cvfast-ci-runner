#!/usr/bin/env bash
set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
dockerfile="$repo_root/Dockerfile"
workflow="$repo_root/.github/workflows/build.yml"

rg -F 'FROM ${ALINUX_BASE_IMAGE}' "$dockerfile" >/dev/null
rg -F 'ARG UV_VERSION=0.10.7' "$dockerfile" >/dev/null
rg -F 'ARG UV_SHA256=89de2504407dcf04aece914c6ca3b9d8e60cf9ff39a13031c1df1f7c040cea81' "$dockerfile" >/dev/null
rg -F 'uv-0.10.7-py3-none-manylinux_2_17_x86_64.manylinux2014_x86_64.whl' "$dockerfile" >/dev/null
rg -F 'sha256sum --check --strict' "$dockerfile" >/dev/null
rg -F 'python3.11' "$dockerfile" >/dev/null
rg -F 'postgresql16-16.11-1PGDG.rhel8.x86_64.rpm' "$dockerfile" >/dev/null
rg -F '702e8c47e8ff4ae09c90ce4b22d96497c5b8a2b07090478601e2f92dc2abef8e' "$dockerfile" >/dev/null
rg -F 'postgresql16-devel-16.11-1PGDG.rhel8.x86_64.rpm' "$dockerfile" >/dev/null
rg -F 'ff3e89776b23f93d9c98810858a1c73ced25ffa463033b11c25fd37af751e164' "$dockerfile" >/dev/null
rg -F 'postgresql16-libs-16.11-1PGDG.rhel8.x86_64.rpm' "$dockerfile" >/dev/null
rg -F '277df243b56f513ba310808c33e18444368bea3f427ab55297c16b5d86895994' "$dockerfile" >/dev/null
rg -F 'postgresql16-server-16.11-1PGDG.rhel8.x86_64.rpm' "$dockerfile" >/dev/null
rg -F 'ae13813d3b4d72b258eb43148eec6a054d20df12d2cf80786eabfc7160c02f56' "$dockerfile" >/dev/null
rg -F 'redis-7.2.16-1.module_redis.7.2.el8.remi.x86_64.rpm' "$dockerfile" >/dev/null
rg -F '876cde6ff039dd5c41883fb159dff201fbea1312dedc745cc562e8d0f2a7d95f' "$dockerfile" >/dev/null
for package in fontconfig liberation-fonts google-noto-sans-cjk-ttc-fonts libreoffice-core libreoffice-writer; do
  rg -F "$package" "$dockerfile" >/dev/null
done
rg -F 'fc-list' "$dockerfile" >/dev/null
rg -F 'soffice --version' "$dockerfile" >/dev/null
rg -F 'postgres --version | grep -Fx "postgres (PostgreSQL) 16.11"' "$dockerfile" >/dev/null
rg -F 'redis-server --version | grep -F "v=7.2.16"' "$dockerfile" >/dev/null
if rg -n '^(COPY|ADD)[[:space:]]|astral\.sh/.*/install\.sh|[|][[:space:]]*sh([[:space:]]|$)|uv python install|python3\.10|nodejs' "$dockerfile"; then exit 1; fi

rg -F "if: github.actor == 'lilch'" "$workflow" >/dev/null
rg -F 'runs-on: ubuntu-24.04' "$workflow" >/dev/null
rg -F 'packages: write' "$workflow" >/dev/null
rg -F 'ALINUX_BASE_IMAGE:' "$workflow" >/dev/null
rg -F 'docker build --platform linux/amd64' "$workflow" >/dev/null
rg -F 'docker run --rm --network none --platform linux/amd64' "$workflow" >/dev/null
rg -F 'docker logout ghcr.io' "$workflow" >/dev/null
rg -F 'docker manifest inspect "$runner_digest"' "$workflow" >/dev/null
if rg -n 'pull_request:|push:|schedule:' "$workflow"; then exit 1; fi

yunxiao_build="$repo_root/.ci/yunxiao/build.yml"
rg -F 'DockerBuildPushACR' "$yunxiao_build" >/dev/null
rg -F 'e7nmudczyf5buwnz' "$yunxiao_build" >/dev/null
rg -F 'crpi-g54lgc6qvbpmokra.cn-hangzhou.personal.cr.aliyuncs.com/cvfast/cvfast-ci-runner' "$yunxiao_build" >/dev/null
rg -F '${CI_COMMIT_SHA}' "$yunxiao_build" >/dev/null
rg -F 'ALINUX_BASE_IMAGE' "$yunxiao_build" >/dev/null
if rg -n 'release|deploy|production' "$yunxiao_build"; then exit 1; fi
