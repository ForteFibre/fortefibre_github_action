#!/bin/bash

set -e
echo "$INPUT_GPG_PRIVATE_KEY" | gpg --import || true
CODENAME=${INPUT_CODENAME:-jammy}
deb-s3 upload --bucket $INPUT_S3_BUCKET \
    --access-key-id $INPUT_S3_ACCESS_KEY_ID \
    --secret-access-key $INPUT_S3_ACCESS_KEY_SECRET \
    --component main \
    --endpoint $INPUT_S3_ENDPOINT \
    --sign $INPUT_GPG_FINGERPRINT \
    --codename $CODENAME \
    $INPUT_INPUT_DIR/*.deb
