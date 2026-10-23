#!/usr/bin/env bash
set -euo pipefail

source "$(dirname "$0")/common.sh"

echo "mongos_router"
mongosh_exec mongos_router 27017 <<'EOF'
use somedb
db.helloDoc.countDocuments()
EOF

echo "shard1"
mongosh_exec shard1 27018 <<'EOF'
use somedb
db.helloDoc.countDocuments()
EOF

echo "shard2"
mongosh_exec shard2 27018 <<'EOF'
use somedb
db.helloDoc.countDocuments()
EOF
