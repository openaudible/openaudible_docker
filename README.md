# OpenAudible for Docker

This container runs [OpenAudible](https://openaudible.org) with its GUI accessible by browser. 

This is an experimental alternative to the supported and recommended desktop binaries available at [openaudible.org](https://openaudible.org). 

This project is hosted on [github](https://github.com/openaudible/openaudible_docker) and [dockerhub](https://hub.docker.com/r/openaudible/openaudible)

This project is based on the excellent [linuxserver.io/webtop](https://docs.linuxserver.io/images/docker-webtop) remote desktop container.

## Description

OpenAudible runs on Linux, Mac, and Windows. This Docker container runs the latest linux version
in a container running Ubuntu that is via web browser. It uses webtop by linuxserver.io. 

This allows you to run OpenAudible from a container, on the cloud, or from any Docker capable system (NAS system?).

No passwords are needed to access the web page (so use care!). For personal use. Only one user can
view web sessions at one time-so this can't be used to share the application with multiple viewers at the same time.


## Quick Start

```
docker run -d --rm -it -v $HOME/OpenAudible:/config/OpenAudible -p 3000:3000 -e PGID=`id -g` -e PUID=`id -u` --name openaudible openaudible/openaudible:latest
```

Then open your web browser to http://localhost:3000

Once OpenAudible has been started (by visiting the web site above), your books will and setting files will be available in ~/OpenAudible


## Building and running from source
```
git clone https://github.com/openaudible/openaudible_docker.git 
cd openaudible_docker
./run.sh
```

The [run.sh](run.sh) file builds and runs the docker image. 

If successful, the application will be up and running on port 3000 and
accessible via [http://localhost:3000](http://localhost:3000) in a browser.

The optional -rm flag removes the container when it quits. Any downloaded or converted books will be in the docker Volume.

The run.sh script sets the UID and GID (user and group) id's for file access so files generated use your user and group IDs.

## Getting latest version and upgrading
This docker image starts by installing the latest version from a GUI terminal window (so you can see the progress.)
When running, you might get a notification that a new version is available. 
While upgrading by downloading and running the installer may work, it is probably easier to just exit the docker container, remove it, and pull it again.

```
docker stop openaudible
docker rm openaudible    # Not needed if the -rm flag was used
```
Then re-run the command(s) above to start it anew. Your settings should still be saved in the docker volume that should be mapped to a home directory.

## Known limitations:
* Another user logging on to the web page disconnects anyone else already connected
* No password protection is enabled by default. 
* https not supported, but it will work using a reverse proxy like traefik or nginx.  

The Docker version of OpenAudible allowa user to try the software in a containerized, accessible-from-anywhere way.

## TODO items
* Add a user/password for accessing the VM 
* Perhaps experiment with Ubuntu Kiosk Mode, to disable terminal, su, etc? OpenAudible and system file browser.
* lock down "su" root ability (change root password?)  

## Notes
* This is experimental and unsupported. We hope some people find it useful. It is a neat way to run a desktop app in a container.  
* If you find any issues, please report them on [github.com/openaudible/openaudible_docker/issues](https://github.com/openaudible/openaudible_docker/issues).
* Before deleting the container and volume, if you logged into Audible, you should Log out using the Control Menu, which will delete your virtual device.
* Would appreciate feedback or pull requests. 
* Docker is great for testing something, but we still recommend the desktop app for most users.

## License
This repository is licensed under the GNU GPL 3.0 because that is what [docker-webtop](https://github.com/linuxserver/docker-webtop) uses.

The OpenAudible desktop application is free to try shareware.
