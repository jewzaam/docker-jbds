#!/bin/sh

# generate dockerfile with the user
(cat Dockerfile-base ;
echo "RUN adduser $USER" ;
echo "RUN chown -R $USER:$USER /home/nmalik" ;
) > Dockerfile

# run the build (not using - because it doesn't set context)
docker build -t $USER/jbds .
