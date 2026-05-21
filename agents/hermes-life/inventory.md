# hermes-life - Inventory

## Role

Personal operator-facing assistant for daily coordination, planning, and synthesis.

## Where It Runs

- Host: VPS (Ubuntu/Debian) or local Docker host
- Deployment style: Docker container
- Container name: `hermes-life`
- Image: `nousresearch/hermes-agent@sha256:b6e41c155d6bfce5ad83c5d0fec670086db8a43250e4511c9474134be5482d33`
- Host data dir: `/srv/hermes-life/data`
- Container data dir: `/opt/data`
- Compose file: `/srv/hermes-life/docker-compose.yml`

## Ports

| Host port | Container port | Purpose | Exposure |
|---|---:|---|---|
| 8642 | 8642 | Gateway/API | localhost |
| 9119 | 9119 | Dashboard | localhost |

## Messaging Integrations

- Telegram: optional
- Slack: optional
- Discord: optional
- Other: CLI first

## Credentials

See `env-map.md`. Do not paste values here.

## Memory & Skills

- Memory: `/srv/hermes-life/data/memories/`
- Skills: `/srv/hermes-life/data/skills/`
- Crons: `/srv/hermes-life/data/cron/`
- Sessions: `/srv/hermes-life/data/sessions/`

## Allowed Work

- planning, drafting, summarization, research triage
- non-destructive repo analysis and local verification
- delegation orchestration with explicit approval gates

## Forbidden Work

- production deploy without explicit approval
- destructive operations without explicit approval
- credential creation/rotation/revocation without explicit approval

## Owner

- yusin8
