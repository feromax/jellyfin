#!/bin/bash

set -eo pipefail

GIT_TAG=`git describe --tags | head -1`
TAG="jellyfin:${GIT_TAG}-`date +%F`-runas"
if [ ! -z "$1" ]; then
	TAG="$1"
fi

cat <<EOF

==> About to build container image with this tag:  $TAG

EOF
sleep 3

set -x
docker build -t $TAG -f Dockerfile .

##remove build containers
#docker images --format '{{ .Repository }}:{{ .ID }}' | grep "<none>" | cut -f2 -d: | xargs docker rmi -f

