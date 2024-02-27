#! /bin/bash

name=$1
if [ -z "$name" ]; then
	echo "Input name as 1st parameter" >&2
	exit 1
fi

# create vm with interactive install process
# virt-install --name $name --memory=4096 --vcpus=2 --cpu host --hvm --disk path=/var/lib/libvirt/images/$name,size=50 --cdrom /var/lib/libvirt/boot/ubuntu-22.04.3-live-server-amd64.iso --graphics vnc

# create vm with auto install process
genisoimage -output nocloud.iso -volid cidata -joliet -rock autoinstall
virt-install \
    --name $name \
    --description $name \
    --os-type Linux --os-variant ubuntu22.04 \
    --memory 2048 \
    --vcpus 2 \
    --disk path=/var/lib/libvirt/images/$name.qcow2,bus=virtio,size=50 \
    --disk path=./nocloud.iso,format=raw,cache=none \
    --network bridge:virbr0 \
    --location /var/lib/libvirt/boot/ubuntu-22.04.3-live-server-amd64.iso,kernel=casper/vmlinuz,initrd=casper/initrd \
    --extra-args 'console=ttyS0,115200n8 serial autoinstall' \
    --graphics none \
    --noreboot 
