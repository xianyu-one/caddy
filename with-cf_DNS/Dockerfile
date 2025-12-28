FROM --platform=$BUILDPLATFORM caddy:builder-alpine AS builder

ARG TARGETOS
ARG TARGETARCH

LABEL org.opencontainers.image.source https://github.com/xianyu-one/caddy

RUN GOOS=$TARGETOS GOARCH=$TARGETARCH xcaddy build \
    --with github.com/caddy-dns/cloudflare \
    --with github.com/xianyu-one/caddy-traffic-stats@v0.0.3 \
    --output /usr/bin/caddy && \
    apk update && \
    apk add upx wget && \
    upx -9 /usr/bin/caddy

WORKDIR /srv

RUN wget -O /srv/Caddyfile https://raw.githubusercontent.com/caddyserver/dist/master/config/Caddyfile && \
    cp /usr/bin/caddy /srv/caddy

FROM scratch

ENV XDG_CONFIG_HOME /config
ENV XDG_DATA_HOME /data

WORKDIR /srv

COPY --from=builder /srv /srv

EXPOSE 80
EXPOSE 443
EXPOSE 443/udp
EXPOSE 2019

CMD ["/srv/caddy", "run", "--config", "/srv/Caddyfile", "--adapter", "caddyfile"]