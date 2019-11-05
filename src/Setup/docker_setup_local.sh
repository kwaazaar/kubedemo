
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
# - Install docker (https://docs.docker.com/install/linux/docker-ce/ubuntu/)
#  !Max validated version: 17.03
sudo apt update
sudo apt install docker-ce=17.03.2~ce-0~ubuntu-xenial -y
# - Niet zeker of dit ook moet
cat << EOF > /etc/docker/daemon.json
{
  "exec-opts": ["native.cgroupdriver=cgroupfs"]
}
EOF
sudo docker run hello-world

# docker-compose
# See: https://docs.docker.com/compose/install/#install-compose
sudo curl -L https://github.com/docker/compose/releases/download/1.21.2/docker-compose-$(uname -s)-$(uname -m) -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose