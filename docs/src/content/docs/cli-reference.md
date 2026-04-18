---
title: CLI Reference
description: All flags and options for gltrace.
---

```
gltrace [options]
```

## Core options

| Flag | Description |
|------|-------------|
| `--gitlab-url <url>` | GitLab base URL (e.g. `https://gitlab.com`). Overrides `GITLAB_URL`. |
| `--project-id <id>` | GitLab numeric project ID. Overrides `GITLAB_PROJECT_ID`. |
| `--pipeline-id <id>` | Pipeline to explore. Omit to use the latest pipeline. Overrides `GITLAB_PIPELINE_ID`. |
| `--job-id <id>` | Fetch a specific job trace directly. Overrides `GITLAB_JOB_ID`. |
| `--token <token>` | GitLab private token with `api` scope. Prefer `GITLAB_TOKEN` env var to avoid exposure in shell history. |

`--pipeline-id` and `--job-id` are mutually exclusive.

## Pipeline filtering

| Flag | Description |
|------|-------------|
| `--stage <name>` | Pre-select a stage by exact name. |
| `--job <name>` | Pre-select a job by exact name within the selected stage. |
| `--status <csv>` | Filter jobs by status. Accepts a single value or comma-separated list. |
| `--include-downstream` | Include jobs from bridge-triggered child pipelines. |
| `--source-pipeline-id <id>` | Restrict results to jobs from one specific source pipeline ID. Use with `--include-downstream`. |

### Valid status values

`created`, `pending`, `running`, `success`, `failed`, `canceled`, `skipped`, `manual`, `scheduled`, `waiting_for_resource`, `preparing`

```bash
# Single status
gltrace --status failed

# Multiple statuses
gltrace --status "failed,canceled"
```

## Output options

| Flag | Description |
|------|-------------|
| `--save` | Save the trace to a file. Auto-names the file if `--output` is not given. |
| `--output <path>` | Save the trace to an explicit file path. Implies `--save`. |
| `--raw` | Print the log only — no banners or metadata. Useful for piping. |

Auto-named files follow the pattern: `gltrace-project<id>-job<id>-<timestamp>.log`

## UI options

| Flag | Description |
|------|-------------|
| `--picker <value>` | Picker to use for interactive stage/job selection. |
| `--no-interactive` | Disable all prompts. Exits non-zero if selection is ambiguous. |
| `-V, --version` | Print version and exit. |
| `-h, --help` | Print help and exit. |

### Picker values

| Value | Behaviour |
|-------|-----------|
| `auto` | Uses `fzf` if available, then `gum`, then shell `select`. Default. |
| `fzf` | Force `fzf`. Exits if not installed. |
| `gum` | Force `gum`. Exits if not installed. |
| `select` | Force shell `select` (no external dependency). |

## Flag conflicts

| Combination | Result |
|-------------|--------|
| `--pipeline-id` + `--job-id` | Error — mutually exclusive |
| `--stage` / `--job` / `--status` / `--include-downstream` + `--job-id` | Error — pipeline flags are not valid in direct job mode |
| `--source-pipeline-id` with non-numeric value | Error |
| `--pipeline-id` with non-numeric value | Error |
| `--job-id` with non-numeric value | Error |
