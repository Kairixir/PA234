FROM golang:1.24.0-bookworm AS builder

RUN go install github.com/gohugoio/hugo@latest

WORKDIR /src

COPY ./src /src

RUN /go/bin/hugo --minify --gc --cleanDestinationDir

FROM nginxinc/nginx-unprivileged:1.23.1-alpine-slim

COPY --from=builder /src/public /usr/share/nginx/html

EXPOSE 8080
