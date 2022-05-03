#!/bin/bash -eu
sudo yum -y install yum-utils
sudo yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
sudo yum -y install docker-ce
sudo systemctl enable docker
sudo systemctl start docker

cat <<_EOL_ >> $HOME/.bashrc
alias d="sudo docker"
_EOL_
source $HOME/.bashrc
