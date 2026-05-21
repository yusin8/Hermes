#!/usr/bin/env bash
set -euo pipefail

SRC_COMPOSE="/home/ys/workspace/hermes-agent-control-room/deploy/hermes-life/docker-compose.yml"
DEFAULT_TARGET_ROOT="/srv/hermes-life"
TARGET_ROOT="${TARGET_ROOT:-$DEFAULT_TARGET_ROOT}"
TARGET_DATA="${TARGET_ROOT}/data"
SUDO_CMD=""

if [[ ! -f "${SRC_COMPOSE}" ]]; then
  echo "[ERROR] missing compose template: ${SRC_COMPOSE}" >&2
  exit 1
fi

if [[ "${TARGET_ROOT}" == "${DEFAULT_TARGET_ROOT}" ]]; then
  if sudo -n true >/dev/null 2>&1; then
    SUDO_CMD="sudo"
  elif [[ -d "${DEFAULT_TARGET_ROOT}" && -w "${DEFAULT_TARGET_ROOT}" ]]; then
    SUDO_CMD=""
  else
    TARGET_ROOT="${HOME}/srv/hermes-life"
    TARGET_DATA="${TARGET_ROOT}/data"
    SUDO_CMD=""
    echo "[WARN] sudo unavailable for /srv. Falling back to ${TARGET_ROOT}"
  fi
fi

run() {
  if [[ -n "${SUDO_CMD}" ]]; then
    sudo "$@"
  else
    "$@"
  fi
}

run mkdir -p "${TARGET_DATA}"/{memories,skills,cron,sessions,logs}

COMPOSE_TMP="$(mktemp)"
python3 - <<'PY' "${SRC_COMPOSE}" "${TARGET_ROOT}" "${COMPOSE_TMP}"
from pathlib import Path
import sys
src = Path(sys.argv[1]).read_text()
target_root = sys.argv[2]
out = src.replace('/srv/hermes-life', target_root)
Path(sys.argv[3]).write_text(out)
PY
run install -m 0644 "${COMPOSE_TMP}" "${TARGET_ROOT}/docker-compose.yml"
rm -f "${COMPOSE_TMP}"

if [[ ! -f "${TARGET_DATA}/.env" ]]; then
  run install -m 0600 /dev/null "${TARGET_DATA}/.env"
else
  run chmod 0600 "${TARGET_DATA}/.env"
fi

if [[ ! -f "${TARGET_DATA}/config.yaml" ]]; then
  CFG_TMP="$(mktemp)"
  cat > "${CFG_TMP}" <<'YAML'
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
  run install -m 0600 "${CFG_TMP}" "${TARGET_DATA}/config.yaml"
  rm -f "${CFG_TMP}"
fi

if [[ ! -f "${TARGET_DATA}/SOUL.md" ]]; then
  SOUL_TMP="$(mktemp)"
  cat > "${SOUL_TMP}" <<'EOF'
# Hermes Life Agent Soul

- Main dialog model: OpenAI GPT-5.5 class
- Auxiliary model: Gemini Flash class
- Critical verification: Anthropic Claude Opus class
- Approval gates required for deploy, destructive operations, credential lifecycle, network exposure, and backup deletion.
EOF
  run install -m 0644 "${SOUL_TMP}" "${TARGET_DATA}/SOUL.md"
  rm -f "${SOUL_TMP}"
fi

if [[ -n "${SUDO_CMD}" ]]; then
  run chown -R "$USER":"$USER" "${TARGET_ROOT}"
fi
run chmod 0700 "${TARGET_DATA}" "${TARGET_DATA}/memories" "${TARGET_DATA}/skills" "${TARGET_DATA}/cron" "${TARGET_DATA}/sessions" "${TARGET_DATA}/logs"

echo "[OK] Bootstrap complete"
echo "[OK] Target root: ${TARGET_ROOT}"
echo "Next: edit ${TARGET_DATA}/.env and run docker compose -f ${TARGET_ROOT}/docker-compose.yml up -d"
