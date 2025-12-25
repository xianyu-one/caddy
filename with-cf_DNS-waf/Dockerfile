FROM --platform=$BUILDPLATFORM caddy:builder-alpine AS builder

ARG TARGETOS
ARG TARGETARCH

LABEL org.opencontainers.image.source https://github.com/xianyu-one/caddy

ENV GOPROXY=direct

RUN GOOS=$TARGETOS GOARCH=$TARGETARCH xcaddy build \
    --with github.com/caddy-dns/cloudflare \
    --with github.com/xianyu-one/caddy-traffic-stats@v0.0.2 \
    --with github.com/corazawaf/coraza-caddy/v2 \
    --output /usr/bin/caddy && \
    apk update && \
    apk add upx wget git && \
    upx -9 /usr/bin/caddy && \
    cd / && \
    git clone https://github.com/coreruleset/coreruleset.git

WORKDIR /srv

RUN wget -O /srv/Caddyfile https://raw.githubusercontent.com/caddyserver/dist/master/config/Caddyfile && \
    cp /usr/bin/caddy /srv/caddy && \
    mkdir /srv/coraza && \
    cp /coreruleset/crs-setup.conf.example /srv/coraza/conf-recommended && \
    cp -r /coreruleset/rules /srv/coraza/

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