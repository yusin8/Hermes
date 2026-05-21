# hermes-life - First Run Checklist

## 0) Host prerequisite

- Docker Engine + Docker Compose plugin installed
- Current user can run `docker` without sudo
- Ports `8642` and `9119` are free on localhost

```bash
docker --version
docker compose version
ss -ltnp | grep -E ':(8642|9119)\b' || true
```

## 1) Bootstrap runtime files

```bash
cd /home/ys/workspace/hermes-agent-control-room
./scripts/bootstrap-hermes-life.sh
```

Then fill secrets:

- /srv/hermes-life/data/.env
  - OPENAI_API_KEY=<your_openai_key>
  - GEMINI_API_KEY=<your_gemini_key>
  - ANTHROPIC_API_KEY=<your_anthropic_key>
  - TELEGRAM_BOT_TOKEN=<optional>

## 2) Start container

```bash
docker compose -f /srv/hermes-life/docker-compose.yml up -d
docker ps --filter name=hermes-life
docker logs hermes-life --tail 100
```

## 3) Runtime health checks

```bash
ss -ltnp | grep -E ':(8642|9119)\b' || true
curl -sSf http://127.0.0.1:9119/ >/dev/null && echo "dashboard ok" || echo "dashboard pending"
```

## 4) Routing sanity check

Inside container:

```bash
docker exec -it hermes-life bash
hermes model
hermes auth add
hermes config edit
hermes config | sed -n '1,200p'
```

Confirm intent:
- Main dialog: OpenAI GPT-5.5 class
- Auxiliary tasks: Gemini Flash class
- Critical verification/delegation: Claude Opus class

## 5) Security baseline check

Ensure compose includes:
- pinned image digest (not `:latest`)
- `read_only: true`
- `cap_drop: [ALL]`
- `security_opt: [no-new-privileges:true]`

## 6) Approval gates

Before production-impacting actions, require owner approval for:
- deploys
- destructive operations
- key lifecycle changes
- network/firewall exposure changes
- backup deletion

## 7) Backup smoke test

```bash
tar -czf /tmp/hermes-life-backup-$(date +%F).tgz -C /srv/hermes-life data
ls -lh /tmp/hermes-life-backup-*.tgz | tail -n 1
```
