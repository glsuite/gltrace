# Contributing to gltrace

Thanks for taking the time to contribute.

## Requirements

- bash 4.0+
- curl, jq
- [shellcheck](https://www.shellcheck.net/) — for linting
- [bats-core](https://github.com/bats-core/bats-core) — for tests
- [shfmt](https://github.com/mvdan/sh) — optional, for formatting

```sh
brew install shellcheck bats-core shfmt
```

## Development workflow

```sh
# Lint
shellcheck gltrace

# Run tests
make test

# Format
make fmt
```

## Commit messages

This project uses [Conventional Commits](https://www.conventionalcommits.org/) because releases and the changelog are automated via [release-please](https://github.com/googleapis/release-please).

| Prefix | When to use |
|--------|-------------|
| `feat:` | New flag, new mode, new behaviour |
| `fix:` | Bug fix |
| `docs:` | README, USAGE, or inline help changes only |
| `chore:` | CI, deps, tooling — no user-facing change |
| `test:` | Adding or fixing tests |
| `refactor:` | Internal restructure, no behaviour change |

Breaking changes: add `!` after the type (`feat!:`) and include a `BREAKING CHANGE:` footer.

## Pull requests

1. Fork and create a branch off `main`.
2. Keep PRs focused — one logical change per PR.
3. Ensure `shellcheck gltrace` and `make test` pass locally before pushing.
4. Fill in the PR description — what changed and why.

## Reporting issues

Use the issue templates. Include your OS, bash version (`bash --version`), and the exact command you ran.
