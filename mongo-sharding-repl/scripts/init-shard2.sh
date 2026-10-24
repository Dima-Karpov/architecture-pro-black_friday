#!/usr/bin/env bash
set -euo pipefail

source "$(dirname "$0")/common.sh"

mongosh_exec shard2-1 27018 <<'EOF'
rs.initiate(
  {
    _id: "shard2",
    members: [
      { _id: 0, host: "shard2-1:27018" },
      { _id: 1, host: "shard2-2:27018" },
      { _id: 2, host: "shard2-3:27018" }
    ]
  }
)
EOF

wait_for_primary shard2-1 27018

mongosh_exec mongos_router 27017 <<'EOF'
sh.addShard("shard2/shard2-1:27018,shard2-2:27018,shard2-3:27018")
EOF
