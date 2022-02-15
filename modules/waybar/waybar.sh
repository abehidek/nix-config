''
{
    "layer": "top", // Waybar at top layer
    "position": "top", // Waybar position (top|bottom|left|right)
    "height": 35, // Waybar height
    // "width": 120, // Waybar width
    // Choose the order of the modules
    "modules-left": ["sway/workspaces", "sway/mode"],
    // "modules-left": ["sway/workspaces", "sway/mode", "custom/media"],
    // "modules-center": ["sway/window"],
    "modules-right": ["tray","pulseaudio", "network", "cpu", "memory", "temperature", "backlight", "battery", "battery#bat2", "clock"],
    // Modules configuration
     "sway/workspaces": {
         "disable-scroll": true,
         "disable-markup" : false,
         "all-outputs": true,
         "format": "  {icon}  ",
         //"format":"{icon}",
         "format-icons": {
             "1": "壱",
             "2": "弐",
             "3": "参",
             "4": "肆",
             "5": "伍",
             "6": "陸",
             "7": "漆",
             "8": "捌",
             "9": "玖",
             "focused": "",
             "default": ""
         }
     },
    "sway/mode": {
        "format": "<span style=\"italic\">{}</span>"
    },
    "idle_inhibitor": {
        "format": "{icon}",
        "format-icons": {
            "activated": "",
            "deactivated": ""
        }
    },
    "tray": {
        "icon-size": 21,
        "spacing": 10
    },
    "clock": {
        "tooltip-format": "{:%Y-%m-%d | %H:%M}",
        "format-alt": "{:%Y-%m-%d}"
    },
    "cpu": {
        "format": "{usage}% "
    },
    "memory": {
        "format": "{}% "
    },
    "temperature": {
        // "thermal-zone": 2,
        // "hwmon-path": "/sys/class/hwmon/hwmon2/temp1_input",
        "critical-threshold": 80,
        // "format-critical": "{temperatureC}°C ",
        "format": "{temperatureC}°C "
    },
    "backlight": {
        // "device": "acpi_video1",
        "format": "{percent}% {icon}",
        "states": [0,50],
        "format-icons": ["", ""]
    },
    "battery": {
        "states": {
            "good": 95,
            "warning": 30,
            "critical": 15
        },
        "format": "{capacity}% {icon}",
        // "format-good": "", // An empty format will hide the module
        // "format-full": "",
        "format-icons": ["", "", "", "", ""]
    },
    "battery#bat2": {
        "bat": "BAT2"
    },
    "network": {
        // "interface": "wlp2s0", // (Optional) To force the use of this interface
        "format-wifi": "{essid} ({signalStrength}%) ",
        "format-ethernet": "{ifname}: {ipaddr}/{cidr} ",
        "format-disconnected": "Disconnected ⚠",
        "interval" : 7
    },
    "pulseaudio": {
        //"scroll-step": 1,
        "format": "{volume}% {icon}",
        "format-bluetooth": "{volume}% {icon}",
        "format-muted": "",
        "format-icons": {
            "headphones": "",
            "handsfree": "",
            "headset": "",
            "phone": "",
            "portable": "",
            "car": "",
            "default": ["", ""]
        },
        "on-click": "pavucontrol"
    },
    "custom/media": {
        "format": "{icon} {}",
        "return-type": "json",
        "max-length": 40,
        "format-icons": {
            "spotify": "",
            "default": "🎜"
        },
        "escape": true,
        "exec": "$HOME/.config/waybar/mediaplayer.py 2> /dev/null" // Script in resources folder
    }
}
''