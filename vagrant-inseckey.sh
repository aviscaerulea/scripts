#!/bin/bash -u
readonly KEY_FILE="/home/vagrant/.ssh/authorized_keys"
install -o vagrant -g vagrant -m 0700 -d $(dirname $KEY_FILE)
curl https://raw.githubusercontent.com/mitchellh/vagrant/master/keys/vagrant.pub -o $KEY_FILE
chown vagrant:vagrant $KEY_FILE
chmod 0600 $KEY_FILE
