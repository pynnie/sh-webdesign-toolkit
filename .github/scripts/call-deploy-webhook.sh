#!/usr/bin/env bash
set -euo pipefail

# Usage: call-deploy-webhook.sh '<json-payload>'
# Requires: WEBHOOK_URL (unless WEBHOOK_SKIP_IF_EMPTY=true)

payload="${1:?JSON payload required}"

if [ -z "${WEBHOOK_URL:-}" ]; then
  if [ "${WEBHOOK_SKIP_IF_EMPTY:-false}" = "true" ]; then
    echo "WEBHOOK_URL not set, skipping webhook."
    exit 0
  fi
  echo "WEBHOOK_URL required"
  exit 1
fi

MAX_ATTEMPTS="${WEBHOOK_MAX_ATTEMPTS:-5}"
INITIAL_WAIT="${WEBHOOK_INITIAL_WAIT_SECONDS:-15}"
CONNECT_TIMEOUT="${WEBHOOK_CONNECT_TIMEOUT:-30}"
MAX_TIME="${WEBHOOK_MAX_TIME:-120}"

wait_seconds="$INITIAL_WAIT"

for attempt in $(seq 1 "$MAX_ATTEMPTS"); do
  echo "Webhook attempt ${attempt}/${MAX_ATTEMPTS}..."

  if curl --fail-with-body -sS -X POST \
    --connect-timeout "$CONNECT_TIMEOUT" \
    --max-time "$MAX_TIME" \
    -H 'Content-Type: application/json' \
    -d "$payload" \
    "$WEBHOOK_URL"; then
    echo "Webhook succeeded on attempt ${attempt}."
    exit 0
  fi

  curl_exit=$?
  echo "Webhook attempt ${attempt} failed (curl exit ${curl_exit})."

  if [ "$attempt" -lt "$MAX_ATTEMPTS" ]; then
    echo "Retrying in ${wait_seconds}s..."
    sleep "$wait_seconds"
    wait_seconds=$((wait_seconds * 2))
    if [ "$wait_seconds" -gt 120 ]; then
      wait_seconds=120
    fi
  fi
done

echo "Webhook failed after ${MAX_ATTEMPTS} attempts."
exit 1
