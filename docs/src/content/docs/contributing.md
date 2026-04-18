---
title: Contributing
description: How to contribute to gltrace — dev setup, tests, commit conventions, and reporting issues.
---

Thanks for taking the time to contribute to gltrace.

## Requirements

- bash 4.0+
- `curl`, `jq`
- [`shellcheck`](https://www.shellcheck.net/) — linting
- [`bats-core`](https://github.com/bats-core/bats-core) — tests
- [`shfmt`](https://github.com/mvdan/sh) — optional, formatting

```bash
brew install shellcheck bats-core shfmt
```

## Development setup

```bash
git clone https://github.com/glsuite/gltrace.git
cd gltrace
```

No build step — `gltrace` is a single bash script. Edit it directly.

## Running tests

```bash
make test
```

Runs the full [bats](https://github.com/bats-core/bats-core) test suite in `tests/gltrace.bats`. Tests cover flag validation, numeric ID enforcement, mutually exclusive flags, and status filter validation — all without making real API calls.

Install bats if you haven't already:

```bash
make test-deps
```

## Linting

```bash
make lint
```

Runs `shellcheck` on the script. The CI lint workflow runs the same check on every push and PR — fix all warnings before opening a PR.

## Formatting

```bash
make fmt
```

Runs `shfmt -w` if installed. Not required but keeps diffs clean.

## Make targets

| Command | Description |
|---------|-------------|
| `make test` | Run bats test suite |
| `make test-deps` | Install bats-core via brew |
| `make lint` | Run shellcheck |
| `make fmt` | Format with shfmt |
| `make check` | Validate curl + jq are installed |
| `make deps` | Show optional dependency status |
| `make install-local` | Install to `~/.local/bin/gltrace` |

## Commit messages

This project uses [Conventional Commits](https://www.conventionalcommits.org/) — releases and the changelog are automated via [release-please](https://github.com/googleapis/release-please).

| Prefix | When to use |
|--------|-------------|
| `feat:` | New flag, mode, or behaviour |
| `fix:` | Bug fix |
| `docs:` | README, docs site, or inline help only |
| `chore:` | CI, deps, tooling — no user-facing change |
| `test:` | Adding or fixing tests |
| `refactor:` | Internal restructure, no behaviour change |

Breaking changes: add `!` after the type (`feat!:`) and include a `BREAKING CHANGE:` footer.

## Pull requests

1. Fork and branch off `main`.
2. Keep PRs focused — one logical change per PR.
3. Ensure `make lint` and `make test` pass locally before pushing.
4. Fill in the PR description — what changed and why.

## Reporting issues

Use the GitHub issue templates — they prompt for the information needed to reproduce the problem.

- [Bug report](https://github.com/glsuite/gltrace/issues/new?template=bug_report.md)
- [Feature request](https://github.com/glsuite/gltrace/issues/new?template=feature_request.md)

Include your OS, bash version (`bash --version`), gltrace version (`gltrace --version`), and the exact command you ran.
