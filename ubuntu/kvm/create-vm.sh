#! /bin/bash

name=$1
if [ -z $name ]; then
	echo "Input name as 1st parameter"
	exit -1
fi

virt-install --name $name --ram=4096 --vcpus=2 --cpu host --hvm --disk path=/var/lib/libvirt/images/$name,size=50 --cdrom /var/lib/libvirt/boot/ubuntu-22.04.3-live-server-amd64.iso --graphics vnc
