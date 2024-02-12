#!/bin/bash

pushd .
apt update && apt upgrade -y 
apt install -y python3-bloom fakeroot debhelper git gpg dh-python

bash /opt/ros/${ROS_DISTRO}/setup.bash 
rosdep update 
rosdep install -i --from-paths . -y 

IFS=$'\n'
PKG_LIST=$(colcon list -t)
if [ -f ./my_rosdep.yaml ]; then
    rm ./my_rosdep.yaml
fi

for ITEM in $PKG_LIST; do
    PKG_NAME=$(echo $ITEM | awk '{ print $1 }')
    PKG_PATH=$(echo $ITEM | awk '{ print $2 }')
    DEB_NAME=$(echo $PKG_NAME | sed -e 's/_/-/g' | sed -e 's/\(.*\)/\L\1/' | sed -e "s/^/ros-${ROS_DISTRO}-/g")
    echo "$PKG_NAME:" >> ./my_rosdep.yaml
    echo "  ubuntu: [$DEB_NAME]" >> ./my_rosdep.yaml
done

echo "yaml file://$(pwd)/my_rosdep.yaml" | sudo tee /etc/ros/rosdep/sources.list.d/50-my-packages.list -a
rosdep update

for ITEM in $PKG_LIST; do
    PKG_NAME=$(echo $ITEM | awk '{ print $1 }')
    PKG_PATH=$(echo $ITEM | awk '{ print $2 }')
    DEB_NAME=$(echo $PKG_NAME | sed -e 's/_/-/g' | sed -e 's/\(.*\)/\L\1/' | sed -e "s/^/ros-${ROS_DISTRO}-/g")

    pushd $PKG_PATH
    bloom-generate rosdebian
    fakeroot debian/rules binary
    apt install -y ../$DEB_NAME*.deb
    mv ../$DEB_NAME*.deb /debs
    popd
done