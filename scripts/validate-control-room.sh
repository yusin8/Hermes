#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "$0")/.." && pwd)"
cd "$ROOT_DIR"

echo "[1/5] Shell syntax checks"
while IFS= read -r f; do
  bash -n "$f"
  echo "  ok $f"
done < <(find skills -type f -name '*.sh' | sort)

if command -v shellcheck >/dev/null 2>&1; then
  echo "[2/5] ShellCheck"
  while IFS= read -r f; do
    shellcheck "$f"
    echo "  ok shellcheck $f"
  done < <(find skills -type f -name '*.sh' | sort)
else
  echo "[2/5] ShellCheck (skipped: shellcheck not installed)"
fi

echo "[3/5] YAML parse checks"
python3 - <<'PY'
from pathlib import Path
import yaml
failures=[]
for path in sorted(Path('.').rglob('*.yml')) + sorted(Path('.').rglob('*.yaml')):
    if '.git/' in str(path):
        continue
    try:
        yaml.safe_load(path.read_text())
    except Exception as e:
        failures.append((str(path), str(e)))
if failures:
    for p,e in failures:
        print(f'  fail {p}: {e}')
    raise SystemExit(1)
print('  ok yaml parse')
PY

if command -v yamllint >/dev/null 2>&1; then
  echo "  running yamllint"
  yamllint -c .yamllint.yml .
else
  echo "  yamllint not installed, parse check only"
fi

echo "[4/5] Task bus contract checks"
python3 - <<'PY'
from pathlib import Path
import yaml

model = Path('docs/control-room-v1-operating-model.md').read_text()
for token in ['`forbidden_actions`','`needs_user_approval`','`needs_orchestrator_review`']:
    if token not in model:
        raise SystemExit(f'missing contract token in operating model: {token}')

def frontmatter(path):
    text = Path(path).read_text()
    parts = text.split('---')
    if len(parts) < 3:
        raise SystemExit(f'missing frontmatter: {path}')
    return yaml.safe_load(parts[1])

task = frontmatter('templates/task-bus/task-template.md')
result = frontmatter('templates/task-bus/result-template.md')

for k in ['task_id','created_at','requester','assignee','priority','status','objective','context','constraints','forbidden_actions','approval_gate','expected_output']:
    if k not in task:
        raise SystemExit(f'missing task key: {k}')
for k in ['task_id','completed_at','assignee','status','summary','artifacts','risks','next_actions','needs_orchestrator_review','needs_user_approval']:
    if k not in result:
        raise SystemExit(f'missing result key: {k}')

allowed = {'done','blocked','failed'}
if result['status'] not in allowed:
    raise SystemExit(f"invalid result status default: {result['status']}")

print('  ok task bus contract')
PY

echo "[5/5] Basic docs existence checks"
for f in docs/starter-guide.md docs/control-room-v1-operating-model.md docs/task-bus.md; do
  [ -f "$f" ] || { echo "  missing $f"; exit 1; }
  echo "  ok $f"
done

echo "All checks passed."
