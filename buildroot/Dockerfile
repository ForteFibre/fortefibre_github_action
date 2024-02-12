ARG ROS_DISTRO=humble

FROM ros:${ROS_DISTRO}

ENV DEBIAN_FRONTEND=noninteractive

# Install bloom packages
RUN apt-get update && apt-get install -y python3-bloom fakeroot \
    debhelper git gpg dh-python reprepro