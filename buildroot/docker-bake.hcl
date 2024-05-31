group "default" {
  targets = ["amd64", "aarch64", "amd64_small", "aarch64_small"]
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

target "amd64_small" {
    target = "build_stage"
    dockerfile = "Dockerfile.small.amd64"
    platforms = ["linux/amd64"]
    tags = ["ghcr.io/fortefibre/buildroot-small:humble-amd64"]
}

target "aarch64_small" {
    target = "build_stage"
    dockerfile = "Dockerfile.small.arm64"
    platforms = ["linux/arm64"]
    tags = ["ghcr.io/fortefibre/buildroot-small:humble-aarch64"]
}