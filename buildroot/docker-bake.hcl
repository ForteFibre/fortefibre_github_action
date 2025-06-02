group "default" {
    targets = [
        "humble-small",
        "jazzy-small",
        "jazzy-small-arm"
    ]
}

target "humble-small" {
    target = "build_stage"
    dockerfile = "Dockerfile.native"
    platforms = ["linux/amd64"]
    tags = ["ghcr.io/fortefibre/buildroot:humble-small"]
    args = {
        BASE_IMAGE = "docker.io/library/ros:humble-perception"
        PACKAGE_XML = "package.small.xml"
    }
}

target "jazzy-small" {
    target = "build_stage"
    dockerfile = "Dockerfile.native"
    platforms = ["linux/amd64"]
    tags = ["ghcr.io/fortefibre/buildroot:jazzy-small"]
    args = {
        BASE_IMAGE = "docker.io/library/ros:jazzy-perception"
        PACKAGE_XML = "package.small.xml"
    }
}

target "jazzy-small-arm" {
    target = "build_stage"
    dockerfile = "Dockerfile.native"
    platforms = ["linux/arm64"]
    tags = ["ghcr.io/fortefibre/buildroot:jazzy-small-arm"]
    args = {
        BASE_IMAGE = "docker.io/library/ros:jazzy-perception"
        PACKAGE_XML = "package.small.xml"
    }
}