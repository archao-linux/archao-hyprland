#!/bin/bash

# Get battery information
battery_level=$(cat /sys/class/power_supply/BAT0/capacity)
status=$(cat /sys/class/power_supply/BAT0/status)

# Create cache directory if it doesn't exist
cache_dir="$HOME/.cache/battery_alerts"
mkdir -p "$cache_dir"

# Alert files to track if notifications have been sent
low_alert_file="$cache_dir/low_alert"
critical_alert_file="$cache_dir/critical_alert"
full_alert_file="$cache_dir/full_alert"

# Low battery alert
if [[ "$battery_level" -le 10 && "$status" == "Discharging" ]]; then
    # Only send notification if we haven't sent one since battery went below threshold
    if [[ ! -f "$low_alert_file" ]]; then
        dunstify -u critical "Battery Low" "  Battery is at ${battery_level}%! Plug in your charger."
        touch "$low_alert_file"
    fi
else
    # Remove the alert file when battery is above threshold or charging
    rm -f "$low_alert_file"
fi

# Critical battery alert
if [[ "$battery_level" -le 5 && "$status" == "Discharging" ]]; then
    if [[ ! -f "$critical_alert_file" ]]; then
        dunstify -u critical "Battery Critical" " Battery is at ${battery_level}%! System may shut down soon!"
        touch "$critical_alert_file"
    fi
else
    rm -f "$critical_alert_file"
fi

# Battery full alert
if [[ "$battery_level" -ge 100 && "$status" == "Full" ]]; then
    if [[ ! -f "$full_alert_file" ]]; then
        dunstify -u normal "Battery Full" " Battery is fully charged. Consider unplugging."
        touch "$full_alert_file"
    fi
else
    rm -f "$full_alert_file"
fi
