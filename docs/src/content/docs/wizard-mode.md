---
title: Wizard Mode
description: Interactive gum-powered prompts for exploring pipelines without memorising flags.
---

Wizard mode launches when you run `gltrace` with no arguments. It guides you through every option interactively using [`gum`](https://github.com/charmbracelet/gum).

## Starting the wizard

```bash
gltrace
```

If `gum` is not installed, gltrace attempts to auto-install it:

- **macOS** — `brew install gum`
- **Debian/Ubuntu** — `apt-get install gum`
- **Arch** — `pacman -S gum`

If auto-install fails, gltrace prints manual install instructions and exits.

## Wizard flow

The wizard walks you through the following steps in order:

1. **GitLab URL** — your instance URL (pre-filled from `GITLAB_URL` if set)
2. **Project ID** — the numeric project ID (pre-filled from `GITLAB_PROJECT_ID` if set)
3. **Private Token** — your access token, entered as a password field (hidden input)
4. **Mode** — choose between `pipeline` (browse jobs) or `job` (fetch a trace directly by job ID)

### Pipeline mode

5. **Pipeline ID** — leave blank to use the latest pipeline
6. **Status filter** — optionally filter by one or more statuses (`failed`, `success`, etc.)
7. **Include downstream** — yes/no to include bridge-triggered child pipeline jobs
8. **Preselect stage** — optionally jump to a specific stage
9. **Preselect job name** — optionally jump to a specific job within that stage

### Job mode

5. **Job ID** — the specific job ID to fetch directly

### Output

10. **Save to file** — yes/no; if yes, prompts for an output path (auto-named if left blank)

## Picker preference

The wizard uses `gum choose` for all selection steps. If you prefer `fzf` for the stage and job pickers, pass `--picker fzf`:

```bash
gltrace --picker fzf
```

See [CLI Reference — UI options](/gltrace/cli-reference/#ui-options) for all picker values.

## Skipping the wizard

Pass any argument to disable wizard mode entirely:

```bash
gltrace --project-id 123 --status failed
```

See [Args Mode](/gltrace/args-mode/) for full non-interactive usage.
