#!/usr/bin/env bash
set -euo pipefail

source "$(dirname "$0")/common.sh"

count_documents() {
  local service="$1"
  local port="$2"
  mongosh_exec "${service}" "${port}" <<'EOF'
use somedb
db.helloDoc.countDocuments()
EOF
}

count_shard_documents() {
  local service="$1"
  local port="$2"
  mongosh_exec "${service}" "${port}" <<'EOF'
db.getMongo().setReadPref("secondaryPreferred")
use somedb
db.helloDoc.countDocuments()
EOF
}

count_replicas() {
  local service="$1"
  local port="$2"
  mongosh_exec "${service}" "${port}" --eval 'rs.status().members.length'
}

echo "mongos_router"
count_documents mongos_router 27017

echo "shard1"
count_shard_documents shard1-1 27018

echo "shard1 replicas"
count_replicas shard1-1 27018

echo "shard2"
count_shard_documents shard2-1 27018

echo "shard2 replicas"
count_replicas shard2-1 27018
