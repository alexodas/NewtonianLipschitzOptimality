#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")/.."
python3 scripts/check-comparator.py --require-selected
for cmd in bwrap lake lean python3; do
  command -v "$cmd" >/dev/null || { echo "missing $cmd" >&2; exit 1; }
done
prefix=$(lean --print-prefix)
for tool in lake leanexport leanchecker nanoda_bin con-ron; do
  test -x "$prefix/bin/$tool" || { echo "missing $prefix/bin/$tool" >&2; exit 1; }
done
tmp=$(mktemp "${TMPDIR:-/tmp}/newtonian-comparator.XXXXXX")
trap 'rm -f "$tmp"' EXIT
python3 - comparator.json "$tmp" "$prefix" <<'PY'
import json
import pathlib
import sys
source, target, prefix = sys.argv[1:]
config = json.loads(pathlib.Path(source).read_text(encoding="utf-8"))
config["external_kernels"] = {
    "nanoda": [f"{prefix}/bin/nanoda_bin"],
    "con-ron": [f"{prefix}/bin/con-ron"],
}
pathlib.Path(target).write_text(json.dumps(config, indent=2) + "\n", encoding="utf-8")
PY
lake comparator --config "$tmp"
