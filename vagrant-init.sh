#!/bin/bash -eux
readonly KEY_FILE="/home/vagrant/.ssh/authorized_keys"
useradd -m -G wheel -p vagrant vagrant
install -o vagrant -g vagrant -m 0700 -d $(dirname $KEY_FILE)
install -o vagrant -g vagrant -m 0600 /dev/null $KEY_FILE
curl https://raw.githubusercontent.com/mitchellh/vagrant/master/keys/vagrant.pub -o $KEY_FILE

sed -re 's/^(GRUB_TIMEOUT)=.+/\1=0/' -i".bkup" /etc/default/grub
diff -U0 /etc/default/grub{.bkup,}
grub2-mkconfig -o /boot/grub2/grub.cfg

cat <<_EOL_ >> /etc/sysctl.conf
net.ipv6.conf.all.disable_ipv6 = 1
net.ipv6.conf.default.disable_ipv6 = 1
_EOL_
sysctl -p

setenforce 0
sed -re 's/^(SELINUX)=.+/\1=disabled/' -i".bkup" /etc/selinux/config
diff -U0 /etc/selinux/config{.bkup,}

sed -re 's/^#?(UseDNS) .+/\1 no/' \
    -re 's/^#?(GSSAPIAuthentication) .+/\1 no/' \
    -i".bkup" /etc/ssh/sshd_config
diff -U0 /etc/ssh/sshd_config{.bkup,}

install -m 0640 /dev/null /etc/sudoers.d/vagrant
cat <<EOL > /etc/sudoers.d/vagrant
Defaults:vagrant !requiretty
vagrant ALL=(ALL) NOPASSWD:ALL
EOL

install -m 0640 /dev/null /etc/sudoers.d/root
cat <<EOL > /etc/sudoers.d/root
Defaults:root !requiretty
EOL
