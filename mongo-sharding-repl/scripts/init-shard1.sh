#!/usr/bin/env bash
set -euo pipefail

source "$(dirname "$0")/common.sh"

mongosh_exec shard1-1 27018 <<'EOF'
rs.initiate(
  {
    _id: "shard1",
    members: [
      { _id: 0, host: "shard1-1:27018" },
      { _id: 1, host: "shard1-2:27018" },
      { _id: 2, host: "shard1-3:27018" }
    ]
  }
)
EOF

wait_for_primary shard1-1 27018

mongosh_exec mongos_router 27017 <<'EOF'
sh.addShard("shard1/shard1-1:27018,shard1-2:27018,shard1-3:27018")
EOF
