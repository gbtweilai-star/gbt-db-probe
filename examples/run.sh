#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")/.."
PYTHONPATH=src python -m gbt_db_probe info
PYTHONPATH=src python -m gbt_db_probe check --payload '{}'
PYTHONPATH=src python -m gbt_db_probe run   --payload '{}'
