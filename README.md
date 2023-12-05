# caddy

包含cloudflare插件的caddy2构建

## 使用方法

与官方容器使用方法一致

下面是一个`docker-compose`示例

```yaml
version: '3'
services:
  app:
    image: 'mrxianyu/caddy:latest'
    build:
      context: ./
      dockerfile: Dockerfile
    restart: unless-stopped
    container_name: caddy
    ports:
      - '80:80'
      - '443:443'
    volumes:
      - ./Caddyfile:/etc/caddy/Caddyfile:ro
      - ./data:/data
      - ./pages:/usr/share/caddy/pages:ro
    networks:
      app_net:
        ipv4_address: 10.233.1.2

networks:
  app_net:
    driver: bridge
    ipam:
      driver: default
      config:
        - subnet: 10.233.1.0/24
          gateway: 10.233.1.1
```