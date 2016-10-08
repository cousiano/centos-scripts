#!/bin/bash
 
echo "install samba"
yum -y install samba
 
echo "activate samba on boot"
systemctl enable smb.service
 
echo "backup /etc/samba/smb.conf (we will change it)"
mv /etc/samba/smb.conf /etc/samba/smb.conf.backup
 
echo "create smb.conf. Note: this example is not secure"
cat > /etc/samba/smb.conf << "EOF"
 
[global]
workgroup = MYWORKGROUP
netbios name = centos
server string = Samba Server  %v
 
#security mode:
security = share
domain logons = no
encrypt passwords = yes
 
dns proxy = no
time server = yes
os level = 255
log file = /var/log/samba/log.%m
max log size = 50
hosts allow = a.b.c.
hosts deny = ALL
interfaces = lo eth0
bind interfaces only = Yes
socket options = TCP_NODELAY SO_RCVBUF=8192 SO_SNDBUF=8192
 
# everyone can read system.
[system]
comment = The system files
path = /
public = yes
writable = no
create mask = 0777
EOF

myprefixIP=`/sbin/ifconfig eth0 | grep 'inet addr:' | cut -d: -f2 | cut -d. -f1,2,3| awk '{ print $1}'`
sed -i "s/a.b.c/$myprefixIP/g" /etc/samba/smb.conf

echo "add service smb (port 445) to firewall"
firewall-cmd --permanent --add-service samba
firewall-cmd --reload


echo "restart samba"
systemctl restart smb.service
 
myip=`hostname -I`
echo "Now meet you here: file://$myip"
