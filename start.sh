#!/bin/bash

# Start Unbound
unbound -d &

# Start DNSCrypt proxy
dnscrypt-proxy -config /etc/dnscrypt-proxy/dnscrypt-proxy.toml &

# Start AdGuard Home
/opt/AdGuardHome/AdGuardHome -c /opt/AdGuardHome/conf/AdGuardHome.yaml -w /opt/AdGuardHome/work &

# Start WireGuard
wg-quick up wg0

# Keep container running
tail -f /dev/null
