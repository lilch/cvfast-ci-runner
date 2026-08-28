# cvfast-ci-runner

Public, reproducible, CI-only toolchain image for CVFast cloud tests. This repository contains no application source, credentials, customer material, production configuration, or deployment logic.

The canonical image is Alibaba Cloud Linux 3, built on native AMD64 in Yunxiao Hangzhou and pushed to the public ACR repository `crpi-g54lgc6qvbpmokra.cn-hangzhou.personal.cr.aliyuncs.com/cvfast/cvfast-ci-runner`. Its Alinux base digest, PostgreSQL 16.11 and Redis 7.2.16 RPM checksums, and `uv` 0.10.7 wheel checksum are pinned. It includes Python 3.11 with SSL, PostgreSQL, Redis, LibreOffice and the font/tooling contract required by cloud tests. Python 3.10 and Node are deliberately not embedded; Yunxiao injects Python 3.10 through `SetupPython` when a test tier requires it.

Consumers must use the emitted immutable `@sha256:` reference; mutable tags are not a release contract. The versioned Yunxiao build definition is [`.ci/yunxiao/build.yml`](.ci/yunxiao/build.yml) and only builds and pushes this CI image. It has no application build, test release, deployment, or production step.

The owner-only GitHub workflow remains a manual GHCR fallback for independent native-AMD64 smoke evidence. It has no `push`, `pull_request`, or scheduled trigger. Its final step logs out of GHCR and proves the exact digest can be resolved anonymously before the build succeeds.
