FROM caddy:builder-alpine AS builder

LABEL org.opencontainers.image.source https://github.com/xianyu-one/derper

ENV http_proxy=http://10.233.0.1:7890
ENV https_proxy=http://10.233.0.1:7890

RUN xcaddy build \
    --with github.com/caddy-dns/cloudflare && \
    apk update && \
    apk add upx && \
    upx -9 /usr/bin/caddy

FROM caddy:alpine

COPY --from=builder /usr/bin/caddy /usr/bin/caddy