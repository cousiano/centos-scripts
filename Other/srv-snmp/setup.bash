echo "install snmp"
dnf -y install net-snmp net-snmp-utils
 
echo "start snmp on startup"
systemctl enable snmpd.service
 
echo "start service"
systemctl start snmpd.service
 
echo "open snmp port 161/tcp"
firewall-cmd --permanent --add-port=161/tcp
