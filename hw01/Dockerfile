FROM golang:1.24.0-bookworm AS hugo-builder

RUN go install github.com/gohugoio/hugo@latest

WORKDIR /src

COPY ./src /src

RUN /go/bin/hugo --minify --gc --cleanDestinationDir

FROM alpine:3.13.2 AS busybox-builder

RUN apk add gcc musl-dev make perl git

WORKDIR /busybox

RUN git clone --depth=1 --branch 1_35_stable git://busybox.net/busybox.git .

COPY busybox-build.config .config

RUN make oldconfig 
RUN make 
RUN make install

FROM nginxinc/nginx-unprivileged:1.23.1-alpine-slim

COPY --from=hugo-builder /src/public /usr/share/nginx/html

COPY --from=busybox-builder /busybox/_install/bin/busybox /usr/local/bin/busybox

EXPOSE 8080

CMD 
