#!/bin/bash
# Ansluter med lösenordet användaren skrivit i eww-dialogen.

SSID="$1"
PASSWORD="$2"

if [ -z "$PASSWORD" ]; then
    exit 0
fi

eww update wifi_connect_status="connecting"

if nmcli device wifi connect "$SSID" password "$PASSWORD" 2>/tmp/wifi-connect-err.log; then
    eww update wifi_connect_pw="" wifi_connect_status="success"
    sleep 1.5
    eww update wifi_connect_status="connecting"
    eww close wifi-connect 2>/dev/null
else
    msg=$(tail -1 /tmp/wifi-connect-err.log)
    eww update wifi_connect_pw="" wifi_connect_error_msg="$msg" wifi_connect_status="error"
fi
