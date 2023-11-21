#! /bin/bash

# uninstall containerd
echo "Uninstalling containerd"
systemctl stop containerd && rm /etc/systemd/system/containerd.service
rm -rf /etc/containerd /var/lib/containerd /run/containerd /var/run/containerd
pushd /usr/bin > /dev/null
rm containerd  containerd-shim  containerd-shim-runc-v1  containerd-shim-runc-v2  containerd-stress  ctr
popd > /dev/nul


# uninstall runc
echo "Uninstall runc"
rm /usr/bin/runc

# uninstall network plugins
echo "Uninstall network plugins"
rm -rf /opt/cni/bin

# uninstall nerdctl
echo "Uninstall nercctl"
rm /usr/bin/nerdctl

# uninstall crictl
echo "Uninstall crictl"
rm /usr/bin/crictl /etc/crictl.yaml

# uninstall k8s
#kubeadm reset
#rm -rf /etc/apt/keyrings/kubernetes-apt-keyring.gpg /etc/apt/sources.list.d/kubernetes.list

