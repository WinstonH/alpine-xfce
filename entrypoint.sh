#!/bin/sh

#prepare sshd config
mkdir -p /var/run/sshd
sed -i "s/UsePrivilegeSeparation.*/UsePrivilegeSeparation no/g" /etc/ssh/sshd_config \
&& sed -i "s/UsePAM.*/UsePAM no/g" /etc/ssh/sshd_config \
&& sed -i "s/PermitRootLogin.*/PermitRootLogin yes/g" /etc/ssh/sshd_config \
&& sed -i "s/#AuthorizedKeysFile/AuthorizedKeysFile/g" /etc/ssh/sshd_config \
&& sed -i "s/#X11Forwarding no/X11Forwarding yes/g" /etc/ssh/sshd_config \
&& sed -i "s/#PermitUserEnvironment no/PermitUserEnvironment yes/g" /etc/ssh/sshd_config \
&& echo "ForwardX11Trusted yes" >> /etc/ssh/ssh_config

#prepare xauth
touch /root/.Xauthority

/usr/bin/supervisord -c /etc/supervisord.conf
exec "$@"
