# OpenAudible for Docker

This container runs [OpenAudible](https://openaudible.org) with its GUI accessible by browser. 

This is an experimental alternative to the supported and recommended desktop binaries available at [openaudible.org](https://openaudible.org). 

This project is hosted on [github](https://github.com/openaudible/openaudible_docker) and [dockerhub](https://hub.docker.com/r/openaudible/openaudible)

This project is based on the excellent [https://www.kasmweb.com/kasmvnc](https://www.kasmweb.com/kasmvnc) remote desktop container.

## Description

OpenAudible runs on Linux, Mac, and Windows. This Docker container runs the latest linux version
in a container running Ubuntu that is via web browser. 

This allows you to run OpenAudible from a container, on the cloud, or from any Docker capable system (NAS system?).

No passwords are needed to access the web page, but a password can be added by modifying the "run.sh" file. 

For personal use. Only one user can
view web sessions at one time-so this can't be used to share the application with multiple viewers at the same time.


The container stores data in `/config/OpenAudible` inside the container. Map this to a volume on your host system to access downloaded and converted audiobooks. See the NAS Deployment section below for platform-specific instructions.

## Quick Start

```
docker run -d --rm -it -p 3000:3000 --security-opt seccomp=unconfined --name openaudible openaudible/openaudible:latest
```

Then open your web browser to http://localhost:3000

You'll probably want to access the volume where OpenAudible saves books.

## NAS Deployment

### Docker Compose (Any Platform)

The easiest deployment method is using docker-compose:

**Generic (works everywhere):**
```bash
wget https://raw.githubusercontent.com/openaudible/openaudible_docker/main/docker-compose.yml
docker-compose up -d
```

**Synology-optimized:**
```bash
wget https://raw.githubusercontent.com/openaudible/openaudible_docker/main/docker-compose.synology.yml -O docker-compose.yml
# Edit file, then deploy via Container Manager > Project > Create
```

For detailed Synology instructions, see [SYNOLOGY.md](SYNOLOGY.md).

### Quick NAS Example (Command Line)

```bash
docker run -d \
  --name=openaudible \
  -p 3000:3000 \
  -v /your/nas/path:/config/OpenAudible \
  -e PUID=1026 \
  -e PGID=100 \
  --security-opt seccomp=unconfined \
  --restart unless-stopped \
  openaudible/openaudible:latest
```

Replace `/your/nas/path` with your actual NAS storage path.

**Synology tip:** Use `/volume1/Audiobooks` for easy network share access.

More NAS platforms coming soon (QNAP, Unraid, TrueNAS).

## Volume Configuration and Permissions

The container stores all OpenAudible data (books, metadata, settings) in `/config/OpenAudible` inside the container. You **must** map this to a volume on your host for data persistence.

### Important: File Permissions

The container runs as a non-root user (named `abc`) with configurable UID/GID. To avoid permission issues:

1. **Set PUID and PGID** to match your host user:
   ```bash
   docker run -d \
     -e PUID=$(id -u) \
     -e PGID=$(id -g) \
     -v /path/to/data:/config/OpenAudible \
     ...
   ```

2. **Pre-create the data directory** with correct ownership:
   ```bash
   mkdir -p /path/to/data
   chown $(id -u):$(id -g) /path/to/data
   ```

3. **If you get permission errors**, check directory ownership:
   ```bash
   ls -ld /path/to/data
   # Should show your user:group

   # Fix if needed:
   sudo chown -R $(id -u):$(id -g) /path/to/data
   ```

### Configuring the Data Directory with run.sh

The `run.sh` script now automatically:
- Creates the data directory if it doesn't exist
- Sets correct ownership based on your current user
- Validates permissions before starting the container

To customize the location, edit `OA_DIR` in `run.sh` or set it as an environment variable:

```bash
# Option 1: Edit run.sh directly (line ~14)
OA_DIR=${OA_DIR:-/your/custom/path}

# Option 2: Set environment variable before running
export OA_DIR=/volume1/docker/openaudible
./run.sh
```

### NAS-Specific Considerations

On Synology and other NAS systems:
- Use PUID/PGID matching your NAS user (check with `id` command via SSH)
- Synology typically uses PUID=1026, PGID=100 for the first user
- Ensure the volume path is accessible to that user
- See [SYNOLOGY.md](SYNOLOGY.md) for detailed NAS deployment instructions

## Building and running from source
```
git clone https://github.com/openaudible/openaudible_docker.git 
cd openaudible_docker
./run.sh
```

The [run.sh](run.sh) file builds and runs the docker image. You may want to modify it to expose the OPENAUDIBLE volume. 
Note: The latest version requires the docker run to include --security-opt seccomp=unconfined in the arguments. Without that, you would need to start OpenAudible manually, which can be done via:
```
./bash.sh
su abc
OpenAudible
```

If successful, the application will be up and running on port 3000 and
accessible via http://localhost:3000 in a browser.

The -rm flag removes the container when it quits. Any downloaded or converted books will be in the docker Volume.
## Upgrading OpenAudible

To upgrade OpenAudible to the latest version, stop and remove the container, then restart it. The latest version will be automatically downloaded and installed on startup.

**Your books, settings, and data are safe** - they're stored in the volume mount and will persist across container restarts.

```bash
docker stop openaudible
docker rm openaudible
docker run -d --rm -it -p 3000:3000 --security-opt seccomp=unconfined --name openaudible openaudible/openaudible:latest
```

Replace the `docker run` command with your actual command if you're using custom volumes or settings.

### Beta vs Production Versions

By default, the container downloads the latest **beta** version of OpenAudible. To use the production (stable) version instead:

```bash
docker run -d --rm -it -p 3000:3000 \
  -e OA_BETA=false \
  --security-opt seccomp=unconfined \
  --name openaudible \
  openaudible/openaudible:latest
```


## Known limitations:
* Another user logging on to the web page disconnects anyone else already connected
* No password protection is offered or https proxy-but can be added. 
* But it does allow a user to try the software in a containerized, accessible-from-anywhere way.

## Notes
* This is experimental and unsupported. We hope some people find it useful. 
* If you find any issues, please report them on [github.com/openaudible/openaudible_docker/issues](https://github.com/openaudible/openaudible_docker/issues).
* Before deleting the container and volume, if you logged into Audible, you should Log out using the Control Menu, which will delete your virtual device.
* Would appreciate feedback or pull requests. 
* Docker is great for testing something, but we still recommend the desktop app for most users.

## License
The OpenAudible desktop application is free to try shareware.

