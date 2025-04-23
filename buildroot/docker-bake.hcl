group "default" {
    targets = [
        "jazzy_small"
    ]
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
