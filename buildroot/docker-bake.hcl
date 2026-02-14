group "default" {
    targets = [
        "jazzy-small-amd64",
        "jazzy-small-arm64"
    ]
}

target "jazzy-small-amd64" {
    target = "build_stage"
    dockerfile = "Dockerfile"
    platforms = ["linux/amd64"]
    args = {
        BASE_IMAGE = "docker.io/osrf/ros:jazzy-simulation"
        PACKAGE_XML = "package.small.xml"
    }
}

target "jazzy-small-arm64" {
    target = "build_stage"
    dockerfile = "Dockerfile"
    platforms = ["linux/arm64"]
    args = {
        BASE_IMAGE = "docker.io/library/ros:jazzy-perception"
        PACKAGE_XML = "package.small.xml"
    }
}
