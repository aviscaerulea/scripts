#!/bin/bash -eu
sudo yum -y install yum-utils
sudo yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
sudo yum-config-manager --enable docker-ce-edge
sudo yum -y install docker-ce
sudo systemctl enable docker
sudo systemctl start docker
sudo gpasswd -a $USER docker

cat <<_EOL_ >> $HOME/.bashrc
alias d="docker"
_EOL_
source $HOME/.bashrc
