---
task_id: TASK-YYYY-MM-DD-001
created_at: YYYY-MM-DDTHH:MM:SSZ
requester: user
assignee: hermes-seo
priority: normal
status: ready
approval_gate:
  required: false # set true when this task includes gated actions
  require_before:
    - production deploys
    - destructive operations
    - credential creation
    - credential rotation
    - credential revocation
    - firewall/network exposure changes
    - deletion of backups/snapshots
objective: "Describe the exact objective."
context:
  - "Add relevant links, paths, and prior decisions."
constraints:
  - "Do not expose secrets."
  - "Do not perform destructive operations without approval."
forbidden_actions:
  - "Do not bypass specialist source-of-truth tools."
  - "Do not publish, deploy, delete, or rotate credentials without explicit approval."
expected_output:
  - Findings
  - Files changed or artifacts created
  - Risks and assumptions
  - Recommended next action
---

# Task Brief

## Objective

Describe the task objective in one sentence.

## Context

Add relevant context and paths.

## Constraints

- Do not expose secrets.
- Do not perform destructive operations without approval.

## Expected Output

- Findings
- Files changed or artifacts created
- Risks and assumptions
- Recommended next action
