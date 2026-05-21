# hermes-life - Docker

## Status

- Container running: pending first deployment
- Image: `nousresearch/hermes-agent:latest`
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

Start from `templates/docker/docker-compose.agent.yml` and set:

- `container_name: hermes-life`
- volume: `/srv/hermes-life/data:/opt/data`
- host ports unique per agent

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
