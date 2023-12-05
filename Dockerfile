FROM caddy:builder-alpine AS builder

LABEL org.opencontainers.image.source https://github.com/xianyu-one/caddy

RUN xcaddy build \
    --with github.com/caddy-dns/cloudflare && \
    apk update && \
    apk add upx && \
    upx -9 /usr/bin/caddy

FROM caddy:alpine

COPY --from=builder /usr/bin/caddy /usr/bin/caddy