# syntax = docker/dockerfile:1.2
###############################################
#                 Build stage                 #
###############################################
FROM --platform=linux/amd64 debian:latest as builder
ENV DEBIAN_FRONTEND=noninteractive
WORKDIR /usr/local/bin

RUN apt update && apt install -y curl unzip jq

RUN VER=$(curl -H "Accept: application/vnd.github+json" https://api.github.com/repos/bitwarden/clients/releases | jq  -r 'sort_by(.published_at) | reverse | .[].name | select( index("CLI") )' | sed 's:.*CLI v::' | head -n 1) && \
  curl -LO "https://github.com/bitwarden/clients/releases/download/cli-v{$VER}/bw-linux-{$VER}.zip" \
  && unzip *.zip && chmod +x ./bw

RUN mkdir /lib-bw && ldd ./bw | tr -s '[:blank:]' '\n' | grep '^/lib' | xargs -I % cp % /lib-bw
RUN mkdir /lib64-bw && ldd ./bw | tr -s '[:blank:]' '\n' | grep '^/lib64' | xargs -I % cp % /lib64-bw

###############################################
#                  App stage                  #
###############################################
FROM --platform=linux/amd64 busybox:musl

# copy binaries
COPY --from=builder /usr/local/bin/bw /usr/bin/bw

# copy shared libraries
COPY --from=builder /lib-bw /lib
COPY --from=builder /lib64-bw /lib64

# copy ca-certificates
COPY --from=builder /etc/ssl/certs/ca-certificates.crt /etc/ssl/certs/ca-certificates.crt

# entrypoint
COPY entrypoint.sh /usr/bin/entrypoint.sh

ENTRYPOINT [ "/usr/bin/entrypoint.sh" ]
