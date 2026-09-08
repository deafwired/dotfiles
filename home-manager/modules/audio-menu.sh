#!/usr/bin/env bash
# Input/output device picker for waybar's pulseaudio module, shown via wofi
set -euo pipefail

menu() {
    local prompt=$1
    shift
    wofi --dmenu --prompt "$prompt" "$@"
}

# Prints "<active> <id> <name>" for one section ("Sinks" or "Sources") of `wpctl status`
parse_section() {
    local want=$1
    wpctl status | awk -v want="$want" '
        /^Audio/   { top = "Audio"; next }
        /^Video/   { top = "Video"; next }
        /^Settings/ { top = ""; next }
        /Sinks:/   { cur = "Sinks"; next }
        /Sources:/ { cur = "Sources"; next }
        /Filters:/ { cur = ""; next }
        /Streams:/ { cur = ""; next }
        top != "Audio" || cur != want { next }
        match($0, /([0-9]+)\. +(.*)/, m) {
            active = ($0 ~ /\*/) ? 1 : 0
            name = m[2]
            sub(/ *\[vol: [0-9.]+\] *$/, "", name)
            print active, m[1], name
        }
    '
}

entries=()
declare -A id_for_entry=()

add_devices() {
    local section=$1 icon=$2
    local active id name entry
    while read -r active id name; do
        [ -z "${id:-}" ] && continue
        mark=""
        [ "$active" = "1" ] && mark=" ✓"
        entry="$icon $name$mark"
        entries+=("$entry")
        id_for_entry["$entry"]=$id
    done < <(parse_section "$section")
}

add_devices "Sinks" "󰕾"
add_devices "Sources" "󰍬"

choice=$(printf '%s\n' "${entries[@]}" | menu "Audio device")
[ -z "$choice" ] && exit 0

id="${id_for_entry[$choice]:-}"
[ -z "$id" ] && exit 0

wpctl set-default "$id"
