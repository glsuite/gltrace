---
title: Quick Start
description: Get gltrace running in under 2 minutes.
---

## Install

### Homebrew (recommended)

```bash
brew tap glsuite/tools
brew install gltrace
```

### Manual

```bash
git clone https://github.com/glsuite/gltrace.git
cd gltrace
make install-local
```

This copies the script to `~/.local/bin/gltrace`. Make sure `~/.local/bin` is in your `PATH`.

## Set credentials

```bash
export GITLAB_URL="https://gitlab.com"   # or your self-hosted URL
export GITLAB_TOKEN="<your-token>"       # personal access token with api scope
```

Add these to your shell profile (`~/.zshrc`, `~/.bashrc`) to persist them.

## Run

### Wizard mode — no args needed

```bash
gltrace
```

Launches interactive prompts for URL, project, token, pipeline, stage, and job. `gum` is auto-installed if missing.

### Args mode — go straight to a trace

```bash
# All failed jobs in the latest pipeline
gltrace --project-id 74826611 --status failed

# Specific pipeline
gltrace --project-id 74826611 --pipeline-id 2338349786 --status failed

# Specific job by ID
gltrace --project-id 74826611 --job-id 13192465937
```

## Next steps

- [Wizard Mode](/gltrace/wizard-mode/) — interactive prompts in depth
- [Args Mode](/gltrace/args-mode/) — non-interactive usage for scripts and CI
- [AI Agents](/gltrace/ai-agents/) — use gltrace with Claude Code, Cursor, and others
- [CLI Reference](/gltrace/cli-reference/) — all flags and options
