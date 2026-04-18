---
title: Environment Variables
description: All environment variables read by gltrace.
---

CLI flags take precedence over environment variables. Set environment variables in your shell profile to avoid repeating them on every invocation.

## Variables

| Variable | CLI flag | Description |
|----------|----------|-------------|
| `GITLAB_URL` | `--gitlab-url` | GitLab base URL (e.g. `https://gitlab.com`) |
| `GITLAB_TOKEN` | `--token` | Personal access token with `api` scope |
| `GITLAB_PROJECT_ID` | `--project-id` | Default project ID |
| `GITLAB_PIPELINE_ID` | `--pipeline-id` | Default pipeline ID |
| `GITLAB_JOB_ID` | `--job-id` | Default job ID |

## Recommended shell profile setup

```bash
# ~/.zshrc or ~/.bashrc

export GITLAB_URL="https://gitlab.com"
export GITLAB_TOKEN="glpat-xxxxxxxxxxxxxxxxxxxx"
export GITLAB_PROJECT_ID="74826611"   # optional — useful if you work on one project most of the time
```

With `GITLAB_URL`, `GITLAB_TOKEN`, and `GITLAB_PROJECT_ID` set, most invocations reduce to:

```bash
# Wizard
gltrace

# Latest failed job
gltrace --status failed --no-interactive

# Specific pipeline
gltrace --pipeline-id 2338349786 --status failed
```

## Token security

- Prefer `GITLAB_TOKEN` over `--token` — CLI flags appear in `ps aux` and shell history.
- Use a token with the minimum required scope: `api` (read access to pipelines and job traces).
- Rotate your token regularly. GitLab supports token expiry dates — set one.
