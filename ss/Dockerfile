FROM alpine:latest as builder

ENV TZ=Asia/Shanghai
ARG TARGETPLATFORM

RUN set -ex \
        && apk add --no-cache \
            tzdata ca-certificates \
        && cp /usr/share/zoneinfo/$TZ /etc/localtime \
        && echo $TZ > /etc/timezone

ARG VERSION

RUN set -ex \
    && ARCH=""; \
    if [ $TARGETPLATFORM == "linux/amd64" ]; then \
        ARCH="x86_64-unknown-linux-gnu"; \
    elif [ $TARGETPLATFORM == "linux/arm64" ]; then \
        ARCH="aarch64-unknown-linux-gnu"; \
    fi; \
    wget -O ss.tar.xz https://github.com/shadowsocks/shadowsocks-rust/releases/download/${VERSION}/shadowsocks-${VERSION}.${ARCH}.tar.xz \
    && tar -xvf ss.tar.xz \
    && chmod +x ssserver
    
FROM woahbase/alpine-glibc

LABEL maintainer="heyithx <9955686@gmail.com>"

RUN set -ex \
        && apk add --no-cache \
            libstdc++

WORKDIR /opt/ss

ENV SERVER 0.0.0.0
ENV SERVER_PORT 8388
ENV PASSWORD=
ENV TIMEOUT 300
ENV METHOD aes-256-gcm
ENV FAST_OPEN false

COPY --from=builder /etc/localtime /etc/localtime
COPY --from=builder /etc/timezone /etc/timezone
COPY --from=builder /etc/ssl/certs/ca-certificates.crt /etc/ssl/certs/

COPY --from=builder /ssserver /usr/local/bin/
COPY entrypoint.sh /

RUN chmod +x /entrypoint.sh

ENTRYPOINT [ "/entrypoint.sh" ]