#!/bin/bash

set -xe

#should be supplied as injected env var at container start
PUID=${PUID:-0} #not overriden?  user will be root
PGID=${PGID:-0} #                group will be root

if [ $PUID -ne 0 ]; then
	echo "Adding new user."
	id -g $PGID || groupadd -g $PGID jellyfin 
	id $PUID || useradd -u $PUID -g $PGID jellyfin 
	chown -R $PUID:$PGID /jellyfin 
fi

RUN_AS=$(id $PUID | cut -f1 -d' ' | sed -e 's/^.\+(\(.*\))/\1/')
echo "Will be running jellyfin as user $RUN_AS, with UID=$PUID and GID=$PGID."

su $RUN_AS -c /bin/bash -c '\
  /jellyfin/jellyfin \
  --datadir /config \
  --cachedir /config/cache \
  --ffmpeg  /usr/lib/jellyfin-ffmpeg/ffmpeg \
'


