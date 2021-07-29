# bw-docker
The latest Bitwarden CLI in a Docker container.

## Instructions
Run `docker build -t bw:focal .`

Then, `docker run -v bw:/root/.config/Bitwarden\ CLI/ -it bw:focal login`
