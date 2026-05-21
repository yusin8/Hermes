# hermes-life - Runbook

## Talk To The Agent

- Telegram: optional
- Slack: optional
- CLI: `hermes`
- Dashboard: `http://127.0.0.1:9119` (if port mapped)

## Check Status

```bash
docker ps
docker logs hermes-life --tail 100
ss -ltnp | grep -E '8642|9119' || true
```

## Restart

```bash
docker compose -f /srv/hermes-life/docker-compose.yml restart
```

## Upgrade

```bash
docker compose -f /srv/hermes-life/docker-compose.yml pull
docker compose -f /srv/hermes-life/docker-compose.yml up -d
```

## Rotate A Key

1. Create the new key in the provider dashboard.
2. Update `/srv/hermes-life/data/.env`.
3. Restart the container if needed.
4. Revoke the old key.
5. Update `env-map.md`.

## Restore From Backup

See `backup.md`.

## Approval Gates

Require explicit owner approval before:

- production deploys
- destructive file operations
- credential create/rotate/revoke
- firewall/network exposure changes
- backup/snapshot deletion
