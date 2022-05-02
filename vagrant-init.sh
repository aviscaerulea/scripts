#!/bin/bash -u
readonly KEY_FILE="/home/vagrant/.ssh/authorized_keys"
install -o vagrant -g vagrant -m 0700 -d $(dirname $KEY_FILE)
install -o vagrant -g vagrant -m 0600 /dev/null $KEY_FILE
curl https://raw.githubusercontent.com/mitchellh/vagrant/master/keys/vagrant.pub -o $KEY_FILE

sed -re 's/^(GRUB_TIMEOUT)=.+/\1=0/' -i".bkup" /etc/default/grub
diff -U0 /etc/default/grub{.bkup,}

setenforce 0
sed -re 's/^(SELINUX)=.+/\1=disabled/' -i".bkup" /etc/selinux/config
diff -U0 /etc/selinux/config{.bkup,}

sed -re 's/^#?(UseDNS) .+/\1 no/' \
    -re 's/^#?(GSSAPIAuthentication) .+/\1 no/' \
    -i".bkup" /etc/ssh/sshd_config
diff -U0 /etc/ssh/sshd_config{.bkup,}

tee /etc/sudoers.d/vagrant <<EOL > /dev/null
Defaults:vagrant !requiretty
vagrant ALL=(ALL) NOPASSWD:ALL
EOL

tee /etc/sudoers.d/root <<EOL > /dev/null
Defaults:root !requiretty
EOL
sudo chmod 0640 /etc/sudoers.d/*
