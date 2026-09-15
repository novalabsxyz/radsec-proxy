FROM debian:trixie-slim AS builder

ARG RADSECPROXY_COMMIT=1.11.1
ARG DEBIAN_FRONTEND=noninteractive

WORKDIR /build
RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential \
    libssl-dev \
    git \
    ca-certificates \
    autoconf \
    automake \
    libtool \
    pkg-config \
    nettle-dev \
    && rm -rf /var/lib/apt/lists/*

RUN git clone --depth 1 https://github.com/radsecproxy/radsecproxy.git --branch ${RADSECPROXY_COMMIT} && \
    cd radsecproxy && \
    ./autogen.sh && \
    ./configure --prefix=/usr --sysconfdir=/etc && \
    make -j$(nproc) && \
    make install DESTDIR=/install && \
    strip /install/usr/sbin/radsecproxy

FROM debian:trixie-slim

RUN apt-get update && apt-get install -y --no-install-recommends \
    libssl3t64 \
    nettle-dev \
    netcat-openbsd \
    && rm -rf /var/lib/apt/lists/* && \
    groupadd -r radsec && useradd -r -g radsec -s /sbin/nologin radsec && \
    mkdir -p /etc/radsecproxy /var/log/radsecproxy && \
    chown -R radsec:radsec /etc/radsecproxy /var/log/radsecproxy

COPY --from=builder /install/usr/sbin/radsecproxy /usr/bin/
COPY --chown=radsec:radsec radsecproxy.conf /etc/radsecproxy/
COPY --chown=radsec:radsec cert.pem ca.pem key.pem /certs/

WORKDIR /etc/radsecproxy
EXPOSE 1812/udp 1813/udp
# NOTE(oberezovskyi): trixie nc resolves localhost to ::1 first (radsecproxy listens on ipv4 only) and waits 3s before reporting a udp port open, which collides with the 3s timeout, so probe 127.0.0.1 with -w 1
HEALTHCHECK --interval=30s --timeout=3s CMD nc -w 1 -uz 127.0.0.1 1812 || exit 1

USER radsec
ENTRYPOINT ["/usr/bin/radsecproxy", "-f", "-c", "/etc/radsecproxy/radsecproxy.conf"]
