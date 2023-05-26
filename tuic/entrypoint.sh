#!/bin/sh

USERS=`echo ${USERS}|tr "," "\n"|tr ":" "\n"|sed 's/^.*$/"&"/'|sed -n '{N;s/\n/:/p}'|tr "\n" ","|head -c -1`
ALPN=`echo ${ALPN}|tr "," "\n"|sed 's/^.*$/"&"/'|tr "\n" ","|head -c -1`

cat > tuic-server.json << EOF
{
    "server": "${SERVER}",
    "users": {${USERS}},
    "certificate": "${CERTIFICATE}",
    "private_key": "${PRIVATE_KEY}",
    "congestion_control": "${CONGESTION_CONTROLLER}",
    "alpn": [${ALPN}],
    "udp_relay_ipv6": ${UDP_RELAY_IPV6},
    "zero_rtt_handshake": ${ZERO_RTT_HANDSHAKE},
    "dual_stack": ${DUAL_STACK},
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