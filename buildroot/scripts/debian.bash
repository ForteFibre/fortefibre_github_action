#!/bin/bash

set -e

# TODO: Add apt repository for other packages

source /opt/ros/${ROS_DISTRO}/setup.bash 

WORKSPACE_ROOT=$PWD
EXPORT_DIR=${INPUT_OUT_DIR:-./debs}

mkdir -p $EXPORT_DIR

EXPORT_DIR=$(cd $EXPORT_DIR && pwd)/

# Add local repository to rosdep
colcon --log-base /dev/null list -t -n | awk '{ pkg = $1; gsub("_", "-", pkg); print $1 ":\n  ubuntu: [ros-humble-" pkg "]" }' > /tmp/rosdep.yaml
cat /tmp/rosdep.yaml
echo "yaml file:///tmp/rosdep.yaml" | sudo tee /etc/ros/rosdep/sources.list.d/50-my-packages.list -a

if [ -d /mimic-cross ]; then
    cp -r /etc/apt/auth.conf.d/. /mimic-cross/etc/apt/auth.conf.d/ || true
    cp -r /etc/apt/keyrings/. /mimic-cross/etc/apt/keyrings/ || true
fi

# Expected `rosdep init` has been done in the base image
apt-get update
rosdep update

# Ensure that all dependencies are installed
rosdep install -i --from-paths $WORKSPACE_ROOT -y

export DEB_BUILD_OPTIONS="parallel=$(nproc) nocheck"

rm -r ../*.deb || true

for PKG_REL_PATH in $(colcon --log-base /dev/null list -t -p); do
    echo "Building $PKG_REL_PATH"
    pushd $WORKSPACE_ROOT/$PKG_REL_PATH
    rm -r .obj-* debian || true
    bloom-generate rosdebian $WORKSPACE_ROOT/$PKG_REL_PATH
    # Support concurrency
    sed -i "s%dh_auto_build%dh_auto_build --parallel%" debian/rules
    # Fix for some NVIDIA libraries
    sed -i "s%dh_shlibdeps%dh_shlibdeps --dpkg-shlibdeps-params=--ignore-missing-info%" debian/rules
    # :thinking: This is a workaround for a bug in the build system
    # ref: https://wiki.debian.org/Python/Pybuild
    sed -i "s%dh \$@ -v --buildsystem=pybuild%NO_PROXY="deno.land" dh \$@ -v --buildsystem=pybuild%" debian/rules
    # Because container is running as root, fakeroot is not needed
    ./debian/rules binary
    dpkg -i --force-depends --force-downgrade ../*.deb
    mv ../*.deb $EXPORT_DIR
    rm -r .obj-* debian ../*.ddeb || true
    popd
done

chmod -R a+w $EXPORT_DIR