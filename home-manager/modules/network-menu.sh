#!/usr/bin/env bash
# Wi-Fi picker for waybar's custom/network module, shown via wofi
set -euo pipefail

REFRESH_SIGNAL=9

menu() {
    local prompt=$1
    shift
    wofi --dmenu --prompt "$prompt" "$@"
}

refresh() {
    pkill "-RTMIN+${REFRESH_SIGNAL}" waybar 2>/dev/null || true
}

# OWE networks report a security type but connect like open ones (no PSK).
needs_password() {
    [[ $1 =~ WPA|WEP ]]
}

wifi_enabled=$(nmcli radio wifi)
wifi_dev=$(nmcli -t -f DEVICE,TYPE device status | awk -F: '$2 == "wifi" {print $1; exit}')

entries=()
declare -A ssid_for_entry=()

if [ "$wifi_enabled" = "enabled" ]; then
    entries+=("󰖪 Turn Wi-Fi off")

    [ -n "$wifi_dev" ] && nmcli device wifi rescan ifname "$wifi_dev" >/dev/null 2>&1 || true

    active_ssid=""

    while IFS=: read -r inuse ssid signal security; do
        [ -z "$ssid" ] && continue
        [ "$inuse" = "*" ] && active_ssid=$ssid

        icon="󰤟"
        [ "$signal" -ge 30 ] && icon="󰤢"
        [ "$signal" -ge 55 ] && icon="󰤥"
        [ "$signal" -ge 80 ] && icon="󰤨"

        lock=""
        needs_password "$security" && lock=" 󰌾"

        mark=""
        [ "$inuse" = "*" ] && mark=" ✓"

        label="$icon $ssid ($signal%)$lock$mark"
        [ -n "${ssid_for_entry[$label]:-}" ] && continue
        entries+=("$label")
        ssid_for_entry["$label"]=$ssid
    done < <(nmcli -t -f IN-USE,SSID,SIGNAL,SECURITY device wifi list | sort -t: -k3,3 -rn | awk -F: '!seen[$2]++')

    [ -n "$active_ssid" ] && entries+=("󰈂 Disconnect from $active_ssid")
else
    entries+=("󰖩 Turn Wi-Fi on")
fi

choice=$(printf '%s\n' "${entries[@]}" | menu "Network")
[ -z "$choice" ] && exit 0

case "$choice" in
    "󰖩 Turn Wi-Fi on")
        nmcli radio wifi on
        refresh
        exit 0
        ;;
    "󰖪 Turn Wi-Fi off")
        nmcli radio wifi off
        refresh
        exit 0
        ;;
    "󰈂 Disconnect from "*)
        [ -n "$wifi_dev" ] && nmcli device disconnect "$wifi_dev" >/dev/null 2>&1
        refresh
        exit 0
        ;;
esac

ssid="${ssid_for_entry[$choice]:-}"
[ -z "$ssid" ] && exit 0

if nmcli -t -f NAME connection show | grep -qxF "$ssid"; then
    nmcli connection up id "$ssid" >/dev/null 2>&1
else
    security=$(nmcli -t -f SSID,SECURITY device wifi list | awk -F: -v s="$ssid" '$1 == s {print $2; exit}')
    if needs_password "$security"; then
        password=$(menu "Password for $ssid" --password)
        [ -z "$password" ] && exit 0
        nmcli device wifi connect "$ssid" password "$password" >/dev/null 2>&1
    else
        nmcli device wifi connect "$ssid" >/dev/null 2>&1
    fi
fi

refresh
