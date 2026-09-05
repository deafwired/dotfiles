#!/usr/bin/env bash
# Emits waybar custom/network JSON describing the current connection.
set -euo pipefail

wifi_enabled=$(nmcli radio wifi)

eth_dev=$(nmcli -t -f DEVICE,TYPE,STATE device status | awk -F: '$2 == "ethernet" && $3 == "connected" {print $1; exit}')
if [ -n "${eth_dev:-}" ]; then
    ip=$(nmcli -g IP4.ADDRESS device show "$eth_dev" | head -n1)
    printf '{"text": " %s", "tooltip": "Ethernet: %s\\n%s", "class": "ethernet"}\n' "$eth_dev" "$eth_dev" "$ip"
    exit 0
fi

if [ "$wifi_enabled" != "enabled" ]; then
    printf '{"text": "󰀝 Off", "tooltip": "Wi-Fi disabled", "class": "disabled"}\n'
    exit 0
fi

wifi_line=$(nmcli -t -f ACTIVE,SSID,SIGNAL device wifi list | awk -F: '$1 == "yes" {print; exit}')
if [ -n "${wifi_line:-}" ]; then
    ssid=$(cut -d: -f2 <<<"$wifi_line")
    signal=$(cut -d: -f3 <<<"$wifi_line")
    printf '{"text": " %s (%s%%)", "tooltip": "Connected to %s", "class": "wifi"}\n' "$ssid" "$signal" "$ssid"
    exit 0
fi

printf '{"text": "󰤭 Disconnected", "tooltip": "Not connected to a network", "class": "disconnected"}\n'
