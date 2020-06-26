#!/bin/bash

#IMAGE="jellyfin/jellyfin:10.5.5"
IMAGE="jellyfin:v10.5.5-2020-06-25-runas"

# adjust these values to match UID/GID of owner of media files
RUNAS_UID=1001
RUNAS_GID=1001

# adjust these to match where you want your Jellyfin configuration
# and media files mounted from your Docker host
LOCAL_CONFIG_DIR="/home/jellyfin/config"
LOCAL_MEDIA_DIR="/home/jellyfin/movies"
CONTAINER_MEDIA_DIR="/media/`basename $LOCAL_MEDIA_DIR`" #e.g., /media/movies


# set DEBUG to 1 in order to have a quiet container
# to exec into and troubleshoot/develop
DEBUG=0

DEBUG_ENTRYPOINT=""
DEBUG_COMMAND=""
if [ $DEBUG -ne 0 ]; then
	DEBUG_ENTRYPOINT="--entrypoint="
	DEBUG_COMMAND="sleep infinity"
fi

docker stop jellyfin
docker rm jellyfin 

# note:  running on docker host network for DLNA support
set -x
docker run -d \
  --name=jellyfin \
  -e PUID=${RUNAS_UID} \
  -e PGID=${RUNAS_GID} \
  -v ${LOCAL_CONFIG_DIR}:/config \
  -v ${LOCAL_MEDIA_DIR}:${CONTAINER_MEDIA_DIR} \
  --net host \
  --restart unless-stopped \
  $DEBUG_ENTRYPOINT $IMAGE $DEBUG_COMMAND

