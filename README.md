<p align="center">
  <h1 align="center">gltrace</h1>
  <p align="center">
    Terminal-first GitLab pipeline log explorer.
    <br />
    Pull job traces straight into your terminal — or let your AI agent do it.
  </p>
</p>

<p align="center">
  <a href="https://github.com/glsuite/gltrace/releases"><img src="https://img.shields.io/github/v/release/glsuite/gltrace" alt="Latest Release"></a>
  <a href="LICENSE"><img src="https://img.shields.io/badge/license-MIT-blue.svg" alt="MIT License"></a>
  <a href="https://github.com/glsuite/gltrace/actions/workflows/test.yml"><img src="https://img.shields.io/github/actions/workflow/status/glsuite/gltrace/test.yml?branch=main&label=tests" alt="Tests"></a>
  <a href="https://github.com/glsuite/gltrace/actions/workflows/lint.yml"><img src="https://img.shields.io/github/actions/workflow/status/glsuite/gltrace/lint.yml?branch=main&label=lint" alt="Lint"></a>
  <a href="https://github.com/glsuite/gltrace/stargazers"><img src="https://img.shields.io/github/stars/glsuite/gltrace?style=social" alt="GitHub Stars"></a>
</p>

---

```
$ gltrace --project-id 74826611 --pipeline-id 2338349786 --status failed

Pipeline: 2338349786   Jobs: 3   Stages: 2

Select a stage:
> test
  deploy

Select a job in stage 'test':
> integration-tests | #13192465937 | failed | pipe:2338349786

╭──────────────────────────────────╮
│  Job Trace: #13192465937         │
╰──────────────────────────────────╯
$ pytest tests/integration/
FAILED tests/integration/test_auth.py::test_token_expiry
AssertionError: expected 401, got 200
```

---

## Why gltrace?

**CI jobs fail.** The typical workflow is: open GitLab, find the pipeline, click through to the failed job, scroll to the error, copy the relevant bit, paste it somewhere. That's slow for humans and impossible for AI agents.

| Approach | Problem |
|----------|---------|
| **GitLab web UI** | Manual — open browser, find pipeline, click job, scroll |
| **`curl` + GitLab API** | Requires knowing the endpoints, writing pagination logic |
| **GitLab CLI (`glab`)** | General-purpose, verbose for log retrieval, no wizard mode |
| **Copy-paste to AI agent** | You still have to find and copy the log yourself |

**gltrace fills the gap** — a single command to pull any job trace into your terminal, with interactive selection when you don't know the job ID, and full non-interactive mode when you do.

---

## Table of Contents

- [Features](#features)
- [Install](#install)
- [Quick Start](#quick-start)
- [Usage with AI Agents](#usage-with-ai-agents)
- [CLI Reference](#cli-reference)
- [Environment Variables](#environment-variables)
- [Examples](#examples)
- [Make Targets](#make-targets)
- [Requirements](#requirements)

---

## Features

- Works with **any GitLab instance** — gitlab.com or self-hosted
- **Wizard mode** — no-args interactive prompts via `gum` (auto-installs if missing)
- **Args mode** — fully non-interactive, deterministic output, ideal for AI agents and scripts
- **Status filtering** — `--status failed`, `--status failed,success`, etc.
- **Downstream pipelines** — `--include-downstream` pulls jobs from bridge-triggered child pipelines
- **Stage and job selection** — `--stage`, `--job` to jump straight to a specific job
- **Direct job mode** — `--job-id` to fetch a trace without browsing the pipeline
- **Save to file** — `--save`, `--output <path>`
- **Raw output** — `--raw` for clean log text with no banners (pipe-friendly)
- **Flexible picker** — `fzf`, `gum`, or shell `select` for interactive selection

---

## Install

### Manual

```bash
git clone https://github.com/glsuite/gltrace.git
cd gltrace
make install-local
```

Copies the script to `~/.local/bin/gltrace`. Make sure `~/.local/bin` is in your `PATH`.

---

## Quick Start

```bash
export GITLAB_URL="https://gitlab.com"
export GITLAB_TOKEN="<your-token>"
```

### Wizard mode (no args)

```bash
gltrace
```

Launches interactive prompts for URL, project, token, pipeline, stage, and job.

### Args mode

```bash
# Failed jobs in a pipeline (auto-selects if only one match)
gltrace --project-id 74826611 --pipeline-id 2338349786 --status failed

# Fetch a specific job trace directly
gltrace --project-id 74826611 --job-id 13192465937
```

---

## Usage with AI Agents

gltrace is designed as a tool that AI coding agents can call directly. When a CI pipeline fails:

1. Point the agent at the pipeline
2. The agent calls `gltrace --status failed` to pull the failing job traces
3. The agent reads the error, identifies the root cause, and fixes the code
4. No copy-pasting, no browser tabs, no back-and-forth

Works with any agent that can run shell commands — Claude Code, Cursor, Aider, and others.

```bash
# You: "CI is failing, fix it"

# Agent fetches the failing job trace
gltrace --project-id 74826611 --pipeline-id 2338349786 --status failed --stage test --job integration-tests

# Agent reads the output, finds the error, applies a fix, pushes — done
```

---

## CLI Reference

```
gltrace [options]
```

### Core options

| Flag | Description |
|------|-------------|
| `--gitlab-url <url>` | GitLab base URL (e.g. `https://gitlab.com`) |
| `--project-id <id>` | GitLab numeric project ID |
| `--pipeline-id <id>` | Pipeline to explore (omit to use latest) |
| `--job-id <id>` | Fetch a specific job trace directly |
| `--token <token>` | GitLab private token (prefer `GITLAB_TOKEN` env var) |

### Pipeline filtering

| Flag | Description |
|------|-------------|
| `--stage <name>` | Pre-select a stage |
| `--job <name>` | Pre-select a job name within the stage |
| `--status <csv>` | Filter by status: `failed`, `success`, `running`, etc. Accepts comma-separated list |
| `--include-downstream` | Include jobs from bridge-triggered child pipelines |
| `--source-pipeline-id <id>` | Restrict results to one source pipeline ID |

### Output

| Flag | Description |
|------|-------------|
| `--save` | Save trace to file (auto-named if `--output` not given) |
| `--output <path>` | Save trace to an explicit file path |
| `--raw` | Print log only — no banners or metadata (pipe-friendly) |

### UI

| Flag | Description |
|------|-------------|
| `--picker <auto\|fzf\|gum\|select>` | Picker preference for interactive selection |
| `--no-interactive` | Disable all prompts — fail if selection is ambiguous |
| `-V, --version` | Show version |
| `-h, --help` | Show help |

---

## Environment Variables

CLI flags take precedence over environment variables.

| Variable | Description |
|----------|-------------|
| `GITLAB_URL` | GitLab base URL |
| `GITLAB_TOKEN` | Personal access token with `api` scope |
| `GITLAB_PROJECT_ID` | Default project ID |
| `GITLAB_PIPELINE_ID` | Default pipeline ID |
| `GITLAB_JOB_ID` | Default job ID |

---

## Examples

```bash
# No-args wizard — prompts for everything
gltrace

# All failed jobs in a pipeline
gltrace --project-id 74826611 --pipeline-id 2338349786 --status failed

# Failed jobs including child pipelines
gltrace --project-id 74826611 --pipeline-id 2338349786 --status failed --include-downstream

# Jump straight to a specific stage and job
gltrace --project-id 74826611 --pipeline-id 2338349786 --stage test --job integration-tests

# Fetch a job trace directly by ID
gltrace --project-id 74826611 --job-id 13192465937

# Save the trace to a file
gltrace --project-id 74826611 --job-id 13192465937 --output ./logs/job.log

# Clean log output only (no banners) — useful for piping
gltrace --project-id 74826611 --job-id 13192465937 --raw | grep "ERROR"

# Latest pipeline, auto-select if only one failed job
gltrace --project-id 74826611 --status failed --no-interactive
```

---

## Make Targets

| Command | Description |
|---------|-------------|
| `make test` | Run bats test suite |
| `make test-deps` | Install test dependencies (bats-core via brew) |
| `make lint` | Run shellcheck |
| `make fmt` | Format with shfmt (if installed) |
| `make check` | Validate required dependencies (curl, jq) |
| `make deps` | Show optional dependency status (gum, fzf) |
| `make usage` | Show CLI help |
| `make install-local` | Install to `~/.local/bin/gltrace` |

---

## Requirements

| Dependency | Required | Notes |
|------------|----------|-------|
| `bash` | Yes | 4.0+ (macOS ships 3.2 — install via brew) |
| `curl` | Yes | |
| `jq` | Yes | |
| `gum` | Wizard mode only | Auto-installed if missing (brew / apt / pacman) |
| `fzf` | Optional | Used as picker when available |

---

*MIT License. See [LICENSE](LICENSE) for details.*
