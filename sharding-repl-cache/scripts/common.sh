script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "${script_dir}/.."

mongosh_exec() {
  local service="$1"
  local port="$2"
  shift 2
  docker compose exec -T "${service}" mongosh --port "${port}" --quiet "$@"
}

wait_for_primary() {
  local service="$1"
  local port="$2"
  until mongosh_exec "${service}" "${port}" --eval 'rs.status().members.some((member) => member.stateStr === "PRIMARY")' | grep -qx 'true'; do
    sleep 2
  done
}

wait_for_mongos() {
  until mongosh_exec mongos_router 27017 --eval "db.adminCommand('ping')"; do
    sleep 2
  done
}
