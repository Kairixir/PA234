#####################
## Hugo build stage #
#####################
FROM golang:1.24.0-bookworm AS hugo-builder

# Build hugo from source
RUN go install github.com/gohugoio/hugo@latest

WORKDIR /src

COPY ./src /src

# Generate static pages with minmal footprint
RUN /go/bin/hugo --minify --gc --cleanDestinationDir


########################################
# Busybox webserver custom build stage #
########################################
FROM alpine:3.13.2 AS busybox-builder

RUN apk add --no-cache gcc=10.2.1_pre1-r3 musl-dev=1.2.2-r2 \
  make=4.3-r0 perl=5.32.0-r0 git=2.30.6-r0

WORKDIR /busybox

# Get source for busybox
RUN git clone --depth=1 --branch 1_35_stable git://busybox.net/busybox.git .

# Copy custom config excluding all non-essential features
COPY busybox-build.config .config

# Build custom busybox binary
RUN make oldconfig && \
  make && \
  make install

RUN adduser -D busybox


##########################
# Webserver runner stage #
##########################
FROM scratch

EXPOSE 8080

# Get user to run non-privileged, site and binary
COPY --from=busybox-builder /etc/passwd /etc/passwd

COPY --from=busybox-builder /busybox/_install/bin/busybox /

COPY --from=hugo-builder /src/public /

CMD ["/busybox", "httpd", "-f", "-v", "-p", "8080"]
