#!/bin/bash
# Wi-Fi radio-status + ansluten SSID som JSON för eww.

export LC_ALL=C
enabled=$(nmcli radio wifi 2>/dev/null)
ssid=$(nmcli -t -f active,ssid dev wifi 2>/dev/null | awk -F: '$1=="yes"{print $2; exit}')

eww update selected_wifi_enabled="$([ "$enabled" = "enabled" ] && echo true || echo false)" 2>/dev/null

python3 - "$enabled" "$ssid" <<'PYEOF'
import sys, json
enabled = sys.argv[1] if len(sys.argv) > 1 else ""
ssid = sys.argv[2] if len(sys.argv) > 2 else ""
print(json.dumps({"enabled": enabled == "enabled", "ssid": ssid}))
PYEOF
