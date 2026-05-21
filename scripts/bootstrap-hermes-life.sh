#!/usr/bin/env bash
set -euo pipefail

SRC_COMPOSE="/home/ys/workspace/hermes-agent-control-room/deploy/hermes-life/docker-compose.yml"
TARGET_ROOT="/srv/hermes-life"
TARGET_DATA="${TARGET_ROOT}/data"

if [[ ! -f "${SRC_COMPOSE}" ]]; then
  echo "[ERROR] missing compose template: ${SRC_COMPOSE}" >&2
  exit 1
fi

sudo mkdir -p "${TARGET_DATA}"/{memories,skills,cron,sessions,logs}
sudo install -m 0644 "${SRC_COMPOSE}" "${TARGET_ROOT}/docker-compose.yml"

if [[ ! -f "${TARGET_DATA}/.env" ]]; then
  sudo install -m 0600 /dev/null "${TARGET_DATA}/.env"
else
  sudo chmod 0600 "${TARGET_DATA}/.env"
fi

if [[ ! -f "${TARGET_DATA}/config.yaml" ]]; then
  sudo tee "${TARGET_DATA}/config.yaml" >/dev/null <<'YAML'
# Fill exact model IDs with `hermes model` or by editing this file.
# Target routing policy for this agent:
# - Main dialogue: OpenAI GPT-5.5 class
# - Auxiliary tasks: Gemini Flash class
# - Critical verification: Anthropic Claude Opus class

model:
  provider: openai-api
  model: ""

# Configure auxiliary/delegation model IDs after provider auth is complete.
# Recommended flow:
#   1) hermes model
#   2) hermes auth add
#   3) hermes config edit
YAML
  sudo chmod 0600 "${TARGET_DATA}/config.yaml"
fi

if [[ ! -f "${TARGET_DATA}/SOUL.md" ]]; then
  sudo tee "${TARGET_DATA}/SOUL.md" >/dev/null <<'EOF'
# Hermes Life Agent Soul

- Main dialog model: OpenAI GPT-5.5 class
- Auxiliary model: Gemini Flash class
- Critical verification: Anthropic Claude Opus class
- Approval gates required for deploy, destructive operations, credential lifecycle, network exposure, and backup deletion.
EOF
fi

sudo chown -R "$USER":"$USER" "${TARGET_ROOT}"
sudo chmod 0700 "${TARGET_DATA}" "${TARGET_DATA}/memories" "${TARGET_DATA}/skills" "${TARGET_DATA}/cron" "${TARGET_DATA}/sessions" "${TARGET_DATA}/logs"

echo "[OK] Bootstrap complete"
echo "Next: edit ${TARGET_DATA}/.env and run docker compose -f ${TARGET_ROOT}/docker-compose.yml up -d"
