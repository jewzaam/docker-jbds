#!/bin/sh

if [ "x"$1 != "x" ]; then
    CONTAINER_NAME="keep_${USER}_${1}"

    # have a container name.  does it already exist?
    CONTAINER_ID=`docker ps -a | grep $CONTAINER_NAME | awk '{print $1}'`

echo "CONTAINER_ID = $CONTAINER_ID"

    if [ "x"$CONTAINER_ID != "x" ]; then
        # conatiner exists, just try to start it
        # note, if it's already running this has no impact
        CMD="docker start $CONTAINER_ID"
    else
        # doesn't exist, start a new named container
        CMD="docker run -i -t -e DISPLAY=$DISPLAY -u $USER -v /tmp/.X11-unix:/tmp/.X11-unix --name=\"$CONTAINER_NAME\" $USER/jbds /home/$USER/jbdevstudio/studio/jbdevstudio"
    fi
else
    # no name specified, destroy on shutdown
    CMD="docker run -i -t -e DISPLAY=$DISPLAY -u $USER -v /tmp/.X11-unix:/tmp/.X11-unix --rm $USER/jbds /home/$USER/jbdevstudio/studio/jbdevstudio"
fi

echo "COMMAND: $CMD"
exec $CMD

