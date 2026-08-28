#!/usr/bin/env bash
set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
dockerfile="$repo_root/Dockerfile"
light_dockerfile="$repo_root/Dockerfile.light"
workflow="$repo_root/.github/workflows/build.yml"

rg -F 'FROM ${ALINUX_BASE_IMAGE}' "$dockerfile" >/dev/null
rg -F 'ARG UV_VERSION=0.10.7' "$dockerfile" >/dev/null
rg -F 'PIP_INDEX_URL="https://pypi.tuna.tsinghua.edu.cn/simple"' "$dockerfile" >/dev/null
rg -F 'UV_DEFAULT_INDEX="https://pypi.tuna.tsinghua.edu.cn/simple"' "$dockerfile" >/dev/null
rg -F 'ARG UV_SHA256=89de2504407dcf04aece914c6ca3b9d8e60cf9ff39a13031c1df1f7c040cea81' "$dockerfile" >/dev/null
rg -F 'uv-0.10.7-py3-none-manylinux_2_17_x86_64.manylinux2014_x86_64.whl' "$dockerfile" >/dev/null
rg -F 'sha256sum --check --strict' "$dockerfile" >/dev/null
rg -F 'python3.11' "$dockerfile" >/dev/null
rg -F 'postgresql16-16.11-1PGDG.rhel8.x86_64.rpm' "$dockerfile" >/dev/null
rg -F '702e8c47e8ff4ae09c90ce4b22d96497c5b8a2b07090478601e2f92dc2abef8e' "$dockerfile" >/dev/null
if rg -F 'postgresql16-devel' "$dockerfile"; then exit 1; fi
rg -F 'postgresql16-libs-16.11-1PGDG.rhel8.x86_64.rpm' "$dockerfile" >/dev/null
rg -F '277df243b56f513ba310808c33e18444368bea3f427ab55297c16b5d86895994' "$dockerfile" >/dev/null
rg -F 'postgresql16-server-16.11-1PGDG.rhel8.x86_64.rpm' "$dockerfile" >/dev/null
rg -F 'ae13813d3b4d72b258eb43148eec6a054d20df12d2cf80786eabfc7160c02f56' "$dockerfile" >/dev/null
rg -F 'redis-7.2.16-1.module_redis.7.2.el8.remi.x86_64.rpm' "$dockerfile" >/dev/null
rg -F '876cde6ff039dd5c41883fb159dff201fbea1312dedc745cc562e8d0f2a7d95f' "$dockerfile" >/dev/null
for package in diffutils fontconfig liberation-fonts google-noto-sans-cjk-ttc-fonts libreoffice-core libreoffice-writer; do
  rg -F "$package" "$dockerfile" >/dev/null
done
rg -F 'command -v initdb pg_ctl psql runuser git bash jq gcc g++ make cmp' "$dockerfile" >/dev/null
rg -F 'fc-list' "$dockerfile" >/dev/null
rg -F 'soffice --version' "$dockerfile" >/dev/null
rg -F 'postgres --version | grep -Fx "postgres (PostgreSQL) 16.11"' "$dockerfile" >/dev/null
rg -F 'redis-server --version | grep -F "v=7.2.16"' "$dockerfile" >/dev/null
if rg -n '^(COPY|ADD)[[:space:]]|astral\.sh/.*/install\.sh|[|][[:space:]]*sh([[:space:]]|$)|uv python install|python3\.10|nodejs' "$dockerfile"; then exit 1; fi

rg -F 'FROM ${ALINUX_BASE_IMAGE}' "$light_dockerfile" >/dev/null
rg -F 'ARG UV_VERSION=0.10.7' "$light_dockerfile" >/dev/null
rg -F 'PIP_INDEX_URL="https://pypi.tuna.tsinghua.edu.cn/simple"' "$light_dockerfile" >/dev/null
rg -F 'UV_DEFAULT_INDEX="https://pypi.tuna.tsinghua.edu.cn/simple"' "$light_dockerfile" >/dev/null
for package in diffutils gcc gcc-c++ git glibc-devel jq make python3.11; do
  rg -F "$package" "$light_dockerfile" >/dev/null
done
rg -F 'command -v git bash jq gcc g++ make cmp' "$light_dockerfile" >/dev/null
if rg -n 'postgresql|redis|libreoffice|fontconfig|liberation-fonts|noto.*fonts|^(COPY|ADD)[[:space:]]|uv python install|python3\.10|nodejs' "$light_dockerfile"; then exit 1; fi

rg -F "if: github.actor == 'lilch'" "$workflow" >/dev/null
rg -F 'runs-on: ubuntu-24.04' "$workflow" >/dev/null
rg -F 'packages: write' "$workflow" >/dev/null
rg -F 'ALINUX_BASE_IMAGE: alibaba-cloud-linux-3-registry.cn-hangzhou.cr.aliyuncs.com/alinux3/alinux3@sha256:f89f2535f5fa263d951ac91c34bd1b7114ea85e0ee9b54c61832f09ed4e6f314' "$workflow" >/dev/null
rg -F 'docker build --platform linux/amd64' "$workflow" >/dev/null
rg -F 'docker run --rm --network none --platform linux/amd64' "$workflow" >/dev/null
rg -F 'docker logout ghcr.io' "$workflow" >/dev/null
rg -F 'docker manifest inspect "$runner_digest"' "$workflow" >/dev/null
if rg -n 'pull_request:|push:|schedule:' "$workflow"; then exit 1; fi

yunxiao_build="$repo_root/.ci/yunxiao/build.yml"
rg -F 'DockerBuildPushACR' "$yunxiao_build" >/dev/null
rg -F 'e7nmudczyf5buwnz' "$yunxiao_build" >/dev/null
rg -F 'artifact: runner_image' "$yunxiao_build" >/dev/null
rg -F 'artifact: runner_light_image' "$yunxiao_build" >/dev/null
rg -F 'dockerfilePath: Dockerfile' "$yunxiao_build" >/dev/null
rg -F 'dockerfilePath: Dockerfile.light' "$yunxiao_build" >/dev/null
rg -F 'crpi-g54lgc6qvbpmokra.cn-hangzhou.personal.cr.aliyuncs.com/cvfast/cvfast-ci-runner' "$yunxiao_build" >/dev/null
rg -F '${CI_COMMIT_SHA}' "$yunxiao_build" >/dev/null
rg -F 'light-${CI_COMMIT_SHA}' "$yunxiao_build" >/dev/null
rg -F 'ALINUX_BASE_IMAGE=alibaba-cloud-linux-3-registry.cn-hangzhou.cr.aliyuncs.com/alinux3/alinux3@sha256:f89f2535f5fa263d951ac91c34bd1b7114ea85e0ee9b54c61832f09ed4e6f314' "$yunxiao_build" >/dev/null
if rg -n 'release|deploy|production' "$yunxiao_build"; then exit 1; fi
