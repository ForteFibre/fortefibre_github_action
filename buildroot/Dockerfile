ARG BASE_IMAGE=nvcr.io/nvidia/cuda:12.6.0-cudnn-devel-ubuntu24.04

FROM ${BASE_IMAGE}

ARG ROS_DISTRO=jazzy

ENV DEBIAN_FRONTEND=noninteractive
ENV ROS_DISTRO=${ROS_DISTRO}

# install packages
RUN --mount=type=cache,target=/var/lib/apt,sharing=private \
    apt-get update && apt-get install -q -y --no-install-recommends \
    ca-certificates \
    curl \
    dirmngr \
    gnupg2 \
    && rm -rf /var/lib/apt/lists/*

# Setup ROS Apt sources
RUN --mount=type=cache,target=/var/lib/apt,sharing=private \
    curl -L -s -o /tmp/ros2-apt-source.deb https://github.com/ros-infrastructure/ros-apt-source/releases/download/1.1.0/ros2-apt-source_1.1.0.noble_all.deb \
    && echo "35441f3092fd05773a3c397fab38661bec466584c7a1f1c05366579997cb5fe7 /tmp/ros2-apt-source.deb" | sha256sum --strict --check \
    && apt-get update \
    && apt-get install /tmp/ros2-apt-source.deb \
    && rm -f /tmp/ros2-apt-source.deb \
    && rm -rf /var/lib/apt/lists/*

# setup environment
ENV LANG=C.UTF-8
ENV LC_ALL=C.UTF-8

# install ros2 packages
RUN --mount=type=cache,target=/var/lib/apt,sharing=private \
    apt-get update && apt-get install -y --no-install-recommends \
    ros-${ROS_DISTRO}-ros-core \
    && rm -rf /var/lib/apt/lists/*

RUN --mount=type=cache,target=/var/lib/apt,sharing=private apt-get update \
    && apt-get install -y \
    python3-vcstool git python3-colcon-common-extensions python3-colcon-mixin python3-rosdep \
    python3-bloom python3-pip fakeroot \
    debhelper git gpg dh-python unzip gcovr \
    && if [ ! -f /etc/ros/rosdep/sources.list.d/20-default.list ]; then rosdep init; fi \
    && rm -rf /var/lib/apt/lists/*

RUN --mount=type=bind,source=.,target=/ws \
    --mount=type=cache,target=/var/lib/apt,sharing=private \
    apt-get update \
    && echo "yaml file:///ws/rosdep.yaml" > /etc/ros/rosdep/sources.list.d/61-customized-rosdep.list \
    && rosdep update \
    && rosdep install --from-paths /ws --ignore-src --rosdistro ${ROS_DISTRO} -y \
    && rm -rf /var/lib/apt/lists/* \
    && rm /etc/ros/rosdep/sources.list.d/61-customized-rosdep.list

COPY scripts/ /scripts/
RUN chmod +x /scripts/entrypoint.bash

ENTRYPOINT [ "/scripts/entrypoint.bash" ]
