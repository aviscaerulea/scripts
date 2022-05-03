#!/bin/bash -eux
printf "install insecure pub key of vagrant official\n"
readonly KEY_FILE="/home/vagrant/.ssh/authorized_keys"
install -o vagrant -g vagrant -m 0700 -d $(dirname $KEY_FILE)
install -o vagrant -g vagrant -m 0600 /dev/null $KEY_FILE
curl https://raw.githubusercontent.com/mitchellh/vagrant/master/keys/vagrant.pub -o $KEY_FILE

cat <<_EOL_ >> /etc/sysctl.conf
net.ipv6.conf.all.disable_ipv6 = 1
net.ipv6.conf.default.disable_ipv6 = 1
_EOL_
sysctl -p

printf "change grub config\n"
sed -re 's/^(GRUB_TIMEOUT)=.+/\1=0/' -i".bkup" /etc/default/grub
diff -U0 /etc/default/grub{.bkup,}
grub2-mkconfig -o /boot/grub2/grub.cfg

printf "disabled SELinux\n"
setenforce 0
sed -re 's/^(SELINUX)=.+/\1=disabled/' -i".bkup" /etc/selinux/config
diff -U0 /etc/selinux/config{.bkup,}

printf "change sshd config\n"
sed -re 's/^#?(UseDNS) .+/\1 no/' \
    -re 's/^#?(GSSAPIAuthentication) .+/\1 no/' \
    -i".bkup" /etc/ssh/sshd_config
diff -U0 /etc/ssh/sshd_config{.bkup,}

printf "create sudoers.d for vagrant\n"
tee /etc/sudoers.d/vagrant <<_EOL_ > /dev/null
Defaults:vagrant !requiretty
vagrant ALL=(ALL) NOPASSWD:ALL
_EOL_

printf "create sudoers.d for root\n"
tee /etc/sudoers.d/root <<_EOL_ > /dev/null
Defaults:root !requiretty
_EOL_

chmod 0640 /etc/sudoers.d/*
printf "done\n"
