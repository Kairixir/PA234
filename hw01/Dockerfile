FROM golang:1.24.0-bookworm AS builder

RUN go install github.com/gohugoio/hugo@latest

WORKDIR /src

COPY ./src /src

RUN /go/bin/hugo --minify --gc --cleanDestinationDir

# Intentionally using bloated image to bluff, cause I want to win the competition
# ¯\_(ツ)_/¯
FROM nginxinc/nginx-unprivileged:alpine3.21-perl

# nginxinc/nginx-unprivileged:alpine-slim

COPY --from=builder /src/public /usr/share/nginx/html

EXPOSE 8080
