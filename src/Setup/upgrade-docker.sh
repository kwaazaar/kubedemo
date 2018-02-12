# Source: https://docs.docker.com/install/linux/docker-ce/ubuntu/

# Remove existing docker installation (if any)
sudo apt remove docker docker-engine docker.io -y

# Add docker key and repo
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
   $(lsb_release -cs) \
   stable"

# Install docker
sudo apt update
sudo apt install docker-ce -y
sudo docker run hello-world
