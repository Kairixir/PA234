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
FROM alpine:3.13.2 AS asmttpd-builder

RUN apk add --no-cache yasm make git gcompat nasm binutils

WORKDIR /asmttpd

# Get source for asmttpd
RUN git clone --depth=1 https://github.com/nemasu/asmttpd.git .

RUN make

RUN adduser -D asmttpd

RUN mkdir /asmttpd/web_root/about && echo "ahoj" >> /asmttpd/web_root/about/index.html

CMD ["/asmttpd/asmttpd", "/asmttpd/web_root", "8080"]

# 
# ##########################
# # Webserver runner stage #
# ##########################
# FROM scratch
# 
# EXPOSE 8080
# 
# # Get user to run non-privileged, site and binary
# COPY --from=asmttpd-builder /etc/passwd /etc/passwd
# 
# COPY --from=asmttpd-builder /asmttpd/asmttpd /
# 
# COPY --from=hugo-builder /src/public /public
# 
# CMD ["/asmttpd", "/", "8080"]
