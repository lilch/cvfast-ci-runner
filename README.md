# cvfast-ci-runner

Public, reproducible, CI-only toolchain image for CVFast cloud tests. This repository contains no application source, credentials, customer material, production configuration, or deployment logic.

The image is built manually on a native GitHub-hosted AMD64 runner. Its Ubuntu base, `uv` archive checksum, Python patch versions, and workflow actions are pinned. Consumers must use the emitted immutable `@sha256:` reference; mutable tags are not a release contract.

The workflow is owner-only and has no `push`, `pull_request`, or scheduled trigger. The final step logs out of GHCR and proves the exact digest can be resolved anonymously before the build succeeds.
