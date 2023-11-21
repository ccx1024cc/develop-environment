# Install runtime manually

## Topology

K8s -- kubelet -------\             /-- nydus snapshotter -- nydusd
                       \           /
nerdctl/ctr/crictl ---- containerd ---- runc
                       /
docker -- dockerd ----/

## Containerd

```shell
    pushd /tmp

    # download binaries
    wget https://github.com/containerd/containerd/releases/download/v1.7.2/containerd-1.7.2-linux-amd64.tar.gz
    wget https://github.com/opencontainers/runc/releases/download/v1.1.7/runc.amd64
    wget https://github.com/containernetworking/plugins/releases/download/v1.3.0/cni-plugins-linux-amd64-v1.3.0.tgz
    mkdir -p /opt/cni/bin
    tar Cxzvf /opt/cni/bin cni-plugins-linux-amd64-v1.3.0.tgz

    # touch configuration
    containerd config default > runtime/containerd-1.7.2.linux-amd64/config/config.toml
    sed 's/systemd_cgroup = false/systemd_cgroup = true/' runtime/containerd-1.7.2.linux-amd64/config/config.toml
    sed 's/SystemdCgroup = false/SystemdCgroup = true/' runtime/containerd-1.7.2.linux-amd64/config/config.toml
    sed 's/registry.k8s.io/pause:3.8/registry.k8s.io/pause:3.9/' runtime/containerd-1.7.2.linux-amd64/config/config.toml

    # touch systemd unit
    cat << 'EOF' > /etc/systemd/system/containerd.service
        [Unit]
        Description=containerd container runtime
        Documentation=https://containerd.io
        After=network.target local-fs.target

        [Service]
        Environment="PATH=/home/morgan/runtime/containerd-1.7.2.linux-amd64/bin:/home/morgan/runtime/runc-1.1.7.linux-amd64:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/snap/bin"
        ExecStartPre=-/sbin/modprobe overlay
        ExecStart=/home/morgan/runtime/containerd-1.7.2.linux-amd64/bin/containerd --config /home/morgan/runtime/containerd-1.7.2.linux-amd64/config/config.toml

        Type=notify
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

    # reload && start daemon
    systemctl daemon-reload
    systemctl start containerd

    popd

```

## Ctr

```shell
    ctr images pull docker.io/library/redis:alpine
    ctr run docker.io/library/redis:alpine redis

```

## Nerdctl

```shell
    pushd /tmp

    wget https://github.com/containerd/nerdctl/releases/download/v1.5.0/nerdctl-1.5.0-linux-amd64.tar.gz
    sudo nerdctl run -d --name nginx -p 80:80 nginx:alpine

    popd
```

## Crictl

```shell
    pushd /tmp

    # Download binaries
    wget https://github.com/kubernetes-sigs/cri-tools/releases/download/v1.28.0/crictl-v1.28.0-linux-amd64.tar.gz
    cat << 'EOF' >/etc/crictl.yaml
        runtime-endpoint: "unix:///var/run/containerd/containerd.sock"
        image-endpoint: ""
        timeout: 10
        debug: false
        pull-image-on-create: false
        disable-pull-on-run: false
    EOF

    # Run pod sandbox with config file
    cat << 'EOF' >pod-config.json
        {
            "metadata": {
                "name": "nginx-sandbox",
                "namespace": "default",
                "attempt": 1,
                "uid": "hdishd83djaidwnduwk28bcsb"
            },
            "log_directory": "/tmp",
            "linux": {
            }
        }
    EOF
    crictl runp pod-config.json
    crictl pods
    crictl rmp XXXX

    # Pull image
    crictl pull busybox
    crictl images

    # Create container in pod sanbox
    cat << 'EOF' > container-config.json
        {
              "metadata": {
                  "name": "busybox"
              },
              "image":{
                  "image": "busybox"
              },
              "command": [
                  "top"
              ],
              "log_path":"busybox.0.log",
              "linux": {
          }
    EOF
    crictl create container-config.json pod-config.json
    crictl ps -a
    crictl start XXX
    crictl ps
    crictl exec -i -t XXX
    crictl rmp XXX
```

## Docker

```shell
    # Download binaries
    wget https://download.docker.com/linux/static/stable/x86_64/docker-24.0.7.tgz

    # Touch systemd unit
    cat << 'EOF' > /etc/systemd/system/docker.service
        [Unit]
        Description=Docker Application Container Engine
        Documentation=https://docs.docker.com
        After=network-online.target
        Wants=network-online.target

        [Service]
        Environment="PATH=/home/morgan/runtime/docker-24.0.7.linux-amd64/bin:/home/morgan/runtime/runc-1.1.7.linux-amd64:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/snap/bin"
        ExecStart=/home/morgan/runtime/docker-24.0.7.linux-amd64/bin/dockerd --containerd /run/containerd/containerd.sock -H unix:///home/morgan/runtime/docker-24.0.7.linux-amd64/docker.sock --data-root /home/morgan/runtime/docker-24.0.7.linux-amd64/data --exec-root /home/morgan/runtime/docker-24.0.7.linux-amd64/workdir
        ExecReload=/bin/kill -s HUP $MAINPID

        Type=notify
        Delegate=yes
        KillMode=process
        Restart=on-failure
        StartLimitBurst=3
        StartLimitInterval=60s

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
    systemctl daemon-reload
    systemctl start docker

    # Run images
    docker -H unix:///home/morgan/runtime/docker-24.0.7.linux-amd64/docker.sock run -it --name test --rm busybox sh

```

## Nydus snapshotter

TODO

## K8s

```shell
    # Install kubectl kubeadm kubelet
    sudo apt-get update
    sudo apt-get install -y apt-transport-https ca-certificates curl gpg
    curl -fsSL https://pkgs.k8s.io/core:/stable:/v1.28/deb/Release.key | sudo gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg
    echo 'deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v1.28/deb/ /' | sudo tee /etc/apt/sources.list.d/kubernetes.list
    sudo apt-get update
    sudo apt-get install -y kubelet kubeadm kubectl
    sudo swapoff -a
    sudo kubeadm init

    # Do as prompt from 'kubeadm init'

    # If fails
    sudo kubeadm reset
```
