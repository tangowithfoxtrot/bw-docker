#!/bin/sh

# to enable interactive CLI usage
if [ $# -gt 0 ]; then
  bw "$@"
  exit $?
fi

STATUS="$(bw status --pretty | grep 'status' | sed 's/status": "//g' | grep -oE '(\w+)' || echo "Could not get vault status. Exiting..." && exit 1)"

if [ -n "$MFA_CODE" ]; then
  # shellcheck disable=SC2034
  MFA_LOGIN="--method 0 --code $MFA_CODE"
fi

if [ -n "$BW_CLIENTSECRET" ]; then
  API_LOGIN="--apikey"
fi

if [ "$STATUS" != "authenticated" ]; then
  bw config server "$SERVER_HOST_URL" && echo
  # shellcheck disable=SC2086,SC2155
  BW_TMP_SESSION="$(bw login --raw "$VAULT_EMAIL" "$VAULT_PASSWORD" $API_LOGIN $MFA_LOGIN)" && echo
fi

if [ "$UNLOCK_VAULT" = "true" ]; then
  if [ -n "$BW_TMP_SESSION" ]; then
    export BW_SESSION="$BW_TMP_SESSION"
    # unset the temp session key
    unset BW_TMP_SESSION
  else
    # shellcheck disable=SC2155
    export BW_SESSION="$(bw unlock --raw)"
  fi
  sleep 1

  if [ "$(bw status --pretty | grep 'status' | sed 's/status": "//g' | grep -oE '(\w+)')" = "unauthenticated" ]; then
    echo "Could not authenticate with Bitwarden. Exiting..." && exit 1
  fi

  echo "Vault unlocked!"
else
  # unset the temp session key
  unset BW_TMP_SESSION
fi

bw serve --hostname all --port "${SERVE_PORT:-8087}" &
BW_SERVE_PID=$!
echo "\`bw serve\` pid: $BW_SERVE_PID"

echo "Server can be reached at: http://localhost:${SERVE_PORT:-8087}/status"
sleep infinity
