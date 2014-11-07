docker-X11
==========

Simple docker image for running running GUI app.

# Why?
I had some problems getting this to work as a proof of concept and wanted to put the very simple example I came up with that works on github.

# Using This Thing

1. Install Docker
2. Run build script: `./build.sh`
    * note this includes adding a user to the image same as $USER env variable
3. Run setup script: `./setup.sh`
    * sets selinux to permissive mode
    * sets up xhost for the specific user
4. Run some GUI: `./run.sh xeyes`

# Assumptions

## $USER member of 'docker' group

Why?  So you don't have to use `sudo` for all docker commands.

How?  Steps taken from [this article](http://askubuntu.com/questions/477551/how-can-i-use-docker-without-sudo):
* sudo gpasswd -a ${USER} docker
* sudo service docker restart
* newgrp docker
