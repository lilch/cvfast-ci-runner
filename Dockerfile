ARG UBUNTU_BASE_IMAGE
FROM ${UBUNTU_BASE_IMAGE}

LABEL org.opencontainers.image.source="https://github.com/lilch/cvfast-ci-runner"
LABEL org.opencontainers.image.description="Public reproducible CVFast CI toolchain; no application code or secrets"

ENV DEBIAN_FRONTEND=noninteractive
ENV PATH="/usr/lib/postgresql/16/bin:${PATH}"
ENV UV_PYTHON_INSTALL_DIR="/opt/uv-python"

ARG UV_VERSION=0.10.7
ARG UV_SHA256=9ac6cee4e379a5abfca06e78a777b26b7ba1f81cb7935b97054d80d85ac00774

RUN apt-get update \
    && apt-get install --yes --no-install-recommends \
      bash \
      build-essential \
      ca-certificates \
      curl \
      git \
      jq \
      libpq-dev \
      postgresql-16 \
      postgresql-client-16 \
      redis-server \
      tar \
      unzip \
      util-linux \
      xz-utils \
      zip \
      zsh \
    && rm -rf /var/lib/apt/lists/*

RUN curl --fail --location --retry 3 --silent --show-error \
      "https://github.com/astral-sh/uv/releases/download/${UV_VERSION}/uv-x86_64-unknown-linux-gnu.tar.gz" \
      -o /tmp/uv.tar.gz \
    && echo "${UV_SHA256}  /tmp/uv.tar.gz" | sha256sum --check --strict - \
    && tar --extract --gzip --file /tmp/uv.tar.gz --directory /usr/local/bin \
      --strip-components=1 \
      uv-x86_64-unknown-linux-gnu/uv \
      uv-x86_64-unknown-linux-gnu/uvx \
    && rm -f /tmp/uv.tar.gz \
    && uv --version | grep -Fx "uv 0.10.7" \
    && uv python install 3.10.19 3.11.14 \
    && python310="$(uv python find 3.10.19)" \
    && python311="$(uv python find 3.11.14)" \
    && "$python310" -c 'import ssl; assert ssl.OPENSSL_VERSION' \
    && "$python311" -c 'import ssl; assert ssl.OPENSSL_VERSION' \
    && ln -sf "$python310" /usr/local/bin/python3 \
    && ln -sf "$python310" /usr/local/bin/python3.10 \
    && ln -sf "$python311" /usr/local/bin/python3.11 \
    && postgres --version | grep -E '^postgres \(PostgreSQL\) 16\.' \
    && redis-server --version | grep -E 'v=7\.' \
    && runuser --version >/dev/null \
    && git --version \
    && bash --version >/dev/null
