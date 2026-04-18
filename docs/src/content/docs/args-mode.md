---
title: Args Mode
description: Non-interactive, deterministic usage for scripts, CI, and AI agents.
---

Args mode is activated whenever you pass any argument to `gltrace`. All prompts are disabled — gltrace either resolves to exactly one job and prints its trace, or exits with a clear error.

## Required flags

Every args-mode invocation needs these three (or their env var equivalents):

```bash
gltrace \
  --gitlab-url https://gitlab.com \
  --project-id 74826611 \
  --token glpat-xxxx \
  ...
```

Set them as environment variables to avoid repeating them:

```bash
export GITLAB_URL="https://gitlab.com"
export GITLAB_PROJECT_ID="74826611"
export GITLAB_TOKEN="glpat-xxxx"
```

## Pipeline mode

Browse and select a job from a pipeline.

### Latest pipeline

Omit `--pipeline-id` and gltrace fetches the latest pipeline automatically:

```bash
gltrace --status failed
```

### Specific pipeline

```bash
gltrace --pipeline-id 2338349786 --status failed
```

### Narrowing to one job

Args mode requires the selection to resolve to exactly one job. Use `--stage` and `--job` to narrow it down:

```bash
# One stage, one job name
gltrace --pipeline-id 2338349786 --stage test --job integration-tests

# Stage only — works if the stage has exactly one matching job
gltrace --pipeline-id 2338349786 --status failed --stage test

# Job name only — works if the name is unique across all stages
gltrace --pipeline-id 2338349786 --job deploy-prod
```

If the selection is still ambiguous (multiple jobs match), gltrace exits non-zero and prints the matching jobs so you can refine further.

### Including downstream pipelines

```bash
gltrace --pipeline-id 2338349786 --include-downstream --status failed --stage test --job integration-tests
```

`--include-downstream` fetches jobs from all bridge-triggered child pipelines and merges them with the parent pipeline jobs.

To restrict to jobs from a specific child pipeline, combine with `--source-pipeline-id`:

```bash
gltrace --pipeline-id 2338349786 --include-downstream --source-pipeline-id 2338349900 --stage test --job integration-tests
```

The `pipe:<id>` hints printed in the job list show you which IDs to use.

## Direct job mode

Fetch a specific job trace without browsing the pipeline:

```bash
gltrace --job-id 13192465937
```

`--job-id` cannot be combined with `--stage`, `--job`, `--status`, `--include-downstream`, or `--source-pipeline-id`.

## Output options

```bash
# Save to an auto-named file (gltrace-project74826611-job13192465937-20260418-143022.log)
gltrace --job-id 13192465937 --save

# Save to a specific path
gltrace --job-id 13192465937 --output ./logs/job.log

# Raw output only — no banners, no metadata (pipe-friendly)
gltrace --job-id 13192465937 --raw

# Combine: raw + save
gltrace --job-id 13192465937 --raw --output ./logs/job.log
```

## Exit codes

| Code | Meaning |
|------|---------|
| `0` | Success — trace printed |
| `1` | Validation error, ambiguous selection, or API failure |
