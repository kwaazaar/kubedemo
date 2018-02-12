
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

# Static IP instellen (https://www.howtoforge.com/linux-basics-set-a-static-ip-on-ubuntu)
sudo nano /etc/network/interfaces
#Inhoud:
  iface eth0 inet static
    address 192.168.1.201
    netmask 255.255.255.0
    gateway 192.168.1.254
    dns-nameservers 192.168.1.254 8.8.8.8 8.8.4.4

# Disable SWAP (https://askubuntu.com/questions/912623/how-to-permanently-disable-swap-file)
sudo nano /etc/fstab
# Comment out of verwijder de regel(s) met type=SWAP
sudo reboot

# Docker
# - Source: https://docs.docker.com/install/linux/docker-ce/ubuntu/
# - Remove existing docker installation (if any)
sudo apt remove docker docker-engine docker.io -y
# - Add docker key and repo
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
   $(lsb_release -cs) \
   stable"
# - Install docker
sudo apt update
sudo apt install docker-ce -y
sudo docker run hello-world
# - Niet zeker of dit ook moet
cat << EOF > /etc/docker/daemon.json
{
  "exec-opts": ["native.cgroupdriver=cgroupfs"]
}
EOF
sudo mkdir /etc/systemd/system/docker.service.d/
sudo echo "ExecStartPost=/sbin/iptables -P FORWARD ACCEPT" >> /etc/systemd/system/docker.service.d/exec_start.conf

# kubeadm/kubelet/kubectl
apt install -y apt-transport-https
curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add -
cat <<EOF >/etc/apt/sources.list.d/kubernetes.list
deb http://apt.kubernetes.io/ kubernetes-xenial main
EOF
apt update
apt install -y kubelet kubeadm kubectl

# Master:
# Let op: bereiken via dns/extern-ip: --apiserver-cert-extra-sans=40.68.221.229,kube1.westeurope.cloudapp.azure.com
sudo kubeadm init --pod-network-cidr=10.244.0.0/16 --apiserver-cert-extra-sans=40.68.221.229,kube1.westeurope.cloudapp.azure.com # --apiserver-advertise-address 0.0.0.0


# copy output now!
mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config

# Pod-network: Flannel
sudo kubectl apply -f https://raw.githubusercontent.com/coreos/flannel/v0.9.1/Documentation/kube-flannel.yml

# Pod-network: KubeRouter
KUBECONFIG=/etc/kubernetes/admin.conf kubectl apply -f https://raw.githubusercontent.com/cloudnativelabs/kube-router/master/daemonset/kubeadm-kuberouter-all-features.yaml
KUBECONFIG=/etc/kubernetes/admin.conf kubectl -n kube-system delete ds kube-proxy
docker run --privileged --net=host gcr.io/google_containers/kube-proxy-amd64:v1.7.3 kube-proxy --cleanup-iptables

sudo sysctl net.bridge.bridge-nf-call-iptables=1
sudo iptables -P FORWARD ACCEPT
#optional: sudo reboot

# Validate if kube-dns pod is running:
KUBECONFIG=/etc/kubernetes/admin.conf kubectl get pods --all-namespaces

# Dashboard
sudo kubectl apply -f https://raw.githubusercontent.com/kubernetes/heapster/master/deploy/kube-config/influxdb/influxdb.yaml
sudo kubectl apply -f https://raw.githubusercontent.com/kubernetes/heapster/master/deploy/kube-config/influxdb/grafana.yaml
sudo kubectl apply -f https://raw.githubusercontent.com/kubernetes/heapster/master/deploy/kube-config/influxdb/heapster.yaml
sudo kubectl apply -f https://raw.githubusercontent.com/kubernetes/dashboard/master/src/deploy/recommended/kubernetes-dashboard.yaml

# Nginx ingress controller resources (with RBAC), is er maar 1 nodig per cluster
sudo kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/master/deploy/namespace.yaml
sudo kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/master/deploy/default-backend.yaml
sudo kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/master/deploy/configmap.yaml
sudo kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/master/deploy/tcp-services-configmap.yaml
sudo kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/master/deploy/udp-services-configmap.yaml
sudo kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/master/deploy/rbac.yaml
sudo kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/master/deploy/with-rbac.yaml
sudo kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/master/deploy/provider/baremetal/service-nodeport.yaml


# Nodes:
# -> Join instructies zoals in output

# Beheer vanaf externe machine
# Via serviceaccount:
# - Aanmaken via adminuser.yml
# - Token ophalen (voor inloggen op dashboard): kubectl -n kube-system describe secret $(kubectl -n kube-system get secret | grep admin-user | awk '{print $1}')


# # Admin user: gewoon de conf kopieren
# # Custom user (let op: geen rechten op kube-system namespace ... :-s):
# -> Aanmaken kubectl config file (op master)
sudo kubeadm alpha phase kubeconfig user --client-name kubeadmin > kubeadmin.conf
# -> Rolebinding admin maken en koppelen aan clusterrole admin en user kubeuser daar aan toevoegen
kubectl create rolebinding clusteradmin --clusterrole=cluster-admin --user=kubeadmin

