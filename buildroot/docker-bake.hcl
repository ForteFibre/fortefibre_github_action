group "default" {
  targets = ["amd64", "aarch64", "amd64_small_humble", "aarch64_small_humble",
    "amd64_small_jazzy", "aarch64_small_jazzy"]
}


target "amd64" {
    target = "build_stage"
    dockerfile = "Dockerfile.amd64"
    platforms = ["linux/amd64"]
    tags = ["ghcr.io/fortefibre/buildroot:humble-amd64"]
    args = {
        BASE_IMAGE = "docker.io/hakuturu583/cuda_ros:humble-cuda-12.2.0-devel"
    }
}

target "aarch64" {
    target = "build_stage"
    dockerfile = "Dockerfile.arm64"
    platforms = ["linux/arm64"]
    tags = ["ghcr.io/fortefibre/buildroot:humble-aarch64"]
    args = {
        BASE_IMAGE = "docker.io/hakuturu583/cuda_ros:lt4-humble-cuda-12.2.2-devel"
    }
}

target "amd64_small_humble" {
    target = "build_stage"
    dockerfile = "Dockerfile.small.amd64"
    platforms = ["linux/amd64"]
    tags = ["ghcr.io/fortefibre/buildroot-small:humble-amd64"]
    args = {
        ROS_DISTRO = "humble"
    }
}

target "aarch64_small_humble" {
    target = "build_stage"
    dockerfile = "Dockerfile.small.arm64"
    platforms = ["linux/arm64"]
    tags = ["ghcr.io/fortefibre/buildroot-small:humble-aarch64"]
    args = {
        ROS_DISTRO = "humble"
    }
}

target "amd64_small_jazzy" {
    target = "build_stage"
    dockerfile = "Dockerfile.small.amd64"
    platforms = ["linux/amd64"]
    tags = ["ghcr.io/fortefibre/buildroot-small:jazzy-amd64"]
    args = {
        ROS_DISTRO = "jazzy"
    }
}

target "aarch64_small_jazzy" {
    target = "build_stage"
    dockerfile = "Dockerfile.small.arm64"
    platforms = ["linux/arm64"]
    tags = ["ghcr.io/fortefibre/buildroot-small:jazzy-aarch64"]
    args = {
        ROS_DISTRO = "jazzy"
    }
}