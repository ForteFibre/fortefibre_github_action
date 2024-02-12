#!/bin/bash

pushd .
apt update && apt upgrade -y 
apt install -y python3-bloom fakeroot debhelper git gpg dh-python

pushd /
git config --global url."https://x-access-token:$1@github.com/".insteadOf "https://github.com/"
git clone https://github.com/ForteFibre/fortefibre_apt_repository.git
gpg --dearmor -o /etc/apt/keyrings/fortefibre-key.gpg /fortefibre_apt_repository/public/public-key
echo "deb [signed-by=/etc/apt/keyrings/fortefibre-key.gpg] file:///fortefibre_apt_repository/public jammy main " > /etc/apt/sources.list.d/fortefibre.list
echo "yaml file:///fortefibre_apt_repository/public/rosdep/${ROS_DISTRO}_pkg.yaml" | sudo tee /etc/ros/rosdep/sources.list.d/50-my-packages.list
apt update
popd

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
    fakeroot debian/rules binary -j4
    apt install -y ../$DEB_NAME*.deb
    mv ../$DEB_NAME*.deb /debs
    popd
done