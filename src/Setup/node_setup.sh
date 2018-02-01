# ssh-server (if not yet installed)
sudo apt install -y openssh-server

# Firewall configuration
sudo ufw allow ssh
# - master nodes:
sudo ufw allow 6443
sudo ufw allow 2379:2380/tcp
sudo ufw allow 10250:10255/tcp
sudo ufw enable
# - agent nodes:
sudo ufw allow 10250
sudo ufw allow 10255
sudo ufw allow 30000:32767/tcp
sudo ufw enable

# Docker
sudo apt install -y docker.io
cat << EOF > /etc/docker/daemon.json
{
  "exec-opts": ["native.cgroupdriver=cgroupfs"]
}
EOF

# kubeadm/kubelet/kubectl
apt install -y apt-transport-https
curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add -
cat <<EOF >/etc/apt/sources.list.d/kubernetes.list
deb http://apt.kubernetes.io/ kubernetes-xenial main
EOF
apt update
apt install -y kubelet kubeadm kubectl

# Master:
sudo kubeadm init --pod-network-cidr=10.244.0.0/16 --apiserver-advertise-address 0.0.0.0 --apiserver-cert-extra-sans master.kubedemo
# copy output now!
mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config
KUBECONFIG=/etc/kubernetes/admin.conf kubectl apply -f https://raw.githubusercontent.com/cloudnativelabs/kube-router/master/daemonset/kubeadm-kuberouter-all-features.yaml
KUBECONFIG=/etc/kubernetes/admin.conf kubectl -n kube-system delete ds kube-proxy
docker run --privileged --net=host gcr.io/google_containers/kube-proxy-amd64:v1.7.3 kube-proxy --cleanup-iptables
sudo sysctl net.bridge.bridge-nf-call-iptables=1
# Validate if kube-dns pod is running:
KUBECONFIG=/etc/kubernetes/admin.conf kubectl get pods --all-namespaces
