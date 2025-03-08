#!/bin/bash

battery_level=$(cat /sys/class/power_supply/BAT0/capacity)
status=$(cat /sys/class/power_supply/BAT0/status)

if [[ "$battery_level" -le 10 && "$status" == "Discharging" ]]; then
    dunstify -u critical "Battery Low" " Battery is at ${battery_level}%! Plug in your charger."
fi

if [[ "$battery_level" -le 5 && "$status" == "Discharging" ]]; then
    dunstify -u critical "Battery Critical" " Battery is at ${battery_level}%! System may shut down soon!"
fi

if [[ "$battery_level" -ge 100 && "$status" == "Full" ]]; then
    dunstify -u normal "Battery Full" " Battery is fully charged. Consider unplugging."
fi
