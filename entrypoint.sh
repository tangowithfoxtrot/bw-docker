#!/usr/bin/env bash

STATUS="$(bw status | jq -r '.status')"

if [[ "$STATUS" == "unauthenticated" ]]; then
  bw config server "$SERVER_HOST_URL"
  if [[ "$UNLOCK_VAULT" == "true" ]]; then
    # shellcheck disable=SC2155
    export BW_SESSION="$(
      bw login "$VAULT_EMAIL" "$VAULT_PASSWORD" --raw
    )"
  else
    bw login "$VAULT_EMAIL" "$VAULT_PASSWORD"
  fi
fi

bw serve --hostname all --port "$BW_SERVE_API_PORT" &
sleep infinity
