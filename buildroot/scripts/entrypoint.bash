#!/bin/bash

set -e

if [ -z "$ROS_DISTRO" ]; then
    echo "ROS_DISTRO is not set. Please set it to the desired ROS distribution (e.g., foxy, galactic, etc.)"
    exit 1
fi

source /opt/ros/${ROS_DISTRO}/setup.bash

# Create deb or colcon build
if [ "$1" = 'deb' ]; then
    bash /scripts/debian.bash
elif [ "$1" = 'bash' ]; then
    bash
else
    colcon "$@" && RET=$? || RET=$?
    chown -R $ORIG_UID:$ORIG_GID $PWD/install $PWD/build $PWD/log || true
    exit $RET
fi
