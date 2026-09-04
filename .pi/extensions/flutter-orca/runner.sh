#!/usr/bin/env bash
# Owns the Flutter process inside Orca's PTY and leaves a recoverable state marker.
set -u

state_file="${1:?state file is required}"
project_root="${2:?project root is required}"
mkdir -p "$(dirname "$state_file")"

write_state() {
  local phase="$1"
  local exit_code="${2:-}"
  STATE_FILE="$state_file" PHASE="$phase" EXIT_CODE="$exit_code" RUNNER_PID="$$" python - <<'PY'
import json
import os
from pathlib import Path
from time import time

path = Path(os.environ["STATE_FILE"])
try:
    state = json.loads(path.read_text())
except (FileNotFoundError, json.JSONDecodeError):
    state = {"version": 1}
state.update({
    "version": 1,
    "phase": os.environ["PHASE"],
    "runnerPid": int(os.environ["RUNNER_PID"]),
    "updatedAt": int(time() * 1000),
})
exit_code = os.environ.get("EXIT_CODE")
if exit_code:
    state["exitCode"] = int(exit_code)
temporary = path.with_suffix(path.suffix + ".tmp")
temporary.write_text(json.dumps(state, indent=2) + "\n")
temporary.replace(path)
PY
}

exit_code=0
finish() {
  exit_code=$?
  write_state stopped "$exit_code"
}
trap finish EXIT

write_state starting
cd "$project_root"
bash tool/run_orca_android.sh
