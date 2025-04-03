# git repo for dockerfile
# https://github.com/Kairixir/PA234/tree/main/hw01
# git repo for webserver
# https://github.com/Kairixir/asmttpd-slim

#####################
## Hugo build stage #
#####################
FROM golang:1.24.0-bookworm AS hugo-builder

# Build hugo from source
RUN go install github.com/gohugoio/hugo@latest

WORKDIR /PA234

RUN git clone -n --depth=1 --filter=tree:0 \
  https://github.com/Kairixir/PA234.git . && \
  git sparse-checkout set --no-cone /hw01/src && \
  git checkout

WORKDIR /PA234/hw01/src

# Generate static pages with minmal footprint
RUN /go/bin/hugo --minify --gc --cleanDestinationDir


########################################
# Asmttpd webserver custom build stage #
########################################
FROM ubuntu:18.04 AS asmttpd-builder

RUN apt update
RUN apt install -y make yasm as31 nasm binutils git

WORKDIR /asmttpd

RUN git clone https://github.com/Kairixir/asmttpd-slim.git .

RUN make release

##########################
# Webserver runner stage #
##########################
FROM scratch

EXPOSE 8080

COPY --from=asmttpd-builder ./asmttpd/asmttpd /

COPY --from=hugo-builder /PA234/hw01/src/public /public

CMD ["/asmttpd", "/public", "8080"]
