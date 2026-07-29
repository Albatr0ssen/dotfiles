PROCESS_COUNT=0
PROCESS_PIDS=$(pgrep spotifyd)
IS_DEBUG=false

CLASS=""
ALT=""
TOOLTIP="pid(s): "

if [[ $1 = "debug" ]]; then
  IS_DEBUG=true
fi

while read -r pid; do
  if $IS_DEBUG; then
    echo "reading pid: '$pid'"
  fi

  TOOLTIP="$TOOLTIP $pid"
  if [[ -n $pid ]]; then
    ((PROCESS_COUNT += 1))
  fi
done <<<"$PROCESS_PIDS"

if $IS_DEBUG; then
  echo "$PROCESS_PIDS $PROCESS_COUNT"
fi

if [[ $PROCESS_COUNT -ge 1 ]]; then
  ALT="running"
fi

if [[ $PROCESS_COUNT -eq 1 ]]; then
  CLASS="running"
elif [[ $PROCESS_COUNT -gt 1 ]]; then
  CLASS="multiple"
fi

if [[ $PROCESS_COUNT -ge 1 ]]; then
  echo "{\"class\": \"$CLASS\", \"alt\": \"$ALT\", \"tooltip\": \"$TOOLTIP\"}"
fi
