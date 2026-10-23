#!/usr/bin/env bash
set -euo pipefail

source "$(dirname "$0")/common.sh"

mongosh_exec mongos_router 27017 <<'EOF'
use somedb
for (var i = 0; i < 1000; i++) db.helloDoc.insert({ age: i, name: "ly" + i })
db.helloDoc.countDocuments()
EOF
