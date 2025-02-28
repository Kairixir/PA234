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
# Asmttpd webserver custom build stage #
########################################
FROM ubuntu:18.04 AS asmttpd-builder

RUN apt update
RUN apt install -y make yasm as31 nasm binutils 

WORKDIR /asmttpd

COPY ./asmttpd/ .

RUN make release

##########################
# Webserver runner stage #
##########################
FROM scratch

EXPOSE 8080

COPY --from=asmttpd-builder ./asmttpd/asmttpd /

COPY --from=hugo-builder /src/public /public

CMD ["/asmttpd", "/public", "8080"]
