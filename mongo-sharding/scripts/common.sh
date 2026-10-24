script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "${script_dir}/.."

mongosh_exec() {
  local service="$1"
  local port="$2"
  shift 2
  docker compose exec -T "${service}" mongosh --port "${port}" --quiet "$@"
}
