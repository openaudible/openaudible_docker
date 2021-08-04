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


You may want to map the volume /root/openaudible to access downloaded and converted audiobooks.

## Quick Start

```
docker run -d --rm -it -p 3000:3000 --name openaudible openaudible/openaudible:latest
```

Then open your web browser to http://localhost:3000

You'll probably want to access the volume where OpenAudible saves books.

## Building and running from source
```
git clone https://github.com/openaudible/openaudible_docker.git 
cd openaudible_docker
docker build -t openaudible .
docker run -d --rm -it -p 3000:3000 --name openaudible openaudible
```

The [run.sh](run.sh) file builds and runs the docker image. You may want to modify it to expose the OPENAUDIBLE volume. 

If successful, the application will be up and running on port 3000 and
accessible via http://localhost:3000 in a browser.

The -rm flag removes the container when it quits. Any downloaded or converted books will be in the docker Volume.


## Known limitations:
* Another user logging on to the web page disconnects anyone else already connected
* No password protection is offered or https proxy-but can be added. 
* But it does allow a user to try the software in a containerized, accessible-from-anywhere way.

## TODO items
* Add a user/password for accessing the VM 
* Perhaps experiment with Ubuntu Kiosk Mode, to disable terminal, su, etc? OpenAudible and system file browser.
* lock down "su" root ability (change root password?)  
* Document how to access the "config" volume so you can access any converted books from the host machine.

## Notes
* This is experimental and unsupported. We hope some people find it useful. 
* If you find any issues, please report them on [github.com/openaudible/openaudible_docker/issues](https://github.com/openaudible/openaudible_docker/issues).
* Before deleting the container and volume, if you logged into Audible, you should Log out using the Control Menu, which will delete your virtual device.
* Would appreciate feedback or pull requests. 
* Docker is great for testing something, but we still recommend the desktop app for most users.

## License
This repository is licensed under the GNU GPL 3.0 because that is what [docker-webtop](https://github.com/linuxserver/docker-webtop) uses.

The OpenAudible desktop application is free to try shareware.
