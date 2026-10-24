#!/usr/bin/env bash
set -euo pipefail

base_url="http://localhost:8080"
threshold_ms=100
failed=0

status_json="$(curl -sf "${base_url}/")"

parsed="$(
  python3 -c '
import json
import sys

data = json.load(sys.stdin)
count = data["collections"]["helloDoc"]["documents_count"]
print(str(data["cache_enabled"]).lower(), count)
' <<<"${status_json}"
)"
read -r cache_enabled hello_count <<<"${parsed}"

echo "cache_enabled: ${cache_enabled}"
echo "helloDoc: ${hello_count}"

for n in 1 2 3; do
  seconds="$(curl -sf -o /dev/null -w '%{time_total}' "${base_url}/helloDoc/users")"
  ms="$(awk -v t="${seconds}" 'BEGIN { printf "%d", (t * 1000) + 0.5 }')"

  if [[ "${n}" -eq 1 ]]; then
    printf '%d %5d ms\n' "${n}" "${ms}"
  elif [[ "${ms}" -lt "${threshold_ms}" ]]; then
    printf '%d %5d ms  < %d ms\n' "${n}" "${ms}" "${threshold_ms}"
  else
    printf '%d %5d ms  >= %d ms\n' "${n}" "${ms}" "${threshold_ms}"
    failed=1
  fi
done

exit "${failed}"
