#! /bin/bash

# install dependencies
# ubuntu 22.04 new feature. Update automatically.
echo "Installing basic os dependencies"
sed -i "/#\$nrconf{restart} = 'i';/s/.*/\$nrconf{restart} = 'a';/" /etc/needrestart/needrestart.conf
apt update && apt install -y iptables apt-transport-https ca-certificates curl gpg

pushd /tmp > /dev/null

# install containerd
echo "Installing containerd"
curl -SLf https://github.com/containerd/containerd/releases/download/v1.7.2/containerd-1.7.2-linux-amd64.tar.gz -o containerd.tar.gz 
tar -zxf containerd.tar.gz && mv bin/* /usr/bin/ && rm -r bin containerd.tar.gz

# install runc
echo "Installing runc"
curl -L -Sf https://github.com/opencontainers/runc/releases/download/v1.1.7/runc.amd64 -o runc && chmod +x runc && mv runc /usr/bin/

# install network plugins
echo "Installing network plugins"
curl -L -Sf https://github.com/containernetworking/plugins/releases/download/v1.3.0/cni-plugins-linux-amd64-v1.3.0.tgz -o cni.tgz
mkdir -p /opt/cni/bin && tar Cxzvf /opt/cni/bin cni.tgz && rm cni.tgz

popd > /dev/null

# make systemd unit for containerd
echo "Generating containerd config.toml"
mkdir /etc/containerd && containerd config default > /etc/containerd/config.toml
pushd /etc/containerd > /dev/null
sed -i 's/SystemdCgroup = false/SystemdCgroup = true/' config.toml
sed -i '/systemd_cgroup = false/d' config.toml
sed -i '/  \[plugins."io.containerd.runtime.v1.linux"\]/a\    systemd_cgroup = true' config.toml
sed -i 's#registry.k8s.io/pause:3.8#registry.k8s.io/pause:3.9#' config.toml
popd > /dev/null

echo "Generating containerd unit"
cat << 'EOF' > /etc/systemd/system/containerd.service
> [Unit]
Description=containerd container runtime
Documentation=https://containerd.io
After=network.target local-fs.target

[Service]
ExecStartPre=-/sbin/modprobe overlay
ExecStart=containerd
Delegate=yes
KillMode=process
Restart=always
RestartSec=5

# Having non-zero Limit*s causes performance problems due to accounting overhead
# in the kernel. We recommend using cgroups to do container-local accounting.
LimitNPROC=infinity
LimitCORE=infinity

# Comment TasksMax if your systemd version does not supports it.
# Only systemd 226 and above support this version.
TasksMax=infinity
OOMScoreAdjust=-999

[Install]
WantedBy=multi-user.target
EOF

# start containerd
systemctl daemon-reload
systemctl enable containerd && systemctl start containerd

pushd /tmp > /dev/null

# install nerdctl
echo "Installing nerdctl"
curl -L -Sf https://github.com/containerd/nerdctl/releases/download/v1.5.0/nerdctl-1.5.0-linux-amd64.tar.gz -o nerdctl.tgz
mkdir nerdctl && tar -zxf nerdctl.tgz -C nerdctl && mv nerdctl/nerdctl /usr/bin && rm -rf nerdctl nerdctl.tgz

# install crictl
echo "Installing crictl"
curl -L -o crictl.tgz -Sf https://github.com/kubernetes-sigs/cri-tools/releases/download/v1.28.0/crictl-v1.28.0-linux-amd64.tar.gz
tar -zxf crictl.tgz && mv crictl /usr/bin && rm crictl.tgz
cat <<EOF > /etc/crictl.yaml
runtime-endpoint: "unix:///var/run/containerd/containerd.sock"
image-endpoint: ""
timeout: 10
debug: false
pull-image-on-create: false
disable-pull-on-run: false
EOF

popd > /dev/null

# open bridge module
echo "Opening bridge module"
cat <<EOF | sudo tee /etc/modules-load.d/k8s.conf
br_netfilter
EOF
modprobe -v br_netfilter
cat <<EOF >  /etc/sysctl.d/k8s.conf
net.bridge.bridge-nf-call-ip6tables = 1
net.bridge.bridge-nf-call-iptables = 1
net.ipv4.conf.all.forwarding=1
EOF
sysctl --system

# close swap for kublet
echo "Closing swap"
swapoff -a && sysctl -w vm.swappiness=0
sed -i 's/.*swap.*/#&/' /etc/fstab

# install kubeadm kubelet (NODE not MASTER)
echo "Installing kubeadm kubelet"
curl -fsSL https://pkgs.k8s.io/core:/stable:/v1.28/deb/Release.key | sudo gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg
echo 'deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v1.28/deb/ /' | sudo tee /etc/apt/sources.list.d/kubernetes.list
apt update && apt install -y kubelet kubeadm

# join cluster
# SHOW JOIN COMMAND in master node:kubeadm token create --print-join-command
"Please join cluster by 'kubeadm token create --print-join-command' from master"
