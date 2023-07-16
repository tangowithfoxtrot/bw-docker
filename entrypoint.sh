#!/usr/bin/env bash

# to enable interactive CLI usage
if [[ $# -gt 0 ]]; then
  bw "$@"
  exit $?
fi

STATUS="$(bw status | jq -r '.status')"

if [[ -n "$MFA_CODE" ]]; then
  # shellcheck disable=SC2034
  export MFA_LOGIN="--method 0 --code $MFA_CODE"
fi

if [[ -n "$BW_CLIENTSECRET" ]]; then
  export API_LOGIN="--apikey"
fi

if [[ "$STATUS" == "unauthenticated" ]]; then
  bw config server "$SERVER_HOST_URL" && echo
  # shellcheck disable=SC2086
  bw login "$VAULT_EMAIL" "$VAULT_PASSWORD" $API_LOGIN $MFA_LOGIN && echo
fi

bw serve --hostname all --port "${SERVE_PORT:-8087}" &
BW_SERVE_PID=$!
echo "\`bw serve\` pid: $BW_SERVE_PID"

if [[ "$UNLOCK_VAULT" == "true" ]]; then
  while ! curl -sX POST -H "Content-Type: application/json" -d "{\"password\": \"$VAULT_PASSWORD\"}" "http://localhost:$SERVE_PORT/unlock" >/dev/null; do
    sleep 1
  done
  echo "Vault unlocked!"
fi

echo "Server can be reached at: http://localhost:${SERVE_PORT:-8087}/status"
sleep infinity
