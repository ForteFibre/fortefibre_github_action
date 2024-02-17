group "default" {
  targets = ["amd64", "aarch64"]
}


target "amd64" {
    target = "build_stage"
    dockerfile = "Dockerfile.amd64"
    platforms = ["linux/amd64"]
    tags = ["ghcr.io/fortefibre/buildroot:humble-amd64"]
}

target "aarch64" {
    target = "build_stage"
    dockerfile = "Dockerfile.arm64"
    platforms = ["linux/arm64"]
    tags = ["ghcr.io/fortefibre/buildroot:humble-aarch64"]
}