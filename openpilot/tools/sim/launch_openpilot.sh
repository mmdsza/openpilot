#!/usr/bin/env bash

export PASSIVE="0"
export NOBOARD="1"
export SIMULATION="1"
export SKIP_FW_QUERY="1"
export FINGERPRINT="HONDA_CIVIC_2022"

export BLOCK="${BLOCK},camerad,micd,logmessaged,manage_athenad"
# loggerd/encoderd are blocked by default to save resources. Set COLLECT_LOGS=1 to
# keep them running so qlog/rlog and the camera stream are recorded (e.g. for CI artifacts).
if [[ -z "$COLLECT_LOGS" ]]; then
  export BLOCK="${BLOCK},loggerd,encoderd"
fi
if [[ "$CI" ]]; then
  # no display or audio device in CI: the offscreen UI and soundd (alert audio) can't run
  # TODO: offscreen UI should work
  export BLOCK="${BLOCK},ui,soundd"
fi

python3 -c "from openpilot.selfdrive.test.helpers import set_params_enabled; set_params_enabled()"

SCRIPT_DIR=$(dirname "$0")
OPENPILOT_DIR=$SCRIPT_DIR/../../

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null && pwd )"
cd $OPENPILOT_DIR/system/manager && exec ./manager.py
