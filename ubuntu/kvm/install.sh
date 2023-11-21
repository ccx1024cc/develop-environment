#! /bin/bash

apt update && apt install qemu-kvm libvirt-daemon-system libvirt-clients bridge-utils virtinst
systemctl enable libvirtd && systemctl start libvirtd
