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

mongosh_exec shard1 27018 <<'EOF'
rs.initiate(
  {
    _id: "shard1",
    members: [
      { _id: 0, host: "shard1:27018" }
    ]
  }
)
EOF

mongosh_exec shard2 27018 <<'EOF'
rs.initiate(
  {
    _id: "shard2",
    members: [
      { _id: 1, host: "shard2:27018" }
    ]
  }
)
EOF

until mongosh_exec mongos_router 27017 --eval "db.adminCommand('ping')"; do
  sleep 2
done

mongosh_exec mongos_router 27017 <<'EOF'
sh.addShard("shard1/shard1:27018")
sh.addShard("shard2/shard2:27018")
sh.enableSharding("somedb")
sh.shardCollection("somedb.helloDoc", { "name": "hashed" })
EOF
