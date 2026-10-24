#!/usr/bin/env bash
set -euo pipefail

source "$(dirname "$0")/common.sh"

mongosh_exec mongos_router 27017 <<'EOF'
sh.enableSharding("somedb")
sh.shardCollection("somedb.helloDoc", { "name": "hashed" })
EOF
