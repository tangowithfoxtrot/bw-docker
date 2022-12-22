# bw-docker
The latest Bitwarden CLI in a Docker container.

## Instructions
Run `docker build -t bw-cli:latest .`

Then, `docker run -v $HOME:/root/.config/Bitwarden\ CLI/ -it bw-cli:latest login`
