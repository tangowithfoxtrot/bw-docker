FROM --platform=linux/amd64 debian:latest
ENV DEBIAN_FRONTEND=noninteractive

WORKDIR /usr/local/bin
RUN apt update && apt install -y curl unzip libsecret-1-0 jq
COPY entrypoint.sh .
RUN export VER=$(curl -H "Accept: application/vnd.github+json" https://api.github.com/repos/bitwarden/clients/releases | jq  -r 'sort_by(.published_at) | reverse | .[].name | select( index("CLI") )' | sed 's:.*CLI v::' | head -n 1) && \
  curl -LO "https://github.com/bitwarden/clients/releases/download/cli-v{$VER}/bw-linux-{$VER}.zip" \
  && unzip *.zip && chmod +x ./bw
ENTRYPOINT [ "/usr/local/bin/entrypoint.sh" ]
