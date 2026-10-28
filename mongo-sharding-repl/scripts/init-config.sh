#!/usr/bin/env bash
set -euo pipefail

source "$(dirname "$0")/common.sh"

mongosh_exec configSrv 27019 <<'EOF'
rs.initiate(
  {
    _id: "config_server",
    configsvr: true,
    members: [
      { _id: 0, host: "configSrv:27019" }
    ]
  }
)
EOF

wait_for_mongos
