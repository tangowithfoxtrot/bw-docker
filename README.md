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
version: '3.3'
services:
  bw_api:
    container_name: bwapi
    hostname: bwapi
    platform: linux/amd64
    image: tangowithfoxtrot/bw-cli:serve-latest
    ports:
      - '127.0.0.1:2929:2929' # serve on 127.0.0.1
    volumes:
      - "$HOME/.config/Bitwarden CLI:/root/.config/Bitwarden CLI"
    healthcheck:
      test: curl -f http://127.0.0.1:2929/status
      interval: 5s
      timeout: 2s
      retries: 3
      start_period: 5s
```
