#!/bin/bash

set -e

# TODO: Add apt repository for other packages

source /opt/ros/${ROS_DISTRO}/setup.bash 

WORKSPACE_ROOT=$PWD

# Add local repository to rosdep
colcon list -t -n | awk '{ pkg = $1; gsub("_", "-", pkg); print $1 ":\n  ubuntu: [ros-humble-" pkg "]" }' > rosdep.yaml
cat rosdep.yaml
echo "yaml file:///$PWD/rosdep.yaml" | sudo tee /etc/ros/rosdep/sources.list.d/50-my-packages.list -a

# Expected `rosdep init` has been done in the base image
apt-get update
rosdep update

# Ensure that all dependencies are installed
rosdep install -i --from-paths $WORKSPACE_ROOT/src -y

export DEB_BUILD_OPTIONS="parallel=$(nproc) nocheck"

for PKG_REL_PATH in $(colcon list -t -p); do
    echo "Building $PKG_REL_PATH"
    pushd $WORKSPACE_ROOT/$PKG_REL_PATH
    rm -r .obj-* debian || true
    bloom-generate rosdebian $WORKSPACE_ROOT/$PKG_REL_PATH
    # Fix for some NVIDIA libraries
    sed -i "s%dh_shlibdeps%dh_shlibdeps --dpkg-shlibdeps-params=--ignore-missing-info%" debian/rules
    # Because container is running as root, fakeroot is not needed
    ./debian/rules binary -j
    dpkg -i --force-depends --force-downgrade ../*.deb
    mv ../*.deb /debs
    popd
done