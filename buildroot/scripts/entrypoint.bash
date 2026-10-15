#!/bin/bash

set -e

if [ -z "$ROS_DISTRO" ]; then
    echo "ROS_DISTRO is not set. Please set it to the desired ROS distribution (e.g., foxy, galactic, etc.)"
    exit 1
fi

source /opt/ros/${ROS_DISTRO}/setup.bash

# create_debian_packages action が OIDC で得た apt.fortefibre.net の資格情報を
# mount していれば、apt と rosdep に設定する。pre_script と違い、失敗したらここで止める
if [ -x /run/fortefibre-apt/setup.sh ]; then
    /run/fortefibre-apt/setup.sh
fi

# Create deb or colcon build
if [ "$1" = 'deb' ]; then
    if [ -n "$INPUT_PRE_SCRIPT" ]; then
        bash -c "$INPUT_PRE_SCRIPT" || true
    fi
    bash /scripts/debian.bash
elif [ "$1" = 'colcon' ]; then
    colcon "$@" && RET=$? || RET=$?
    chown -R $ORIG_UID:$ORIG_GID $PWD/install $PWD/build $PWD/log || true
    exit $RET
else
    bash --login
fi
