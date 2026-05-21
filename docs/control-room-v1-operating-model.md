# Control Room v1 Operating Model

This document defines an executable baseline for a team-based Hermes deployment.

## Objective

Run a multi-agent team with clear model routing, explicit approval gates, and reproducible quality checks.

## Model Routing Policy

Primary conversation path:

- Main dialogue model: OpenAI (GPT-5.5 class)
- Purpose: operator-facing synthesis, planning, decision support, final responses

Auxiliary/support path:

- Lightweight support model: Gemini Flash class
- Purpose: context compression, session search summarization, lightweight classification, simple extraction

High-stakes coding verification path:

- Verification model: Anthropic Claude Opus class
- Purpose: final code review, security-sensitive change review, architecture risk review

## Team Topology

- `hermes-orchestrator`: optional front door and synthesis layer
- `hermes-dev`: implementation and debugging
- `hermes-ops`: VPS, runtime, backup, monitoring
- `hermes-seo` / `hermes-cmo`: domain specialists

The operator can always bypass the orchestrator and talk to specialists directly.

## Delegation Rules

1. Orchestrator decides direct-answer vs delegate.
2. Delegated tasks must include:
   - objective
   - context and paths
   - constraints
   - forbidden actions
   - required output format
   - approval requirements
3. Specialist returns artifacts + concise status to task bus outbox.
4. Orchestrator synthesizes and returns one operator-facing result.

## Approval Gates

Changes requiring explicit operator approval:

- production deploys
- destructive file operations
- credential creation/rotation/revocation
- firewall/network exposure changes
- deletion of backups/snapshots

Changes allowed without explicit approval:

- read-only inspection
- local documentation updates
- non-destructive lint/test runs

## Quality Gate (per implementation step)

1. Local validation
   - shell syntax check (`bash -n`)
   - YAML parse check
2. Agent-level review
   - spec compliance review
3. External cross-validation
   - Codex review over changed files
4. High-stakes review (when needed)
   - Anthropic review for risky/security-critical code

## High-Stakes Trigger Criteria

Treat work as high-stakes when any of the following is true:

- security controls, auth, credential scopes, or secret handling are changed
- production runtime behavior can change (deploy, infra, firewall, ingress)
- destructive actions are requested or implied
- financial, compliance, or legal impact is possible
- low observability + high blast-radius changes are bundled together

When high-stakes is triggered, add Anthropic verification before operator sign-off.

## Task Bus Contract

Suggested runtime:

- `/srv/agent-bus/registry/agents.yaml`
- `/srv/agent-bus/tasks/<role>/{inbox,working,outbox,archive}`

Task envelope minimal fields:

- `task_id`
- `created_at`
- `requester`
- `assignee`
- `priority`
- `status`
- `objective`
- `context`
- `constraints`
- `forbidden_actions`
- `approval_gate`
- `expected_output`

Result envelope minimal fields:

- `task_id`
- `completed_at`
- `assignee`
- `status` (`done|blocked|failed`)
- `summary`
- `artifacts`
- `risks`
- `next_actions`
- `needs_orchestrator_review`
- `needs_user_approval`

## Security Baseline

- Keep control plane docs in `/root/agent-control-room`.
- Keep runtime secrets and memory in `/srv/<agent-name>/data`.
- Do not commit raw secrets, OAuth refresh tokens, passwords, or private keys.
- Use per-agent keys with least privilege and rotation tracking.

## CI Baseline

At minimum, run on PR/push:

- markdown lint
- shell lint/syntax
- YAML validation
- dead link check for docs (optional but recommended)

## Rollout Sequence

1. Level 1: one agent + control room docs complete
2. Level 2: direct specialists split by role and credential scope
3. Level 3: orchestrator + task bus routing
4. Level 4: recurring automated workflows only after manual flow is stable
