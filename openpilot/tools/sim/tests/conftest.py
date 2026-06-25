import os
import shutil
import pytest

from openpilot.common.hardware.hw import Paths

def pytest_addoption(parser):
  parser.addoption("--test_duration", action="store", default=60, type=int, help="Seconds to run metadrive drive")

@pytest.fixture
def test_duration(request):
  return request.config.getoption("--test_duration")

@pytest.fixture(autouse=True)
def preserve_sim_logs(openpilot_function_fixture):
  # Depends on openpilot_function_fixture so this finalizes *first* (pytest tears down
  # dependent fixtures before their dependencies). That lets us copy the recorded
  # qlog/rlog/camera out before OpenpilotPrefix.clean_dirs() wipes the log root, so the
  # logs survive for CI artifact upload. Set SIM_LOG_OUT to enable; no-op otherwise.
  yield
  out = os.environ.get("SIM_LOG_OUT")
  log_root = Paths.log_root()
  if out and os.path.isdir(log_root):
    shutil.copytree(log_root, out, dirs_exist_ok=True)
