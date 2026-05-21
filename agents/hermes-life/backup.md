# hermes-life - Backup

## Goal

Back up durable agent state without committing secrets.

## Include

- `SOUL.md`
- `config.yaml` with secrets removed
- `memories/`
- `skills/`
- `cron/`
- selected docs

## Exclude

- `.env`
- `auth.json`
- `sessions/`
- `logs/`
- `state.db`
- OAuth token files
- private keys

## Backup Repo

- Repo: `yusin8/Hermes` (private branch/folder policy recommended)
- Visibility: private recommended
- Token scope: least privilege

## Restore

1. Stop the container.
2. Restore files to `/srv/hermes-life/data`.
3. Recreate `.env` from password manager/provider dashboards.
4. Fix ownership if needed.
5. Start the container.
