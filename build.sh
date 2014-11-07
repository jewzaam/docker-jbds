#!/bin/sh

(cat Dockerfile ; echo "RUN adduser $LOGNAME") \
    | docker build -t $USER/x11:fedora -
