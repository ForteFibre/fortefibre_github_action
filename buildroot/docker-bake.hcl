group "default" {
    targets = [
        "humble_large",
        "humble_large_cross",
        "humble_small",
        "humble_small_cross",
        "jazzy_small"
    ]
}

target "humble_large" {
    target = "build_stage"
    dockerfile = "Dockerfile.native"
    platforms = ["linux/amd64", "linux/arm64"]
    tags = [
        "ghcr.io/fortefibre/buildroot:humble-large"
    ]
    args = {
        BASE_IMAGE = "docker.io/hakuturu583/cuda_ros:humble-cuda-12.2.0-devel"
        PACKAGE_XML = "package.xml"
    }
}

target "humble_large_cross" {
    target = "build_stage"
    dockerfile = "Dockerfile.cross"
    platforms = ["linux/arm64"]
    tags = [
        "ghcr.io/fortefibre/buildroot:humble-large-cross"
    ]
    args = {
        BASE_IMAGE = "docker.io/hakuturu583/cuda_ros:lt4-humble-cuda-12.2.2-devel"
        PACKAGE_XML = "package.xml"
    }
}

target "humble_small" {
    target = "build_stage"
    dockerfile = "Dockerfile.native"
    platforms = ["linux/amd64", "linux/arm64"]
    tags = [
        "ghcr.io/fortefibre/buildroot:humble-small"
    ]
    args = {
        BASE_IMAGE = "docker.io/library/ros:humble-perception"
        PACKAGE_XML = "package.small.xml"
    }
}

target "humble_small_cross" {
    target = "build_stage"
    dockerfile = "Dockerfile.cross"
    platforms = ["linux/arm64"]
    tags = [
        "ghcr.io/fortefibre/buildroot:humble-small-cross"
    ]
    args = {
        BASE_IMAGE = "docker.io/library/ros:humble-perception"
        PACKAGE_XML = "package.small.xml"
    }
}

target "jazzy_small" {
    target = "build_stage"
    dockerfile = "Dockerfile.native"
    platforms = ["linux/amd64", "linux/arm64"]
    tags = ["ghcr.io/fortefibre/buildroot:jazzy-small"]
    args = {
        BASE_IMAGE = "docker.io/library/ros:jazzy-perception"
        PACKAGE_XML = "package.small.xml"
    }
}

target "jazzy_small_cross" {
    target = "build_stage"
    dockerfile = "Dockerfile.cross"
    platforms = ["linux/arm64"]
    tags = ["ghcr.io/fortefibre/buildroot:jazzy-small-cross"]
    args = {
        BASE_IMAGE = "docker.io/library/ros:jazzy-perception"
        PACKAGE_XML = "package.small.xml"
    }
}