# https://docs.docker.com/install/linux/docker-ce/ubuntu/

sudo apt remove docker docker-engine docker.io -y

curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -

sudo add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
   $(lsb_release -cs) \
   stable"

sudo apt update

sudo apt install docker-ce -y

#verify
sudo docker run hello-world


