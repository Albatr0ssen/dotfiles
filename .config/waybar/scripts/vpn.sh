CONNECTED=false
TEXT=""

WG_INTERFACE=$(wg show interfaces)

if [ -n "$WG_INTERFACE" ]; then
  TEXT=$WG_INTERFACE
  CONNECTED=true
fi

if [ "$WG_INTERFACE" = "wg0-mullvad" ]; then
  MULLVAD_STATUS=$(mullvad status --json)
  MULLVAD_STATE=$(echo "$MULLVAD_STATUS" | jq -r '.state')
  MULLVAD_HOSTNAME=$(echo "$MULLVAD_STATUS" | jq -r '.details.location.hostname')

  if [ "$MULLVAD_STATE" = "connected" ]; then
    TEXT="$MULLVAD_HOSTNAME"
  fi
fi

if [ $CONNECTED = true ]; then
  CONNECTED_VALUE="connected"
  TEXT=" $TEXT"
else
  CONNECTED_VALUE="disconnected"
fi

if [ "$1" = "test" ]; then
  echo "$MULLVAD_STATE" "$MULLVAD_HOSTNAME"
fi

echo "{\"class\": \"$CONNECTED_VALUE\", \"alt\": \"$CONNECTED_VALUE\", \"text\": \"$TEXT\"}"
