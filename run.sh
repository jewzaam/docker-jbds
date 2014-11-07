#!/bin/sh

IMAGE_NAME="$USER/jbds"

if [ "x"$1 != "x" ]; then
    CONTAINER_NAME="keep_${USER}_${1}"

    # have a container name.  is it already running?
    CONTAINER_ID=`docker ps | grep $CONTAINER_NAME | awk '{print $1}'`

    if [ "x"$CONTAINER_ID != "x" ]; then
        # conatiner exists and is running! stop!
        echo "Container is already running!  ID=$CONTAINER_ID, Name=$CONTAINER_NAME"
        exit 1
    fi

    # container isn't running, but does it exist?
    CONTAINER_ID=`docker ps -a | grep $CONTAINER_NAME | awk '{print $1}'`

    if [ "x"$CONTAINER_ID != "x" ]; then
        # container exists (stopped)

        # start the container, don't tag first since it was probably tagged last run (and if not will be tagged if this run has a clean shutdown)
        CMD="${CMD}docker start --attach=true $CONTAINER_NAME;"
    else
        # no container exists, goign to have to start from an image
        IMAGE_TAG=`docker images | grep "^$IMAGE_NAME" | awk '{print $2}' | grep "^${1}$"`

        if [ "x"$IMAGE_TAG != "x" ]; then
            # tag exists, start from the tag
            CMD="${CMD}docker run -i -t -e DISPLAY=$DISPLAY -u $USER -v /tmp/.X11-unix:/tmp/.X11-unix --name=\"$CONTAINER_NAME\" $IMAGE_NAME:$IMAGE_TAG /home/$USER/jbdevstudio/studio/jbdevstudio;"
        else
            # tag doesn't exist yet, start from base image
            CMD="${CMD}docker run -i -t -e DISPLAY=$DISPLAY -u $USER -v /tmp/.X11-unix:/tmp/.X11-unix --name=\"$CONTAINER_NAME\" $IMAGE_NAME /home/$USER/jbdevstudio/studio/jbdevstudio;"
        fi

    fi

    # save container state at end as image tag
    CMD="${CMD}docker commit -a \"$USER\" $CONTAINER_NAME $IMAGE_NAME:$1;"
else
    # no name specified, destroy on shutdown
    CMD="${CMD}docker run -i -t -e DISPLAY=$DISPLAY -u $USER -v /tmp/.X11-unix:/tmp/.X11-unix --rm $IMAGE_NAME /home/$USER/jbdevstudio/studio/jbdevstudio;"
fi

IFS=";"
for x in $CMD;
do
    echo ">>> START: $x"
    eval $x
    echo "<<< DONE"
done

