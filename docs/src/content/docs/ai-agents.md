---
title: AI Agents
description: Use gltrace with Claude Code, Cursor, Aider, and other AI coding agents.
---

gltrace is designed to be called directly by AI coding agents. Its args mode is deterministic and pipe-friendly — give an agent the right flags and it can read CI failures, diagnose errors, and fix code without you touching the browser.

## How it works

```
You: "CI is failing on main, fix it"

Agent runs:
  gltrace --project-id 123 --pipeline-id 456 --status failed

Agent reads the trace output, finds the root cause, edits the code, pushes a fix.
```

No copy-pasting. No browser tabs. No back-and-forth.

## Setup

The agent needs the same credentials as you:

```bash
export GITLAB_URL="https://gitlab.com"
export GITLAB_TOKEN="glpat-xxxx"
export GITLAB_PROJECT_ID="74826611"
```

Set these in your shell profile. Any agent that inherits your environment can call `gltrace` directly.

## Example workflows

### Diagnose a failing pipeline

Tell your agent the pipeline ID and let it find the failing job:

```
You: Pipeline 2338349786 is failing. What's broken?

Agent runs:
  gltrace --pipeline-id 2338349786 --status failed --no-interactive

Agent reads the trace and reports the error.
```

### Fix a broken test

```
You: The integration tests in pipeline 2338349786 are failing. Fix them.

Agent runs:
  gltrace --pipeline-id 2338349786 --stage test --job integration-tests --no-interactive

Agent reads the trace, identifies the failing assertion, edits the code, done.
```

### Always use the latest pipeline

Omit `--pipeline-id` to have gltrace fetch the latest pipeline automatically:

```
You: CI is red. Fix it.

Agent runs:
  gltrace --status failed --no-interactive
```

### Save trace for context

For long traces, saving to a file gives the agent a stable reference:

```bash
gltrace --pipeline-id 2338349786 --status failed --raw --output /tmp/trace.log
```

## Claude Code

Add gltrace to your Claude Code setup so the agent can call it without permission prompts on every run.

In `.claude/settings.json` (or `~/.claude/settings.json`):

```json
{
  "permissions": {
    "allow": [
      "Bash(gltrace *)"
    ]
  }
}
```

Then in a conversation:

```
You: Pipeline 2338349786 failed in the test stage. Read the trace and fix it.
```

Claude Code will call `gltrace` directly, read the output, and apply a fix — all in one shot.

## Tips

- Always pass `--no-interactive` explicitly when writing agent prompts to prevent gltrace from waiting for input.
- Use `--raw` to strip banners and metadata from the output so the agent gets clean log text.
- Use `--stage` and `--job` to narrow the trace to the relevant job rather than giving the agent the full pipeline output.
- Prefer `GITLAB_TOKEN` env var over `--token` to avoid the token appearing in the agent's context.
