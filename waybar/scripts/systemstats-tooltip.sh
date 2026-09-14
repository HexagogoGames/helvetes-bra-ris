#!/bin/bash
# Waybar-wrapper runt eww/scripts/system-stats.sh (samma datakälla som
# eww-systemmenyn) - formaterar om till waybars {"text","tooltip"}-format.
data=$(~/.config/eww/scripts/system-stats.sh)
python3 -c "
import json
d = json.loads('''$data''')
print(json.dumps({
    'text': '',
    'tooltip': f\"Minne {d['mem']}%\nTemp {d['temp']}°C\n{d['net']}\n\nKlicka för systemmeny\"
}))
"
