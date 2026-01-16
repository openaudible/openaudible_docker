# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

OpenAudible Docker is a containerized version of the OpenAudible audiobook manager that runs with a web-accessible GUI. The project uses KasmVNC (from linuxserver.io) to provide browser-based access to the OpenAudible Linux application.

**Key characteristics:**
- Browser-accessible GUI running on port 3000
- Based on Debian Bookworm with KasmVNC remote desktop
- Supports x86_64 and aarch64 architectures only
- Downloads and installs OpenAudible at container startup (not bundled in the image)
- Data persists in `/config/OpenAudible` volume mount

## Architecture

### Container Lifecycle

1. **Entrypoint** (`assets/entrypoint.sh`): Minimal wrapper that passes control to the base image's `/init`
2. **Init scripts** (`/etc/cont-init.d/98-configure-openbox`): Configures Openbox to prevent auto-maximizing windows
3. **Autostart** (`/defaults/autostart`): Points to `/app/start_openaudible.sh`
4. **Application startup** (`assets/start_openaudible.sh`):
   - If OpenAudible not installed → runs `install.sh`
   - If already installed → launches `/app/OpenAudible/OpenAudible`

### Installation Flow

**First run:**
- `start_openaudible.sh` detects missing `/app/OpenAudible/OpenAudible`
- Calls `install.sh` which opens an xterm window
- `install.sh` calls `upgrade.sh` to download and install OpenAudible
- `upgrade.sh`:
  - Determines architecture (x86_64 or aarch64)
  - Downloads installer from `https://openaudible.org/latest/OpenAudible_{arch}.sh`
  - Appends `?beta=true` or `?beta=false` based on `OA_BETA` env var
  - Installs to `/app/OpenAudible`
  - Launches the application

**Subsequent runs:**
- `start_openaudible.sh` finds existing installation and launches directly

### Key Environment Variables

- `OA_BETA`: Set to `true` to download beta versions (default: true in Dockerfile)
- `OA_KIOSK_MODE`: Disables quit menu in OpenAudible (default: true)
- `oa_internal_browser`: Uses internal browser for authentication (default: true)
- `KASM_AUDIO_ENABLED`: Enables audio support (default: 1)
- `PUID`/`PGID`: User/group ID for file permissions (set via docker run)
- `PASSWORD`: Optional password for web access (set in run.sh)

### File Structure

```
/
├── Dockerfile              # Main container definition
├── run.sh                 # Build and run script for development
├── bash.sh                # Quick exec into running container
├── push.sh                # Publish to DockerHub (maintainer use)
├── assets/                # Files copied into container
│   ├── entrypoint.sh     # Container entrypoint
│   ├── start_openaudible.sh  # Application launcher
│   ├── install.sh        # First-run installation wrapper
│   ├── upgrade.sh        # Downloads/installs OpenAudible
│   ├── configure-openbox # Init script for Openbox config
│   └── index.html        # Custom KasmVNC landing page
├── README.md              # User documentation
└── SYNOLOGY.md           # Synology NAS deployment guide
```

## Development Commands

**IMPORTANT FOR CLAUDE CODE: Do not execute `docker build` or `./run.sh` yourself.** These commands can take significant time and resources. Instead, ask the developer to run these commands and report back the results. You can help by preparing necessary file changes, but defer the actual build/run execution to the developer.

### Build and Run

```bash
./run.sh
```
This script:
- Builds the Docker image as `openaudible`
- Stops/removes any existing `openaudible` container
- Starts container with volume mounted at `$HOME/OpenAudibleDocker`
- Exposes port 3000
- Follows container logs

**Access:** http://localhost:3000

### Exec into Running Container

```bash
./bash.sh
```
Executes bash as user `abc` (the non-root user in the container).

### Testing OpenAudible Upgrades

To test the upgrade mechanism without rebuilding:

```bash
docker exec -it -u abc openaudible bash
cd /app
./upgrade.sh
```

### Manual OpenAudible Start (if seccomp issues)

If the container runs but OpenAudible doesn't auto-start:

```bash
./bash.sh
su abc
OpenAudible
```

### Publishing to DockerHub

```bash
./push.sh
```
Builds with `--no-cache` and pushes to `openaudible/openaudible:latest`.

## Important Constraints

### Architecture Validation

The Dockerfile explicitly validates architecture and will fail builds on unsupported platforms. Only x86_64 and aarch64 are supported by OpenAudible upstream.

### Security Options

The container **requires** `--security-opt seccomp=unconfined` to auto-start OpenAudible. Without this flag, the application must be started manually. This is a known limitation of the KasmVNC base image and Openbox interaction.

### User Permissions

The container runs OpenAudible as user `abc` (from the base image). Volume mounts should use PUID/PGID environment variables to match host filesystem permissions.

### Data Persistence

All OpenAudible data (books, metadata, settings) is stored in `/config/OpenAudible` inside the container. This **must** be volume-mounted to persist data across container restarts.

## Modification Guidelines

### Changing OpenAudible Version Source

The `OA_BETA` environment variable controls whether beta or stable versions are downloaded. Modify in:
- `Dockerfile`: Default behavior
- `run.sh`: Per-run override
- Docker run command: `-e OA_BETA=false`

### Customizing the Web Interface

The KasmVNC web interface can be customized via `assets/index.html`, which replaces the default `/kclient/public/index.html` in the base image.

### Adding Init Scripts

Init scripts go in `/etc/cont-init.d/` (numbered for execution order). See `assets/configure-openbox` for an example.

### Window Manager Configuration

Openbox is configured via `assets/configure-openbox`, which modifies `/config/.config/openbox/rc.xml` to prevent auto-maximizing windows. This improves the web UI experience.

## Troubleshooting Context

### Application Doesn't Start

1. Check if `--security-opt seccomp=unconfined` is present
2. Verify architecture is x86_64 or aarch64
3. Check logs: `docker logs -f openaudible`
4. Exec in and check if `/app/OpenAudible/OpenAudible` exists

### Permission Errors with Volume Mount

Ensure PUID and PGID match the host user who owns the volume directory:
```bash
docker run -e PUID=$(id -u) -e PGID=$(id -g) ...
```

### Installation Fails

Check network connectivity and verify OpenAudible upstream is accessible:
```bash
curl -I https://openaudible.org/latest/OpenAudible_x86_64.sh
```
