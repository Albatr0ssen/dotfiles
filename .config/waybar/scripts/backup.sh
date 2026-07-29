TIME_CLASS="null" # TIME CLASSES: FRESH, DUSTY, ANCIENT
FRESH_TIME=21600  # 6 hours
DUSTY_TIME=259200 # 3 days

LAST_BACKUP_TIME=$(cat /var/lib/hyprmane-backup/last_backup)
TIME_NOW=$(date +%s)
TIME_SINCE=$((TIME_NOW - LAST_BACKUP_TIME))

if [[ "$TIME_SINCE" -le "$FRESH_TIME" ]]; then
  TIME_CLASS="fresh"
elif [[ "$TIME_SINCE" -le "$DUSTY_TIME" ]]; then
  TIME_CLASS="dusty"
else
  TIME_CLASS="ancient"
fi

LAST_BACKUP_TIME_FORMATTED=$(date -d @"$LAST_BACKUP_TIME" '+%Y-%m-%d %H:%M:%S')

echo "{\"class\": \"$TIME_CLASS\", \"tooltip\": \"Last backup: $LAST_BACKUP_TIME_FORMATTED\"}"
