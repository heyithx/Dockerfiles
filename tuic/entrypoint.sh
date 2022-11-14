#!/bin/sh

if [ -z "$TOKEN" ]; then
  TOKEN=`hexdump -n 16 -e '4/4 "%08x" 1 "\n"' /dev/urandom`
fi

cat > tuic-server.json << EOF
{
    "port": ${SERVER_PORT},
    "token": ["${TOKEN}"],
    "certificate": "${CERTIFICATE}",
    "private_key": "${PRIVATE_KEY}",
    "ip": "${IP}",
    "congestion_controller": "${CONGESTION_CONTROLLER}",
    "max_idle_time": ${MAX_IDLE_TIME},
    "authentication_timeout": ${AUTHENTICATION_TIMEOUT},
    "alpn": ["${ALPN_PROTOCOL}"],
    "max_udp_relay_packet_size": ${MAX_UDP_RELAY_PACKET_SIZE},
    "log_level": "${LOG_LEVEL}"
}
EOF

cat tuic-server.json

if [ -z "$@" ]; then
  tuic-server -c tuic-server.json
fi

exec "$@"