#!/bin/sh

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

        # this means tagging didn't happen last run
        # recover by tagging and then use that tag for next start
        CMD="${CMD}docker commit -a \"$USER\" $CONTAINER_NAME $USER/jbds:$1;"

        # and then remove the container
        CMD="${CMD}docker rm $CONTAINER_NAME;"
    fi

    IMAGE_TAG=`docker images | grep "^$USER/jbds" | awk '{print $2}' | grep "^${1}$"`

    if [ "x"$IMAGE_TAG != "x" ]; then
        # tag exists, start from the tag
        CMD="${CMD}docker run -i -t -e DISPLAY=$DISPLAY -u $USER -v /tmp/.X11-unix:/tmp/.X11-unix --name=\"$CONTAINER_NAME\" $USER/jbds:$IMAGE_TAG /home/$USER/jbdevstudio/studio/jbdevstudio;"
    else
        # tag doesn't exist yet, start from base image
        CMD="${CMD}docker run -i -t -e DISPLAY=$DISPLAY -u $USER -v /tmp/.X11-unix:/tmp/.X11-unix --name=\"$CONTAINER_NAME\" $USER/jbds /home/$USER/jbdevstudio/studio/jbdevstudio;"
    fi

    CMD="${CMD}docker commit -a \"$USER\" $CONTAINER_NAME $USER/jbds:$1;docker rm $CONTAINER_NAME;"
else
    # no name specified, destroy on shutdown
    CMD="${CMD}docker run -i -t -e DISPLAY=$DISPLAY -u $USER -v /tmp/.X11-unix:/tmp/.X11-unix --rm $USER/jbds /home/$USER/jbdevstudio/studio/jbdevstudio;"
fi

IFS=";"
for x in $CMD;
do
    echo ">>> START: $x"
    eval $x
    echo "<<< DONE"
done

