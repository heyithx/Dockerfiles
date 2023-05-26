FROM alpine:latest as builder

ENV TZ=Asia/Shanghai
ARG TARGETPLATFORM

RUN set -ex \
        && apk add --no-cache \
            tzdata ca-certificates \
        && cp /usr/share/zoneinfo/$TZ /etc/localtime \
        && echo $TZ > /etc/timezone
        
ARG VERSION=v4.0.1

RUN set -ex \
    && ARCH=""; \
    if [ $TARGETPLATFORM == "linux/amd64" ]; then \
        ARCH="linux-amd64"; \
    elif [ $TARGETPLATFORM == "linux/arm64" ]; then \
        ARCH="linux-aarch64"; \
    fi; \
    wget -O snell-server.zip https://dl.nssurge.com/snell/snell-server-${VERSION}-${ARCH}.zip \
    && unzip snell-server.zip \
    && chmod +x snell-server

FROM frolvlad/alpine-glibc:latest

LABEL maintainer="zenithiks <9955686@gmail.com>"

RUN set -ex \
        && apk add --no-cache \
            libstdc++

WORKDIR /opt/snell

ENV LISTEN 0.0.0.0:8388
ENV PSK=
ENV IPV6 false
ENV OBFS off

COPY --from=builder /etc/localtime /etc/localtime
COPY --from=builder /etc/timezone /etc/timezone
COPY --from=builder /etc/ssl/certs/ca-certificates.crt /etc/ssl/certs/

COPY --from=builder /snell-server /usr/local/bin/
COPY entrypoint.sh /

RUN chmod +x /entrypoint.sh

ENTRYPOINT [ "/entrypoint.sh" ]