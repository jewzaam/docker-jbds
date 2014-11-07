docker-jbds
==========

Docker image for running JBoss Developer Studio.

# Why?
I get tired of environment specific variances and having to deal with system re-installs.  After learning how to run a graphical application within a docker image I'm trying this to see if it will be reusable by others, specifically team members.

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
