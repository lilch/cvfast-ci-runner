ARG ALINUX_BASE_IMAGE
FROM ${ALINUX_BASE_IMAGE}

LABEL org.opencontainers.image.source="https://github.com/lilch/cvfast-ci-runner"
LABEL org.opencontainers.image.description="Public reproducible CVFast CI toolchain; no application code or secrets"

ENV PATH="/usr/pgsql-16/bin:${PATH}"

ARG UV_VERSION=0.10.7
ARG UV_SHA256=89de2504407dcf04aece914c6ca3b9d8e60cf9ff39a13031c1df1f7c040cea81
ARG PG_VERSION=16.11-1PGDG.rhel8
ARG PG_BASE_URL=https://mirrors.aliyun.com/postgresql/repos/yum/16/redhat/rhel-8-x86_64
ARG REDIS_VERSION=7.2.16-1.module_redis.7.2.el8.remi
ARG REDIS_BASE_URL=https://mirrors.aliyun.com/remi/enterprise/8/redis72/x86_64

RUN dnf install --assumeyes --setopt=install_weak_deps=False \
      bash \
      ca-certificates \
      curl \
      diffutils \
      fontconfig \
      gcc \
      gcc-c++ \
      git \
      glibc-devel \
      google-noto-sans-cjk-ttc-fonts \
      jq \
      liberation-fonts \
      libreoffice-core \
      libreoffice-writer \
      make \
      python3.11 \
      tar \
      unzip \
      util-linux \
      xz \
      zip \
    && dnf clean all \
    && rm -rf /var/cache/dnf

RUN mkdir -p /tmp/rpms \
    && curl --fail --location --retry 3 --silent --show-error \
      "${PG_BASE_URL}/postgresql16-${PG_VERSION}.x86_64.rpm" \
      -o "/tmp/rpms/postgresql16-${PG_VERSION}.x86_64.rpm" \
    && curl --fail --location --retry 3 --silent --show-error \
      "${PG_BASE_URL}/postgresql16-libs-${PG_VERSION}.x86_64.rpm" \
      -o "/tmp/rpms/postgresql16-libs-${PG_VERSION}.x86_64.rpm" \
    && curl --fail --location --retry 3 --silent --show-error \
      "${PG_BASE_URL}/postgresql16-server-${PG_VERSION}.x86_64.rpm" \
      -o "/tmp/rpms/postgresql16-server-${PG_VERSION}.x86_64.rpm" \
    && curl --fail --location --retry 3 --silent --show-error \
      "${REDIS_BASE_URL}/redis-${REDIS_VERSION}.x86_64.rpm" \
      -o "/tmp/rpms/redis-${REDIS_VERSION}.x86_64.rpm" \
    && printf '%s\n' \
      '702e8c47e8ff4ae09c90ce4b22d96497c5b8a2b07090478601e2f92dc2abef8e  /tmp/rpms/postgresql16-16.11-1PGDG.rhel8.x86_64.rpm' \
      '277df243b56f513ba310808c33e18444368bea3f427ab55297c16b5d86895994  /tmp/rpms/postgresql16-libs-16.11-1PGDG.rhel8.x86_64.rpm' \
      'ae13813d3b4d72b258eb43148eec6a054d20df12d2cf80786eabfc7160c02f56  /tmp/rpms/postgresql16-server-16.11-1PGDG.rhel8.x86_64.rpm' \
      '876cde6ff039dd5c41883fb159dff201fbea1312dedc745cc562e8d0f2a7d95f  /tmp/rpms/redis-7.2.16-1.module_redis.7.2.el8.remi.x86_64.rpm' \
      | sha256sum --check --strict - \
    && dnf install --assumeyes --setopt=install_weak_deps=False /tmp/rpms/*.rpm \
    && curl --fail --location --retry 3 --silent --show-error \
      'https://mirrors.aliyun.com/pypi/packages/71/a9/2735cc9dc39457c9cf64d1ce2ba5a9a8ecbb103d0fb64b052bf33ba3d669/uv-0.10.7-py3-none-manylinux_2_17_x86_64.manylinux2014_x86_64.whl' \
      -o /tmp/uv.whl \
    && echo "${UV_SHA256}  /tmp/uv.whl" | sha256sum --check --strict - \
    && unzip -j /tmp/uv.whl \
      uv-0.10.7.data/scripts/uv \
      uv-0.10.7.data/scripts/uvx \
      -d /usr/local/bin \
    && chmod 0755 /usr/local/bin/uv /usr/local/bin/uvx \
    && rm -rf /tmp/rpms /tmp/uv.whl \
    && dnf clean all \
    && rm -rf /var/cache/dnf \
    && uv --version | grep -Fx "uv ${UV_VERSION}" \
    && python3.11 -c 'import ssl, sys; assert sys.version_info[:2] == (3, 11); assert ssl.OPENSSL_VERSION' \
    && postgres --version | grep -Fx "postgres (PostgreSQL) 16.11" \
    && redis-server --version | grep -F "v=7.2.16" \
    && soffice --version >/dev/null \
    && fc-list | grep -F 'Liberation Sans' >/dev/null \
    && fc-list | grep -F 'Noto Sans CJK' >/dev/null \
    && command -v initdb pg_ctl psql runuser git bash jq gcc g++ make cmp >/dev/null
