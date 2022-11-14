#!/bin/sh

if [ -z "$PASSWORD" ]; then
  PASSWORD=`hexdump -n 16 -e '4/4 "%08x" 1 "\n"' /dev/urandom`
fi

cat > ss-server.json << EOF
{
    "server": "${SERVER}",
    "server_port": ${SERVER_PORT},
    "password": "${PASSWORD}",
    "timeout": ${TIMEOUT},
    "method":"${METHOD}",
    "fast_open": ${FAST_OPEN}
}
EOF

cat ss-server.json

if [ -z "$@" ]; then
  ssserver -c ss-server.json
fi

exec "$@"