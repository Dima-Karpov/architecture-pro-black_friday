#!/usr/bin/env bash
set -euo pipefail

script_dir="$(dirname "$0")"

"${script_dir}/init-config.sh"
"${script_dir}/init-shard1.sh"
"${script_dir}/init-shard2.sh"
"${script_dir}/enable-sharding.sh"
