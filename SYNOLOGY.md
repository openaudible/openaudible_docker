# OpenAudible on Synology NAS

IN PROGRESS. This Document will provide instructions on using OpenAudible on Synology NAS.

Comprehensive guide for deploying OpenAudible Docker container on Synology DSM.

## Table of Contents
- [Introduction](#introduction)
- [Quick Start (Docker Compose)](#quick-start-docker-compose-recommended)
- [Quick Start (GUI)](#quick-start-gui-method)
- [Finding PUID/PGID](#finding-your-puidpgid)
- [Command Line Deployment](#command-line-deployment)
- [Accessing Your Data](#accessing-your-data)
- [Sharing Audiobooks on Your Network](#sharing-audiobooks-on-your-network)
- [Troubleshooting](#troubleshooting)
- [Upgrading](#upgrading)
- [Optional: Web Status Page](#optional-web-status-page)

## Introduction

### What is OpenAudible Docker?

OpenAudible is an audiobook manager that allows you to download and convert your Audible audiobooks. This Docker container runs OpenAudible with a web-based interface, making it perfect for running on your Synology NAS 24/7.

### Why Use It on Synology?

- **Centralized Storage**: Keep all your audiobooks in one place on your NAS
- **Always Available**: Access OpenAudible from any device via web browser
- **Resource Efficient**: Runs in the background without consuming desktop resources
- **Automatic Backups**: Leverage Synology's backup features for your audiobook library

### Requirements

- Synology NAS with DSM 7.0 or later
- Container Manager package installed (formerly Docker package)
- At least 2GB RAM available
- Port 3000 available
- Storage space for your audiobooks

## Quick Start (Docker Compose - Recommended)

The easiest way to deploy OpenAudible on Synology is using the included `docker-compose.synology.yml` file. This method automatically handles all security settings and makes configuration straightforward.

### Step 1: Download the Synology Compose File

Download the [`docker-compose.synology.yml`](docker-compose.synology.yml) file from this repository, or SSH into your Synology and run:

```bash
# Create project directory
mkdir -p /volume1/docker/projects/openaudible
cd /volume1/docker/projects/openaudible

# Download Synology-specific compose file
wget -O docker-compose.yml https://raw.githubusercontent.com/openaudible/openaudible_docker/main/docker-compose.synology.yml

# Or use the generic version
# wget https://raw.githubusercontent.com/openaudible/openaudible_docker/main/docker-compose.yml
```

**Note:** We download it as `docker-compose.yml` (without .synology) so docker-compose commands work normally.

### Step 2: Customize the Configuration

Edit the `docker-compose.yml` file and customize these key settings:

```yaml
volumes:
  # Change this path to where you want audiobooks stored
  - /volume1/docker/openaudible:/config/OpenAudible

environment:
  # Change to your Synology user ID (run 'id -u' via SSH)
  - PUID=1026
  # Change to your group ID (run 'id -g' via SSH)
  - PGID=100
  # Optional: Set timezone
  - TZ=America/New_York
```

**For easier network access**, use a dedicated shared folder:
```yaml
volumes:
  # This makes audiobooks accessible at \\YOUR-NAS\Audiobooks
  - /volume1/Audiobooks:/config/OpenAudible
```

### Step 3: Pre-create the Data Directory

**IMPORTANT:** Create the directory with correct permissions before deploying:

```bash
# SSH into your Synology
ssh admin@YOUR-NAS-IP

# Create directory (adjust path to match your docker-compose.yml)
sudo mkdir -p /volume1/docker/openaudible
sudo chown 1026:100 /volume1/docker/openaudible  # Use your PUID:PGID
sudo chmod 755 /volume1/docker/openaudible
```

### Step 4: Deploy via Container Manager

1. Open **Container Manager** on your Synology
2. Go to **Project** tab
3. Click **Create**
4. Choose **Upload docker-compose.yml**
5. Select your edited `docker-compose.yml` (or `docker-compose.synology.yml`) file
6. Project name: `openaudible`
7. Click **Next** then **Done**

### Step 5: Access OpenAudible

Open your browser and go to: `http://YOUR-NAS-IP:3000`

The first launch will download and install OpenAudible (takes 1-2 minutes).

### Managing the Container

In Container Manager > Project > openaudible:
- **Stop**: Stops the container
- **Start**: Starts the container
- **Build**: Rebuilds (not needed for this project)
- **Action > Down**: Completely removes the container (data is safe in volume)

To upgrade OpenAudible, stop the project, then start it again. The latest version will be downloaded automatically.

## Quick Start (GUI Method)

If you prefer not to use docker-compose, you can deploy manually via the Container Manager GUI:

### Step 1: Install Container Manager

1. Open **Package Center** on your Synology
2. Search for **Container Manager** (or **Docker** on older DSM versions)
3. Click **Install** and wait for completion

### Step 2: Download OpenAudible Image

1. Open **Container Manager**
2. Go to **Registry**
3. Search for `openaudible/openaudible`
4. Select the image and click **Download**
5. Choose the `latest` tag
6. Wait for download to complete

### Step 3: Create Container

1. Go to **Image** tab in Container Manager
2. Select `openaudible/openaudible:latest`
3. Click **Launch**

### Step 4: Configure General Settings

On the **General Settings** page:
- **Container Name**: `openaudible`
- **Enable auto-restart**: ✓ (Recommended)
- Click **Advanced Settings**

### Step 5: Configure Advanced Settings

#### Volume Settings Tab

**IMPORTANT - Pre-create the folder first:**
Before mapping the volume, ensure the folder exists with correct permissions:
1. Open File Station and create `/docker/openaudible` folder
2. Or via SSH: `mkdir -p /volume1/docker/openaudible && sudo chown $(id -u):$(id -g) /volume1/docker/openaudible`

Click **Add Folder** and configure:
- **Folder**: Choose `/docker/openaudible` (or your preferred path)
- **Mount path**: `/config/OpenAudible` (IMPORTANT: Must be exact)

#### Port Settings Tab
Click **Add** and configure:
- **Local Port**: `3000`
- **Container Port**: `3000`
- **Type**: `TCP`

#### Environment Tab
Click **Add** for each variable:

| Variable | Value | Description |
|----------|-------|-------------|
| PUID | `1026` | Your user ID (see [Finding PUID/PGID](#finding-your-puidpgid)) |
| PGID | `100` | Your group ID (typically 100 for users group) |
| PASSWORD | *(leave empty)* | Optional: Set a password for VNC access |
| OA_BETA | `true` | Optional: Use beta versions of OpenAudible |

#### Execution Command Tab (Optional)
For advanced users having startup issues:
- Enable "Ru

n command as privileged" (if available)

### Step 6: Review and Apply

1. Review all settings
2. Click **Done** to create the container
3. The container should start automatically

### Step 7: Access OpenAudible

1. Open your web browser
2. Navigate to: `http://your-nas-ip:3000`
   - Replace `your-nas-ip` with your NAS IP address
   - Example: `http://192.168.1.100:3000`
3. You should see the OpenAudible interface loading
4. First launch will download and install OpenAudible (takes 1-2 minutes)

## Finding Your PUID/PGID

To ensure proper file permissions, you need to find your user ID and group ID.

### Method 1: SSH (Recommended)

1. Enable SSH on your Synology:
   - Go to **Control Panel** > **Terminal & SNMP**
   - Enable **SSH service**

2. SSH into your NAS:
   ```bash
   ssh your-username@your-nas-ip
   ```

3. Find your PUID:
   ```bash
   id -u
   ```
   Output example: `1026`

4. Find your PGID:
   ```bash
   id -g
   ```
   Output example: `100`

### Method 2: Common Defaults

**Most Synology systems:**
- First admin user: PUID = `1026`, PGID = `100`
- users group: PGID = `100`
- administrators group: PGID = `101`

**If unsure, use:** PUID = `1026`, PGID = `100`

## Command Line Deployment

For advanced users who prefer SSH and command line:

### Pre-create Data Directory (IMPORTANT)

Before running the container, create the data directory with correct permissions:

```bash
# Find your user ID and group ID
id -u  # Usually 1026
id -g  # Usually 100

# Create directory with correct ownership
mkdir -p /volume1/docker/openaudible
sudo chown $(id -u):$(id -g) /volume1/docker/openaudible
chmod 755 /volume1/docker/openaudible
```

This prevents Docker from creating the directory as root, which would cause permission errors.

### Basic Deployment

```bash
docker run -d \
  --name=openaudible \
  -p 3000:3000 \
  -v /volume1/docker/openaudible:/config/OpenAudible \
  -e PUID=1026 \
  -e PGID=100 \
  --security-opt seccomp=unconfined \
  --restart unless-stopped \
  openaudible/openaudible:latest
```

### With Optional Settings

```bash
docker run -d \
  --name=openaudible \
  -p 3000:3000 \
  -v /volume1/docker/openaudible:/config/OpenAudible \
  -e PUID=1026 \
  -e PGID=100 \
  -e PASSWORD=your-password \
  -e OA_BETA=true \
  --security-opt seccomp=unconfined \
  --restart unless-stopped \
  --memory=2g \
  --cpus=2 \
  openaudible/openaudible:latest
```

### Adjust Volume Path

If you're using a different volume or path, adjust accordingly:
- `/volume1/docker/openaudible` - Volume 1, docker subfolder
- `/volume2/data/openaudible` - Volume 2, data subfolder
- `/volumeUSB1/openaudible` - External USB drive

## Accessing Your Data

Your audiobooks and data are stored in the volume you mapped. Here's how to access them:

### Via File Station

1. Open **File Station**
2. Navigate to `docker/openaudible/` (or your chosen folder)
3. You'll see the OpenAudible directory structure

### Via SMB/CIFS (Windows/Mac/Linux)

**Windows:**
```
\\your-nas-ip\docker\openaudible
```

**Mac/Linux:**
```
smb://your-nas-ip/docker/openaudible
```

### Directory Structure

After OpenAudible runs for the first time, you'll see:

```
openaudible/
├── books/          # Downloaded audiobook files (original format)
├── m4b/            # Converted M4B audiobook files
├── mp3/            # Converted MP3 audiobook files
├── aax/            # Original Audible AAX files
├── art/            # Cover artwork and images
├── books.json      # OpenAudible library database
└── .config/        # Application configuration files
```

### Backup Recommendations

Since all your audiobooks are in one folder, you can:
- Use **Hyper Backup** to back up the `/docker/openaudible` folder
- Use **Snapshot Replication** for version history
- Sync to another NAS or cloud storage with **Cloud Sync**

## Sharing Audiobooks on Your Network

One of the key benefits of running OpenAudible on Synology is making your audiobook library accessible to all devices on your network. Here are the best approaches:

### Option 1: Use a Dedicated Shared Folder (Recommended)

This is the cleanest approach for easy network access:

**Step 1: Create a Shared Folder**
1. Open **Control Panel** > **Shared Folder**
2. Click **Create** > **Create**
3. Configure:
   - **Name**: `Audiobooks`
   - **Description**: `OpenAudible audiobook library`
   - **Location**: Choose your volume (usually Volume 1)
4. Click **Next** through the wizard
5. Set permissions for your user account (Read/Write)
6. Click **Apply**

**Step 2: Configure OpenAudible to Use This Folder**

In your `docker-compose.yml` or Container settings:
```yaml
volumes:
  - /volume1/Audiobooks:/config/OpenAudible
```

Or for manual deployment:
```bash
-v /volume1/Audiobooks:/config/OpenAudible
```

**Step 3: Access from Any Device**

- **Windows**: Open File Explorer and go to `\\YOUR-NAS-IP\Audiobooks` or `\\YOUR-NAS-NAME\Audiobooks`
- **Mac**: In Finder, press Cmd+K and connect to `smb://YOUR-NAS-IP/Audiobooks`
- **Linux**: Mount via `smb://YOUR-NAS-IP/Audiobooks`
- **Mobile (DS file app)**: Browse to Audiobooks folder

**Directory structure you'll see:**
```
Audiobooks/
├── books/          # Original downloaded files
├── m4b/            # Converted M4B files (single file per book)
├── mp3/            # Converted MP3 files (chapters)
├── aax/            # Original Audible AAX files
├── art/            # Cover artwork
└── books.json      # Library database
```

### Option 2: Share the Docker Folder

If you're using `/volume1/docker/openaudible`, you can access it via:
- **Windows**: `\\YOUR-NAS-IP\docker\openaudible`
- **Mac**: `smb://YOUR-NAS-IP/docker/openaudible`

**Note:** You may need to create the `docker` shared folder:
1. Go to **Control Panel** > **Shared Folder**
2. Create a shared folder named `docker` pointing to `/volume1/docker`
3. Set appropriate permissions

### Option 3: Access Specific Subdirectories

If you only want to share the converted audiobooks (not the entire OpenAudible directory):

**For M4B files only:**
1. Create shared folder: `Audiobooks-M4B`
2. In File Station, create a symbolic link from `/volume1/Audiobooks-M4B` to `/volume1/docker/openaudible/m4b`
3. Or mount just that subdirectory:
   ```yaml
   volumes:
     - /volume1/docker/openaudible:/config/OpenAudible
     - /volume1/docker/openaudible/m4b:/volume1/Audiobooks-M4B:ro  # Read-only
   ```

### Option 4: Import Existing Audiobooks

If you already have audiobooks in another location and want OpenAudible to access them:

**In docker-compose.yml, add additional mount:**
```yaml
volumes:
  - /volume1/docker/openaudible:/config/OpenAudible
  - /volume1/Media/Audiobooks:/import/audiobooks:ro  # Read-only
  - /volume1/Music/Audiobooks:/import/music:ro       # Another location
```

**Then in OpenAudible:**
1. Use the file picker to browse to `/import/audiobooks` or `/import/music`
2. Select books to import
3. OpenAudible will copy them to its library

**Advantages:**
- Keep your existing audiobook organization
- OpenAudible can access multiple source directories
- Original files remain untouched (read-only mount)
- Books are copied to OpenAudible's managed library

### Best Practices for Network Sharing

1. **Permissions**: Ensure your user has Read/Write access to the shared folder
2. **Naming**: Use clear names like `Audiobooks` instead of `docker/openaudible`
3. **Organization**: Let OpenAudible manage the folder structure (books/, m4b/, mp3/, etc.)
4. **Media Players**: Point your audiobook apps (Plex, Audiobookshelf, etc.) to the shared folder
5. **Backups**: Use Hyper Backup to back up the entire shared folder regularly

### Recommended Setup for Most Users

```yaml
# docker-compose.yml
volumes:
  # Primary: Store all OpenAudible data in dedicated shared folder
  - /volume1/Audiobooks:/config/OpenAudible

  # Optional: Import from existing locations (read-only)
  - /volume1/Media/ExistingAudiobooks:/import/existing:ro
```

**Result:**
- Audiobooks accessible at: `\\YOUR-NAS\Audiobooks`
- Easy to share with family members
- Simple backup configuration
- Can import from existing collections
- Compatible with media server apps

## Troubleshooting

### Container Won't Start

**Check port availability:**
```bash
sudo netstat -tlnp | grep 3000
```
If port 3000 is in use, either:
- Stop the conflicting service
- Use a different port: `-p 3001:3000`

**Check Container Manager logs:**
1. Open Container Manager
2. Click on the `openaudible` container
3. View **Logs** tab for error messages

**Verify volume path exists:**
1. Open File Station
2. Ensure `/docker/openaudible` folder exists
3. Create it manually if needed

### Permission Errors

**Symptoms:**
- Container reports "/config/OpenAudible is not read/writable"
- Can't write files
- "Permission denied" errors in logs
- Books don't save
- Container fails to start properly

**Root Cause:**
When Docker creates a non-existent volume mount directory, it creates it with root ownership. Even though you set PUID/PGID, the directory is already owned by root when the container starts, preventing the container's user (abc) from writing to it.

**Solutions:**

1. **Pre-create the directory with correct permissions (BEST METHOD):**

   Via SSH:
   ```bash
   # SSH into your Synology
   ssh your-username@your-nas-ip

   # Find your user ID and group ID
   id -u  # Usually 1026 for first user
   id -g  # Usually 100 for users group

   # Create the directory with correct ownership
   mkdir -p /volume1/docker/openaudible
   sudo chown $(id -u):$(id -g) /volume1/docker/openaudible
   sudo chmod 755 /volume1/docker/openaudible
   ```

2. **Fix existing directory permissions:**

   If the directory already exists with wrong ownership:
   ```bash
   # Check current ownership
   ls -ld /volume1/docker/openaudible

   # Fix ownership (replace 1026:100 with your actual PUID:PGID)
   sudo chown -R 1026:100 /volume1/docker/openaudible
   sudo chmod -R 755 /volume1/docker/openaudible
   ```

3. **Via File Station:**
   - Right-click the `openaudible` folder
   - Select **Properties** > **Permission**
   - Ensure your user has Read/Write permissions
   - If the folder doesn't exist, create it first via File Station

4. **Verify PUID/PGID in container:**
   - Make sure environment variables match your user (see [Finding PUID/PGID](#finding-your-puidpgid))
   - Double-check the values when creating/editing the container

**Prevention:**
Always create the data directory with correct ownership **before** starting the container for the first time. This prevents Docker from creating it as root.

### Can't Access Web Interface

**Check firewall:**
1. Go to **Control Panel** > **Security** > **Firewall**
2. Ensure port 3000 is allowed
3. Or temporarily disable firewall to test

**Test from NAS browser:**
1. Open browser on a computer
2. Try `http://localhost:3000` if on the NAS itself
3. Try `http://192.168.1.xxx:3000` from another computer

**Verify container is running:**
1. Open Container Manager
2. Check that `openaudible` shows Status: Running
3. If not, click **Start**

### OpenAudible Won't Install

**Symptom:** Container starts but OpenAudible installation fails

**Cause:** Missing `--security-opt seccomp=unconfined` flag

**Solutions:**

**Option 1: Use Command Line**
- Deploy using the CLI method with `--security-opt seccomp=unconfined` (see [Command Line Deployment](#command-line-deployment))

**Option 2: Enable Privileged Mode (GUI)**
1. Stop the container
2. Edit container settings
3. Go to **Advanced Settings** > **Execution Command**
4. Enable "Run command as privileged" (if available)
5. Start the container

### Audio Not Working in Browser

**Enable audio in browser:**
- Click the 🔊 volume icon in the web interface toolbar
- Grant microphone permissions if prompted
- Increase volume slider

**Check browser compatibility:**
- Chrome/Edge: Full support
- Firefox: Full support
- Safari: May have limitations

### Slow Performance

**Increase resources:**
1. Stop the container
2. Edit container settings
3. Set resource limits:
   - Memory: 2-4 GB recommended
   - CPU: 2-4 cores recommended

**Check NAS load:**
- Ensure NAS isn't running too many other services
- Check CPU/RAM usage in Resource Monitor

## Upgrading

### Upgrade OpenAudible Application

When a new version of OpenAudible is released:

**Method 1: Automatic (Easiest)**
1. Stop and delete the container (data is safe in the volume)
2. Pull the latest image
3. Recreate the container with the same settings

**Method 2: Via Command Line**
```bash
# Stop and remove container
docker stop openaudible
docker rm openaudible

# Pull latest image
docker pull openaudible/openaudible:latest

# Recreate container (use your original docker run command)
docker run -d \
  --name=openaudible \
  -p 3000:3000 \
  -v /volume1/docker/openaudible:/config/OpenAudible \
  -e PUID=1026 \
  -e PGID=100 \
  --security-opt seccomp=unconfined \
  --restart unless-stopped \
  openaudible/openaudible:latest
```

**Your data is safe!** All audiobooks and settings persist in the volume.

### Upgrade to Beta Version

To try beta/development versions:

**Via GUI:**
1. Add environment variable: `OA_BETA=true`
2. Restart container

**Via CLI:**
```bash
docker run -d \
  --name=openaudible \
  -p 3000:3000 \
  -v /volume1/docker/openaudible:/config/OpenAudible \
  -e PUID=1026 \
  -e PGID=100 \
  -e OA_BETA=true \
  --security-opt seccomp=unconfined \
  --restart unless-stopped \
  openaudible/openaudible:latest
```

## OpenAudible Web Feature

OpenAudible can generate web pages for your audiobook library. When enabled in OpenAudible, it creates HTML pages in the `/config/OpenAudible/web/` directory inside the container.

### Understanding Volume Mapping

The volume mapping in the container is:
- **Host (Synology):** `/volume1/docker/openaudible/`
- **Container:** `/config/OpenAudible/`

So when OpenAudible creates files in `/config/OpenAudible/web/` inside the container, they appear at `/volume1/docker/openaudible/web/` on your Synology NAS.

### Accessing the Web Pages

You have two options to access OpenAudible's web feature:

#### Option 1: Web Station (Recommended)

1. **Install Web Station**
   - Open **Package Center**
   - Search for **Web Station**
   - Click **Install**

2. **Create Web Portal**
   - Open **Web Station**
   - Go to **Web Service Portal**
   - Click **Create** > **Create Service Portal**
   - Configure:
     - **Portal name:** `OpenAudible`
     - **Document root:** `/docker/openaudible/web`
     - **Backend server:** None (static files)
     - **Portal type:** Name-based or Port-based
     - If Port-based, choose a port like `8080`

3. **Access Your Library**
   - Name-based: `http://your-nas-ip/` (or configured hostname)
   - Port-based: `http://your-nas-ip:8080/`

#### Option 2: Reverse Proxy

Use Synology's built-in reverse proxy to create a cleaner URL:

1. Go to **Control Panel** > **Login Portal** > **Advanced** > **Reverse Proxy**
2. Click **Create**
3. Configure:
   - **Source:**
     - Protocol: `HTTP`
     - Hostname: `openaudible.your-nas-name.local` (or use IP)
     - Port: `80`
   - **Destination:**
     - Protocol: `HTTP`
     - Hostname: `localhost`
     - Port: `8080` (if using Web Station on port 8080)

4. Access via: `http://openaudible.your-nas-name.local/`

### Enabling Web Feature in OpenAudible

To generate the web pages:
1. Open OpenAudible interface at `http://your-nas-ip:3000`
2. Go to **Tools** or **Preferences** menu
3. Enable the web export/web page generation feature
4. Configure output directory (should already be set to `/config/OpenAudible/web/`)
5. Generate/export your library

The web pages will automatically appear in your configured Web Station or reverse proxy location.

## Tips and Best Practices

### Security Recommendations

1. **Use PUID/PGID:** Always set to match your user for proper permissions
2. **Set a password:** Add `PASSWORD` environment variable for VNC authentication
3. **Firewall rules:** Only allow port 3000 from your local network
4. **HTTPS proxy:** Consider using Synology's reverse proxy with HTTPS

### Performance Tips

1. **Use SSD:** If possible, store container on SSD volume for better performance
2. **Allocate resources:** Give at least 2GB RAM and 2 CPU cores
3. **Regular cleanup:** Delete old AAX files after conversion to save space

### Backup Strategy

1. **Enable Hyper Backup:** Back up `/docker/openaudible` folder regularly
2. **Use Snapshots:** Enable Btrfs snapshots for quick recovery
3. **Export library:** Use OpenAudible's export feature periodically

## Additional Resources

- **OpenAudible Documentation:** [https://openaudible.org/](https://openaudible.org/)
- **Docker Hub:** [https://hub.docker.com/r/openaudible/openaudible](https://hub.docker.com/r/openaudible/openaudible)
- **GitHub Issues:** [https://github.com/openaudible/openaudible_docker/issues](https://github.com/openaudible/openaudible_docker/issues)
- **Synology Community:** [https://community.synology.com](https://community.synology.com)

## Getting Help

If you encounter issues:

1. **Check this troubleshooting guide** above
2. **Check container logs** in Container Manager
3. **Search GitHub issues:** Someone may have had the same problem
4. **Create a new issue:** Include logs and configuration details

## License

OpenAudible is free to try shareware. See [openaudible.org](https://openaudible.org) for licensing details.
