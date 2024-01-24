#! /bin/bash

mkdir -p device

pushd device >/dev/null

dd if=/dev/zero of=block-device.img bs=1G count=20
losetup -f block-device.img

popd >/dev/null

dev=$(losetup -l | grep block-device.img | awk '{print $1}')
mkfs.ext4 ${dev}

echo "block dev $dev"
