FROM alpine:latest as builder

ENV TZ=Asia/Shanghai
ARG TARGETPLATFORM

RUN set -ex \
        && apk add --no-cache \
            tzdata ca-certificates \
        && cp /usr/share/zoneinfo/$TZ /etc/localtime \
        && echo $TZ > /etc/timezone

ARG VERSION=0.8.5

RUN set -ex \
    && ARCH=""; \
    if [ $TARGETPLATFORM == "linux/amd64" ]; then \
        ARCH="x86_64-linux-gnu"; \
    elif [ $TARGETPLATFORM == "linux/arm64" ]; then \
        ARCH="aarch64-linux-gnu"; \
    fi; \
    wget -O tuic-server https://github.com/EAimTY/tuic/releases/download/${VERSION}/tuic-server-${VERSION}-${ARCH} \
    && chmod +x tuic-server

FROM frolvlad/alpine-glibc:latest

LABEL maintainer="iks943 <9955686@gmail.com>"

RUN set -ex \
        && apk add --no-cache \
            libstdc++

WORKDIR /opt/tuic

ENV SERVER_PORT 443
ENV TOKEN=
ENV CERTIFICATE /opt/tuic/fullchain.pem
ENV PRIVATE_KEY /opt/tuic/private.pem
ENV IP 0.0.0.0
ENV CONGESTION_CONTROLLER cubic
ENV MAX_IDLE_TIME 15000
ENV AUTHENTICATION_TIMEOUT 1000
ENV ALPN_PROTOCOL h3
ENV MAX_UDP_RELAY_PACKET_SIZE 1500
ENV LOG_LEVEL info

COPY --from=builder /etc/localtime /etc/localtime
COPY --from=builder /etc/timezone /etc/timezone
COPY --from=builder /etc/ssl/certs/ca-certificates.crt /etc/ssl/certs/

COPY --from=builder /tuic-server /usr/local/bin/
COPY entrypoint.sh /

RUN chmod +x /entrypoint.sh

ENTRYPOINT [ "/entrypoint.sh" ]