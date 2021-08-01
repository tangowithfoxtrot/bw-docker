# bw-docker
The latest Bitwarden CLI in a Docker container.

## Instructions
Run `docker build -t bw-cli:amd64 .`

Then, `docker run -v bw:/root/.config/Bitwarden\ CLI/ -it bw-cli:amd64 login`
