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

RUN adduser -D busybox

FROM scratch

EXPOSE 8080

COPY --from=busybox-builder /etc/passwd /etc/passwd

COPY --from=busybox-builder /busybox/_install/bin/busybox /

COPY --from=hugo-builder /src/public /

CMD ["/busybox", "httpd", "-f", "-v", "-p", "8080"]
