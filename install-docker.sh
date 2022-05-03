#!/bin/bash -eu
sudo yum -y install yum-utils
sudo yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
sudo yum -y install docker-ce docker-compose-plugin
sudo ln -sf /usr/libexec/docker/cli-plugins/docker-compose /usr/local/bin/docker-compose
sudo systemctl enable docker
sudo systemctl restart docker
sudo groupadd docker
sudo usermod -aG docker $USER

cat <<_EOL_ >> $HOME/.bashrc
alias d="docker"
_EOL_
source $HOME/.bashrc
