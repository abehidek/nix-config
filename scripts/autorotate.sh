#!/bin/sh
SCREEN="eDP-1"
# WAYLANDINPUT=(
#     "1003:33798:Atmel_Atmel_maXTouch_Digitizer"
# 	"1386:236:Wacom_ISDv4_EC_Pen"
# 	"2:7:SynPS/2_Synaptics_TouchPad"
# )
WAYLANDINPUT=(
    "1386:21013:Wacom_HID_5215_Finger"
    "1267:12608:MSFT0001:00_04F3:3140_Touchpad"
)

function rotate_ms {
    case $1 in
        "normal")
            rotate 0
            ;;
        "right-up")
            rotate 90
            ;;
        "bottom-up")
            rotate 180
            ;;
        "left-up")
            rotate 270
            ;;
    esac
}

function rotate {

    TARGET_ORIENTATION=$1

    echo "Rotating to" "$TARGET_ORIENTATION"

    swaymsg output "$SCREEN" transform "$TARGET_ORIENTATION"

    for i in "${WAYLANDINPUT[@]}" 
    do
        swaymsg input "$i" map_to_output "$SCREEN"
    done

}

while IFS='$\n' read -r line; do
    rotation="$(echo "$line" | sed -En "s/^.*orientation changed: (.*)/\1/p")"
    [[ !  -z  $rotation  ]] && rotate_ms "$rotation"
done < <(stdbuf -oL monitor-sensor)
