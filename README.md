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
version: "3.3"
services:
  bw_api:
    container_name: bw_api
    hostname: bw_api
    platform: linux/amd64
    image: tangowithfoxtrot/bw-cli:${TAG:-latest}
    # build:
    #   context: .
    #   dockerfile: Dockerfile
    env_file:
      - .env
    environment:
      UNLOCK_VAULT: true
    # volumes: # uncomment to use Bitwarden CLI data from host
    #   - "$HOME/.config/Bitwarden CLI:/root/.config/Bitwarden CLI" # Linux
    #   - "$HOME/Library/Application Support/Bitwarden CLI:/root/.config/Bitwarden CLI" # macOS
    ports:
      - "127.0.0.1:${SERVE_PORT:-8087}:${SERVE_PORT:-8087}"
    healthcheck:
      test: curl -f http://localhost:${SERVE_PORT:-8087}/status || exit 1
      interval: 5s
      timeout: 2s
      retries: 3
      start_period: 5s
```
