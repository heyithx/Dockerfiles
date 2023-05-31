FROM alpine:latest as builder

ENV TZ=Asia/Shanghai
ARG TARGETPLATFORM

RUN set -ex \
        && apk add --no-cache \
            tzdata ca-certificates \
        && cp /usr/share/zoneinfo/$TZ /etc/localtime \
        && echo $TZ > /etc/timezone

ARG VERSION=1.0.0-beta0

RUN set -ex \
    && ARCH=""; \
    if [ $TARGETPLATFORM == "linux/amd64" ]; then \
        ARCH="x86_64-unknown-linux-gnu"; \
    elif [ $TARGETPLATFORM == "linux/arm64" ]; then \
        ARCH="aarch64-unknown-linux-gnu"; \
    fi; \
    wget -O tuic-server https://github.com/EAimTY/tuic/releases/download/tuic-server-${VERSION}/tuic-server-${VERSION}-${ARCH} \
    && chmod +x tuic-server

FROM frolvlad/alpine-glibc:latest

LABEL maintainer="zenithiks <9955686@gmail.com>"

RUN set -ex \
        && apk add --no-cache \
            libstdc++

WORKDIR /opt/tuic

ENV SERVER [::]:443
ENV USERS 00000000-0000-0000-0000-000000000000:PASSWORD_0,00000000-0000-0000-0000-000000000001:PASSWORD_1
ENV CERTIFICATE /opt/tuic/fullchain.pem
ENV PRIVATE_KEY /opt/tuic/private.pem
ENV CONGESTION_CONTROLLER cubic
ENV ALPN h3,spdy/3.1
ENV UDP_RELAY_IPV6 true
ENV ZERO_RTT_HANDSHAKE false
ENV DUAL_STACK true
ENV AUTH_TIMEOUT 3s
ENV TASK_NEGOTIATION_TIMEOUT 3s
ENV MAX_IDLE_TIME 10s
ENV MAX_EXTERNAL_PACKET_SIZE 1500
ENV SEND_WINDOW 16777216
ENV RECEIVE_WINDOW 8388608
ENV GC_INTERVAL 3s
ENV GC_LIFETIME 15s
ENV LOG_LEVEL warn

COPY --from=builder /etc/localtime /etc/localtime
COPY --from=builder /etc/timezone /etc/timezone
COPY --from=builder /etc/ssl/certs/ca-certificates.crt /etc/ssl/certs/

COPY --from=builder /tuic-server /usr/local/bin/
COPY entrypoint.sh /

RUN chmod +x /entrypoint.sh

ENTRYPOINT [ "/entrypoint.sh" ]