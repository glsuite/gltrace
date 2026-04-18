#!/usr/bin/env bats
# tests/gltrace.bats — CLI validation tests for gltrace

GLTRACE="${BATS_TEST_DIRNAME}/../gltrace"

# Merge stderr into stdout so err() messages appear in $output
gltrace() { "$GLTRACE" "$@" 2>&1; }

# Unset all env vars that gltrace reads so tests are deterministic regardless
# of what is set in the developer's shell.
setup() {
  unset GITLAB_URL GITLAB_PROJECT_ID GITLAB_PIPELINE_ID GITLAB_JOB_ID GITLAB_TOKEN
}

# Minimal flags required to reach deep validation without a real GitLab instance.
# Tests that exercise validation logic beyond the required-args check use these.
VALID=(--gitlab-url https://gitlab.example.com --project-id 123 --token test-token)

# ---------------------------------------------------------------------------
# Help and version
# ---------------------------------------------------------------------------

@test "--help exits 0" {
  run gltrace --help
  [ "$status" -eq 0 ]
}

@test "--help prints 'Usage'" {
  run gltrace --help
  [[ "$output" == *"Usage"* ]]
}

@test "--version exits 0" {
  run gltrace --version
  [ "$status" -eq 0 ]
}

@test "-V exits 0" {
  run gltrace -V
  [ "$status" -eq 0 ]
}

@test "--version output contains 'gltrace'" {
  run gltrace --version
  [[ "$output" == *"gltrace"* ]]
}

# ---------------------------------------------------------------------------
# Unknown flags
# ---------------------------------------------------------------------------

@test "unknown flag exits non-zero" {
  run gltrace --not-a-real-flag
  [ "$status" -ne 0 ]
}

# ---------------------------------------------------------------------------
# Required argument validation
# ---------------------------------------------------------------------------

@test "missing --gitlab-url exits non-zero" {
  run gltrace --project-id 123 --token tok --pipeline-id 1 --no-interactive
  [ "$status" -ne 0 ]
  [[ "$output" == *"Missing gitlab url"* ]]
}

@test "missing --project-id exits non-zero" {
  run gltrace --gitlab-url https://gitlab.example.com --token tok --pipeline-id 1 --no-interactive
  [ "$status" -ne 0 ]
  [[ "$output" == *"Missing project id"* ]]
}

@test "missing --token exits non-zero" {
  run gltrace --gitlab-url https://gitlab.example.com --project-id 123 --pipeline-id 1 --no-interactive
  [ "$status" -ne 0 ]
  [[ "$output" == *"Missing token"* ]]
}

# ---------------------------------------------------------------------------
# Numeric ID validation (security fix: prevent path traversal in API URLs)
# ---------------------------------------------------------------------------

@test "--pipeline-id rejects non-numeric value" {
  run gltrace "${VALID[@]}" --pipeline-id ../foo
  [ "$status" -ne 0 ]
  [[ "$output" == *"must be numeric"* ]]
}

@test "--pipeline-id rejects path traversal" {
  run gltrace "${VALID[@]}" --pipeline-id ../../etc/passwd
  [ "$status" -ne 0 ]
  [[ "$output" == *"must be numeric"* ]]
}

@test "--pipeline-id accepts a numeric value" {
  run gltrace "${VALID[@]}" --pipeline-id 42 --no-interactive
  # Fails at the network layer, not at validation — ID itself must not error
  [[ "$output" != *"must be numeric"* ]]
}

@test "--job-id rejects non-numeric value" {
  run gltrace "${VALID[@]}" --job-id abc
  [ "$status" -ne 0 ]
  [[ "$output" == *"must be numeric"* ]]
}

@test "--job-id accepts a numeric value" {
  run gltrace "${VALID[@]}" --job-id 99
  [[ "$output" != *"must be numeric"* ]]
}

@test "--source-pipeline-id rejects non-numeric value" {
  run gltrace "${VALID[@]}" --pipeline-id 42 --source-pipeline-id abc
  [ "$status" -ne 0 ]
  [[ "$output" == *"must be numeric"* ]]
}

@test "--source-pipeline-id accepts a numeric value" {
  run gltrace "${VALID[@]}" --pipeline-id 42 --source-pipeline-id 7 --no-interactive
  [[ "$output" != *"must be numeric"* ]]
}

# ---------------------------------------------------------------------------
# Mutually exclusive flags
# ---------------------------------------------------------------------------

@test "--pipeline-id and --job-id together exits non-zero" {
  run gltrace "${VALID[@]}" --pipeline-id 42 --job-id 99
  [ "$status" -ne 0 ]
  [[ "$output" == *"not both"* ]]
}

@test "--stage with --job-id exits non-zero" {
  run gltrace "${VALID[@]}" --job-id 42 --stage build
  [ "$status" -ne 0 ]
}

@test "--status with --job-id exits non-zero" {
  run gltrace "${VALID[@]}" --job-id 42 --status failed
  [ "$status" -ne 0 ]
}

@test "--include-downstream with --job-id exits non-zero" {
  run gltrace "${VALID[@]}" --job-id 42 --include-downstream
  [ "$status" -ne 0 ]
}

# ---------------------------------------------------------------------------
# Status filter validation
# ---------------------------------------------------------------------------

@test "--status rejects an invalid value" {
  run gltrace "${VALID[@]}" --pipeline-id 42 --status notastatus
  [ "$status" -ne 0 ]
  [[ "$output" == *"Invalid status"* ]]
}

@test "--status rejects one invalid value in a CSV list" {
  run gltrace "${VALID[@]}" --pipeline-id 42 --status "failed,notastatus"
  [ "$status" -ne 0 ]
  [[ "$output" == *"Invalid status"* ]]
}

@test "--status accepts a valid single value" {
  run gltrace "${VALID[@]}" --pipeline-id 42 --status failed --no-interactive
  # Fails at the network layer — must not error on the status value itself
  [[ "$output" != *"Invalid status"* ]]
}

@test "--status accepts multiple valid values" {
  run gltrace "${VALID[@]}" --pipeline-id 42 --status "failed,success" --no-interactive
  [[ "$output" != *"Invalid status"* ]]
}
