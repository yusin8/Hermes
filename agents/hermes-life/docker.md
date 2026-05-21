# hermes-life - Docker

## Status

- Container running: pending first deployment
- Image: `nousresearch/hermes-agent@sha256:b6e41c155d6bfce5ad83c5d0fec670086db8a43250e4511c9474134be5482d33`
- Data dir: `/srv/hermes-life/data`
- Started: pending

## Layout

```text
/srv/hermes-life/
  data/
    .env
    config.yaml
    SOUL.md
    memories/
    skills/
    cron/
    sessions/
    logs/
  docker-compose.yml
```

## Compose

Use generated compose file:

- template copy source: `/home/ys/workspace/hermes-agent-control-room/deploy/hermes-life/docker-compose.yml`
- runtime target: `/srv/hermes-life/docker-compose.yml`
- container name: `hermes-life`
- volume: `/srv/hermes-life/data:/opt/data`
- env: `/srv/hermes-life/data/.env` loaded via optional `env_file`
- host ports: `127.0.0.1:8642`, `127.0.0.1:9119`

## Common Operations

```bash
docker logs -f hermes-life
docker exec -it hermes-life bash
docker compose -f /srv/hermes-life/docker-compose.yml restart
docker compose -f /srv/hermes-life/docker-compose.yml pull
docker compose -f /srv/hermes-life/docker-compose.yml up -d
```

## Gotchas

- Do not run two gateway processes against `/srv/hermes-life/data`.
- Do not commit `.env` or token files.
- Keep host ports unique per agent.
- Prefer binding dashboards/API to `127.0.0.1` unless secured.
- Keep compose hardening enabled: `read_only`, `cap_drop: [ALL]`, `no-new-privileges`.
