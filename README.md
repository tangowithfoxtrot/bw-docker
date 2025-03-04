# bw-docker

The latest Bitwarden CLI in a Docker container.

## Instructions

### Interactive CLI

Run `docker build -t bw-cli:latest .`

Then, `docker run -v $HOME/.config/Bitwarden\ CLI/:/root/.config/Bitwarden\ CLI/ -it bw-cli:latest login`

### Serve API

Create a local [Vault Management API](https://bitwarden.com/help/vault-management-api/) instance:

`docker-compose.yml`
```yaml
services:
  bw_api:
    container_name: bw_api
    hostname: bw_api
    platform: linux/amd64
    image: tangowithfoxtrot/bw-cli:${TAG:-busybox-lastest}
    # environment: # uncomment if you're passing $VAULT_PASSWORD as a secret to unlock the vault
    #   UNLOCK_VAULT: true
    volumes:
      - "$HOME/.config/Bitwarden CLI:/root/.config/Bitwarden CLI" # Linux
    #   - "$HOME/Library/Application Support/Bitwarden CLI:/root/.config/Bitwarden CLI" # macOS
    ports:
      - "127.0.0.1:${SERVE_PORT:-8087}:${SERVE_PORT:-8087}"
```
