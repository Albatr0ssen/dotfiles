capacity=$(cat /sys/class/power_supply/BAT1/capacity)

charge_full=$(cat /sys/class/power_supply/BAT1/charge_full)
charge_now=$(cat /sys/class/power_supply/BAT1/charge_now)
current_now=$(cat /sys/class/power_supply/BAT1/current_now)

total_time_left=$(((charge_full - charge_now) * 60 / current_now))
minutes_left=$((total_time_left % 60))
hours_left=$(((total_time_left - minutes_left) / 60))

time_till_fully_charged=$(printf "| %sh %sm" "$hours_left" "$minutes_left")
battery_info="$capacity%"

status=$(cat /sys/class/power_supply/BAT1/status)
if [ "$status" = "Charging" ]; then
  battery_info="$battery_info $time_till_fully_charged"
fi

echo "$battery_info"
