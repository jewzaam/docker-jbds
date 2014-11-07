#!/bin/sh

docker run -i -t --rm -e DISPLAY=$DISPLAY -u $USER -v /tmp/.X11-unix:/tmp/.X11-unix nmalik/x11:fedora "$@"
