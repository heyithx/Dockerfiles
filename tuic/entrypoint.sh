#!/bin/sh

if [ -z "$TOKEN" ]; then
  TOKEN=`hexdump -n 16 -e '4/4 "%08x" 1 "\n"' /dev/urandom`
fi

cat > tuic-server.json << EOF
{
    "server": "${SERVER}",
    "users": {
        "${UUID}": "${PASSWORD}"
    },
    "certificate": "${CERTIFICATE}",
    "private_key": "${PRIVATE_KEY}",
    "congestion_control": "${CONGESTION_CONTROLLER}",
    "alpn": ["${ALPN}"],
    "udp_relay_ipv6": ${UDP_RELAY_IPV6},
    "zero_rtt_handshake": ${ZERO_RTT_HANDSHAKE},
    "auth_timeout": "${AUTH_TIMEOUT}",
    "max_idle_time": "${MAX_IDLE_TIME}",
    "max_external_packet_size": ${MAX_EXTERNAL_PACKET_SIZE},
    "gc_interval": "${GC_INTERVAL}",
    "gc_lifetime": "${GC_LIFETIME}",
    "log_level": "${LOG_LEVEL}"
}
EOF

cat tuic-server.json

if [ -z "$@" ]; then
  tuic-server -c tuic-server.json
fi

exec "$@"