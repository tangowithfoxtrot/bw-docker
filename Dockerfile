FROM ubuntu:focal
WORKDIR /usr/local/bin
RUN apt update && apt install -y curl unzip libsecret-1-0 jq
RUN export VER=$(curl https://github.com/bitwarden/cli/releases/latest | grep -oE [0-9]+\.[0-9]+\.[0-9]+) && \
curl -LO "https://github.com/bitwarden/cli/releases/download/v{$VER}/bw-linux-{$VER}.zip" \
&& unzip *.zip && chmod +x ./bw
ENTRYPOINT ["bw"]
