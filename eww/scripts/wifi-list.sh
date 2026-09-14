#!/bin/bash
# Lista över synliga Wi-Fi-nätverk som JSON-array för eww.

LC_ALL=C nmcli -t -f active,ssid,signal,security dev wifi list 2>/dev/null | python3 -c "
import sys, json

by_ssid = {}
for line in sys.stdin:
    line = line.rstrip('\n')
    parts = line.split(':')
    if len(parts) < 4:
        continue
    active, ssid, signal, security = parts[0], parts[1], parts[2], ':'.join(parts[3:])
    if not ssid:
        continue
    entry = {
        'ssid': ssid,
        'signal': int(signal) if signal.isdigit() else 0,
        'secured': security.strip() not in ('', '--'),
        'active': active == 'yes',
    }
    # Samma SSID kan sändas av flera accesspunkter - behåll den aktiva,
    # annars den med starkast signal.
    prev = by_ssid.get(ssid)
    if prev is None or entry['active'] or (not prev['active'] and entry['signal'] > prev['signal']):
        by_ssid[ssid] = entry

nets = sorted(by_ssid.values(), key=lambda n: (not n['active'], -n['signal']))
print(json.dumps(nets[:10]))
"
