#!/bin/bash

username=$(cat /tmp/normal_user)

echo "#####################################################"
echo "  Running OOB_SERVER CONFIG OVERLOAD Setup Script..."
echo "#####################################################"
echo -e "\n This script was written for Vx."
echo " Detected vagrant user is: $username"

#######################
#       KNOBS
#######################

## INTERFACES
echo " ### Overwriting /etc/network/interfaces ###"
cat <<EOT > /etc/network/interfaces
auto lo
iface lo inet loopback

auto eth0
iface eth0 inet dhcp
    alias Connects (via NAT) To the Internet

auto eth1
iface eth1
    alias Faces the Internal Management Network
    address 192.168.0.254/24

EOT

## NTP
echo " ### Configure NTP... ###"
cat <<EOT > /etc/ntp.conf
driftfile /var/lib/ntp/ntp.drift
statistics loopstats peerstats clockstats
filegen loopstats file loopstats type day enable
filegen peerstats file peerstats type day enable
filegen clockstats file clockstats type day enable

server pool.ntp.org

# By default, exchange time with everybody, but don't allow configuration.
restrict -4 default kod notrap nomodify nopeer noquery
restrict -6 default kod notrap nomodify nopeer noquery

# Local users may interrogate the ntp server more closely.
restrict 127.0.0.1
restrict ::1
EOT

## SSH
echo " ### Creating SSH keys for cumulus user ###"
mkdir -p /home/cumulus/.ssh
#/usr/bin/ssh-keygen -b 2048 -t rsa -f /home/cumulus/.ssh/id_rsa -q -N ""
cat <<EOT > /home/cumulus/.ssh/id_rsa
-----BEGIN RSA PRIVATE KEY-----
MIIEpAIBAAKCAQEAsx/kflIY1YnFLSNHWjVHHnWIX74E9XW2V4GN9yG5uDDqPl/O
CMLs4q5t0BZ2H9jt7smYzcqwOn4/ahROxJLpeGw+jwrLULqVz8HzzI57NjO7ZB7C
py2IzcVjapf6wlMaB9gepz8s7XEQmrLN5SHNnJX15AmPSbX+5IAtnv3ZnIcsD1eT
6xarZR4GVJ8qD8lgR+zozy1cWMLQiZ/erBZK42hvUAznqHojb3BpZOAyaf4PS+H9
gGhKuvcfPoAUxVKgBbA/HnDveNXDPLGtdeu67ET8e0it9u9CYuRFBd5WbIKWoiID
IbSAf+0DU5DfWY0AWs8cZTVTelrYRfKJG+zkrQIDAQABAoIBAAqDBp+7JaXybdXW
SiurEL9i2lv0BMp62/aKrdAg9Iswo66BZM/y0IAFCIC7sLbxvhTTU9pP2MO2APay
tmSm0ni0sX8nfQMB0CTfFvWcLvLhWk/n1jiFXY/l042/2YFp6w8mybW66WINzpGl
iJu3vh9AVavKO9Rxj8HNG+BGuWyMEQ7TB4JLIGOglfapHlSFzjBxlMTcVA4mWyDd
bztzh+Hn/J7Mmqw+FqmFXha+IWbojiMGTm1wS/78Iy7YgWpUYTP5CXGewC9fGnoK
H3WvZDD7puTWa8Qhd5p73NSEe/yUd5Z0qmloij7lUVX9kFNVZGS19BvbjAdj7ZL6
OCVLOkECgYEA3I7wDN0pmbuEojnvG3k09KGX4bkJRc/zblbWzC83rFzPWTn7uryL
n28JZMk1/DCEGWtroOQL68P2zSGdF6Yp3PAqsSKHks9fVJsJ0F3ZlXkZHtRFfNI7
i0dl5SsSWlnDPiSnC4bshM25vYb4qd3vij7vvHzb3rA3255u69aU0DkCgYEAz+iA
qoLEja9kTR+sqbP9zvHUWQ/xtKfNCQ5nnjXc7tZ7XUGEf0UTMrAgOKcZXKDq6g5+
hNTkEDPUpPwGhA4iAPbA96RNWh/bwClFQEkBHU3oHPzKcL2Utvo/c6pAb44f2bGD
9kS4B/sumQxvUYM41jfwXDFTNPXN/SBn2XnWUBUCgYBoRug1nMbTWTXvISbsPVUN
J+1QGhTJPfUgwMvTQ6u1wTeDPwfGFOiKW4v8a6krb6C1B/Wd3tPIByGDgJXuHXCD
dcUpdGLWxVaUAK0WJ5j8s4Ft8vxbdGYUhpAlVkTaFMBbfCbCK2tdqopbkhm07ioX
mYPtALdPRM9T9UcKF6zJ+QKBgQCd57lpR55e+foU9VyfG1xGg7dC2XA7RELegPlD
2SbuoynY/zzRqLXXBpvCS29gwbsJf26qFkMM50C2+c89FrrOvpp6u2ggbhfpz66Q
D6JwDk6fTYO3stUzT8dHYuRDlc8s+L0AGtsm/Kg8h4w4fZB6asv8SV4n2BTWDnmx
W+7grQKBgQCm52n2zAOh7b5So1upvuV7REHiAmcNNCHhuXFU75eZz7DQlqazjTzn
CNr0QLZlgxpAg0o6iqwUaduck4655bSrClg4PtnzuDe5e2RuPNSiyZRbUmmiYIYp
i06Z/SJZSH8a1AjEh2I8ayxIEIESpmyhn1Rv1aUT6IjmIQjgbxWxGg==
-----END RSA PRIVATE KEY-----
EOT
cat <<EOT > /home/cumulus/.ssh/id_rsa.pub
ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCzH+R+UhjVicUtI0daNUcedYhfvgT1dbZXgY33Ibm4MOo+X84Iwuzirm3QFnYf2O3uyZjNyrA6fj9qFE7Ekul4bD6PCstQupXPwfPMjns2M7tkHsKnLYjNxWNql/rCUxoH2B6nPyztcRCass3lIc2clfXkCY9Jtf7kgC2e/dmchywPV5PrFqtlHgZUnyoPyWBH7OjPLVxYwtCJn96sFkrjaG9QDOeoeiNvcGlk4DJp/g9L4f2AaEq69x8+gBTFUqAFsD8ecO941cM8sa1167rsRPx7SK3270Ji5EUF3lZsgpaiIgMhtIB/7QNTkN9ZjQBazxxlNVN6WthF8okb7OSt
EOT

cp /home/cumulus/.ssh/id_rsa.pub /home/cumulus/.ssh/authorized_keys

# Remove extra random file on TS 1.1
rm /home/cumulus/a

# Copying Vagrant Insecure Key In
echo "ssh-rsa AAAAB3NzaC1yc2EAAAABIwAAAQEA6NF8iallvQVp22WDkTkyrtvp9eWW6A8YVr+kz4TjGYe7gHzIw+niNltGEFHzD8+v1I2YJ6oXevct1YeS0o9HZyN1Q9qgCgzUFtdOKLv6IedplqoPkcmF0aYet2PkEDo3MlTBckFXPITAMzF8dJSIFo9D8HfdOV0IAdx4O7PtixWKn5y2hMNG0zQPyUecp4pzC6kivAIhyfHilFR61RGL+GPXQ2MWZWFYbAGjyiYJnAmCP3NOTd0jMZEnDkbUvxhMmBYSdETk1rRgm+R4LOzFUGaHqHDLKLX+FIPKcF96hrucXzcWyLbIbEgE98OHlnVYCzRdK8jlqm8tehUc9c9WhQ== vagrant insecure public key" > /home/vagrant/.ssh/authorized_keys
echo "ssh-rsa AAAAB3NzaC1yc2EAAAABIwAAAQEA6NF8iallvQVp22WDkTkyrtvp9eWW6A8YVr+kz4TjGYe7gHzIw+niNltGEFHzD8+v1I2YJ6oXevct1YeS0o9HZyN1Q9qgCgzUFtdOKLv6IedplqoPkcmF0aYet2PkEDo3MlTBckFXPITAMzF8dJSIFo9D8HfdOV0IAdx4O7PtixWKn5y2hMNG0zQPyUecp4pzC6kivAIhyfHilFR61RGL+GPXQ2MWZWFYbAGjyiYJnAmCP3NOTd0jMZEnDkbUvxhMmBYSdETk1rRgm+R4LOzFUGaHqHDLKLX+FIPKcF96hrucXzcWyLbIbEgE98OHlnVYCzRdK8jlqm8tehUc9c9WhQ== vagrant insecure public key" >> /home/cumulus/.ssh/authorized_keys
echo -e "sudo su - cumulus\nexit" >> /home/vagrant/.bashrc

chown -R cumulus:cumulus /home/cumulus/
chown -R cumulus:cumulus /home/cumulus/.ssh
chmod 700 /home/cumulus/.ssh/
chmod 600 /home/cumulus/.ssh/*
chown cumulus:cumulus /home/cumulus/.ssh/*

## Adding Alias for 'net' command on OOB Server
cat << EOT >> /home/cumulus/.bashrc
alias net="echo -e '\n######################################################\n    NOTE: You are on the OOB-MGMT-SERVER.\n         Are you sure you meant to run \"net\" here?\n######################################################\n'; /usr/bin/net"
EOT

## SETUP REPO
git clone -b branchbranchbranch https://github.com/cumulusnetworks/BootcampAutomation.git /home/cumulus/BootcampAutomation
chown -R cumulus:cumulus /home/cumulus/BootcampAutomation
chmod +x /home/cumulus/BootcampAutomation/config
echo 'export PATH=~/BootcampAutomation:$PATH' >> /home/cumulus/.bashrc


## SUDO
echo " ### Making cumulus passwordless sudo ###"
echo "cumulus ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/10_cumulus

## NAT
echo ' ### Setting UP NAT and Routing on MGMT server... ### '
echo -e '#!/bin/bash \n/sbin/iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE' > /etc/rc.local
echo "net.ipv4.ip_forward=1" > /etc/sysctl.d/98-ipforward.conf

## GIT
echo " ### creating .gitconfig for cumulus user"
cat <<EOT >> /home/cumulus/.gitconfig
[push]
  default = matching
[color]
    ui = true
[credential]
    helper = cache --timeout=3600
[core]
    editor = nano
EOT

## ANSIBLE
echo " ### Pushing Ansible Hosts File ###"
mkdir -p /etc/ansible
cat << EOT > /etc/ansible/hosts
[oob-switch]
oob-mgmt-switch ansible_host=192.168.0.1 ansible_user=cumulus

[exit]
exit02 ansible_host=192.168.0.42 ansible_user=cumulus
exit01 ansible_host=192.168.0.41 ansible_user=cumulus

[leaf]
leaf04 ansible_host=192.168.0.14 ansible_user=cumulus
leaf02 ansible_host=192.168.0.12 ansible_user=cumulus
leaf03 ansible_host=192.168.0.13 ansible_user=cumulus
leaf01 ansible_host=192.168.0.11 ansible_user=cumulus

[spine]
spine02 ansible_host=192.168.0.22 ansible_user=cumulus
spine01 ansible_host=192.168.0.21 ansible_user=cumulus

[host]
edge01 ansible_host=192.168.0.51 ansible_user=cumulus
server01 ansible_host=192.168.0.31 ansible_user=cumulus
server03 ansible_host=192.168.0.33 ansible_user=cumulus
server02 ansible_host=192.168.0.32 ansible_user=cumulus
server04 ansible_host=192.168.0.34 ansible_user=cumulus
EOT

## DHCP
echo " ### Pushing DHCP File ###"
cat << EOT > /etc/dhcp/dhcpd.conf
ddns-update-style none;

authoritative;

log-facility local7;

option www-server code 72 = ip-address;
option cumulus-provision-url code 239 = text;

# Create an option namespace called ONIE
# See: https://github.com/opencomputeproject/onie/wiki/Quick-Start-Guide#advanced-dhcp-2-vivsoonie/onie/
option space onie code width 1 length width 1;
# Define the code names and data types within the ONIE namespace
option onie.installer_url code 1 = text;
option onie.updater_url   code 2 = text;
option onie.machine       code 3 = text;
option onie.arch          code 4 = text;
option onie.machine_rev   code 5 = text;
# Package the ONIE namespace into option 125
option space vivso code width 4 length width 1;
option vivso.onie code 42623 = encapsulate onie;
option vivso.iana code 0 = string;
option op125 code 125 = encapsulate vivso;
class "onie-vendor-classes" {
  # Limit the matching to a request we know originated from ONIE
  match if substring(option vendor-class-identifier, 0, 11) = "onie_vendor";
  # Required to use VIVSO
  option vivso.iana 01:01:01;

  ### Example how to match a specific machine type ###
  #if option onie.machine = "" {
  #  option onie.installer_url = "";
  #  option onie.updater_url = "";
  #}
}

# OOB Management subnet
shared-network LOCAL-NET{

subnet 192.168.0.0 netmask 255.255.255.0 {
  range 192.168.0.201 192.168.0.250;
  option domain-name-servers 192.168.0.254;
  option domain-name "simulation";
  default-lease-time 172800;  #2 days
  max-lease-time 345600;      #4 days
  option www-server 192.168.0.254;
  option default-url = "http://192.168.0.254/onie-installer";
  option cumulus-provision-url "http://192.168.0.254/ztp_oob.sh";
  option ntp-servers 192.168.0.254;
}

}

#include "/etc/dhcp/dhcpd.pools";
include "/etc/dhcp/dhcpd.hosts";
EOT

echo " ### Push DHCP Host Config ###"
cat << EOT > /etc/dhcp/dhcpd.hosts
group {

  option domain-name-servers 192.168.0.254;
  option domain-name "simulation";
  option routers 192.168.0.254;
  option www-server 192.168.0.254;
  option default-url = "http://192.168.0.254/onie-installer";

 host oob-mgmt-switch {hardware ethernet a0:00:00:00:00:61; fixed-address 192.168.0.1; option host-name "oob-mgmt-switch"; option cumulus-provision-url "http://192.168.0.254/ztp_oob.sh";  } 

 host exit02 {hardware ethernet a0:00:00:00:00:42; fixed-address 192.168.0.42; option host-name "exit02"; option cumulus-provision-url "http://192.168.0.254/ztp_oob.sh";  } 

 host exit01 {hardware ethernet a0:00:00:00:00:41; fixed-address 192.168.0.41; option host-name "exit01"; option cumulus-provision-url "http://192.168.0.254/ztp_oob.sh";  } 

 host spine02 {hardware ethernet a0:00:00:00:00:22; fixed-address 192.168.0.22; option host-name "spine02"; option cumulus-provision-url "http://192.168.0.254/ztp_oob.sh";  } 

 host spine01 {hardware ethernet a0:00:00:00:00:21; fixed-address 192.168.0.21; option host-name "spine01"; option cumulus-provision-url "http://192.168.0.254/ztp_oob.sh";  } 

 host leaf04 {hardware ethernet a0:00:00:00:00:14; fixed-address 192.168.0.14; option host-name "leaf04"; option cumulus-provision-url "http://192.168.0.254/ztp_oob.sh";  } 

 host leaf02 {hardware ethernet a0:00:00:00:00:12; fixed-address 192.168.0.12; option host-name "leaf02"; option cumulus-provision-url "http://192.168.0.254/ztp_oob.sh";  } 

 host leaf03 {hardware ethernet a0:00:00:00:00:13; fixed-address 192.168.0.13; option host-name "leaf03"; option cumulus-provision-url "http://192.168.0.254/ztp_oob.sh";  } 

 host leaf01 {hardware ethernet a0:00:00:00:00:11; fixed-address 192.168.0.11; option host-name "leaf01"; option cumulus-provision-url "http://192.168.0.254/ztp_oob.sh";  } 

 host edge01 {hardware ethernet a0:00:00:00:00:51; fixed-address 192.168.0.51; option host-name "edge01"; } 

 host server01 {hardware ethernet a0:00:00:00:00:31; fixed-address 192.168.0.31; option host-name "server01"; } 

 host server03 {hardware ethernet a0:00:00:00:00:33; fixed-address 192.168.0.33; option host-name "server03"; } 

 host server02 {hardware ethernet a0:00:00:00:00:32; fixed-address 192.168.0.32; option host-name "server02"; } 

 host server04 {hardware ethernet a0:00:00:00:00:34; fixed-address 192.168.0.34; option host-name "server04"; } 

 host internet {hardware ethernet a0:00:00:00:00:50; fixed-address 192.168.0.253; option host-name "internet"; option cumulus-provision-url "http://192.168.0.254/ztp_oob.sh";  } 

}#End of static host group
EOT

chmod 755 -R /etc/dhcp/*
systemctl enable dhcpd
systemctl restart dhcpd

## LOCAL DNS
echo " ### Push Hosts File ###"
cat << EOT > /etc/hosts
127.0.0.1 localhost 
127.0.1.1 oob-mgmt-server

192.168.0.254 oob-mgmt-server 

192.168.0.1 oob-mgmt-switch
192.168.0.42 exit02
192.168.0.41 exit01
192.168.0.22 spine02
192.168.0.21 spine01
192.168.0.14 leaf04
192.168.0.12 leaf02
192.168.0.13 leaf03
192.168.0.11 leaf01
192.168.0.51 edge01
192.168.0.31 server01
192.168.0.33 server03
192.168.0.32 server02
192.168.0.34 server04
192.168.0.253 internet

# The following lines are desirable for IPv6 capable hosts
::1     localhost ip6-localhost ip6-loopback
ff02::1 ip6-allnodes
ff02::2 ip6-allrouters
EOT

systemctl enable dnsmasq.service
systemctl start dnsmasq.service

## HTTP
echo "Setting up Files to be served via HTTP..."
echo "<html><h1>You've come to the $HOSTNAME.</h1></html>" > /var/www/html/index.html
echo "this is a fake license" >/var/www/html/license.lic
cat << EOT > /var/www/html/topology.dot
graph vx {

 # Leaf to Spine Connections
 "leaf01":"swp51" -- "spine01":"swp1"
 "leaf02":"swp51" -- "spine01":"swp2"
 "leaf03":"swp51" -- "spine01":"swp3"
 "leaf04":"swp51" -- "spine01":"swp4"
 "leaf01":"swp52" -- "spine02":"swp1"
 "leaf02":"swp52" -- "spine02":"swp2"
 "leaf03":"swp52" -- "spine02":"swp3"
 "leaf04":"swp52" -- "spine02":"swp4"
 "exit01":"swp51" -- "spine01":"swp30"
 "exit01":"swp52" -- "spine02":"swp30"
 "exit02":"swp51" -- "spine01":"swp29"
 "exit02":"swp52" -- "spine02":"swp29"

 # Leaf Peerlink Connections
 "leaf01":"swp49" -- "leaf02":"swp49"
 "leaf01":"swp50" -- "leaf02":"swp50"
 "leaf03":"swp49" -- "leaf04":"swp49"
 "leaf03":"swp50" -- "leaf04":"swp50"
 "exit01":"swp49" -- "exit02":"swp49"
 "exit01":"swp50" -- "exit02":"swp50"

 # Spine Peerlink Connections
 "spine01":"swp31" -- "spine02":"swp31"
 "spine01":"swp32" -- "spine02":"swp32"

 # Server to Leaf Connections
 "server01":"eth1" -- "leaf01":"swp1"
 "server01":"eth2" -- "leaf02":"swp1"
 "server02":"eth1" -- "leaf01":"swp2"
 "server02":"eth2" -- "leaf02":"swp2"
 "server03":"eth1" -- "leaf03":"swp1"
 "server03":"eth2" -- "leaf04":"swp1"
 "server04":"eth1" -- "leaf03":"swp2"
 "server04":"eth2" -- "leaf04":"swp2"

 # Hyperloop Connections
 "exit01":"swp45" -- "exit01":"swp46"
 "exit01":"swp47" -- "exit01":"swp48"
 "exit02":"swp45" -- "exit02":"swp46"
 "exit02":"swp47" -- "exit02":"swp48"
 "leaf01":"swp45" -- "leaf01":"swp46"
 "leaf01":"swp47" -- "leaf01":"swp48"
 "leaf02":"swp45" -- "leaf02":"swp46"
 "leaf02":"swp47" -- "leaf02":"swp48"
 "leaf03":"swp45" -- "leaf03":"swp46"
 "leaf03":"swp47" -- "leaf03":"swp48"
 "leaf04":"swp45" -- "leaf04":"swp46"
 "leaf04":"swp47" -- "leaf04":"swp48"

 # External Peering Connections
 "internet":"swp1" -- "exit01":"swp44"
 "internet":"swp2" -- "exit02":"swp44"

 # Edge Server to Exit Leaf Connections
 "edge01":"eth1" -- "exit01":"swp1"
 "edge01":"eth2" -- "exit02":"swp1"

 # Management Network
 "oob-mgmt-server":"eth1" -- "oob-mgmt-switch":"swp1"
 "server01":"eth0" -- "oob-mgmt-switch":"swp2"
 "server02":"eth0" -- "oob-mgmt-switch":"swp3"
 "server03":"eth0" -- "oob-mgmt-switch":"swp4"
 "server04":"eth0" -- "oob-mgmt-switch":"swp5"
 "leaf01":"eth0" -- "oob-mgmt-switch":"swp6"
 "leaf02":"eth0" -- "oob-mgmt-switch":"swp7"
 "leaf03":"eth0" -- "oob-mgmt-switch":"swp8"
 "leaf04":"eth0" -- "oob-mgmt-switch":"swp9"
 "spine01":"eth0" -- "oob-mgmt-switch":"swp10"
 "spine02":"eth0" -- "oob-mgmt-switch":"swp11"
 "exit01":"eth0" -- "oob-mgmt-switch":"swp12"
 "exit02":"eth0" -- "oob-mgmt-switch":"swp13"
 "edge01":"eth0" -- "oob-mgmt-switch":"swp14"
 "internet":"eth0" -- "oob-mgmt-switch":"swp15"
}
EOT

echo "Copying Key into /var/www/html..."
cp /home/cumulus/.ssh/id_rsa.pub /var/www/html/authorized_keys
chmod 777 -R /var/www/html/*

## Local NetQ Config File
cat << EOT > /etc/cts/netq/netq.yml
notifier-integrations:
- name: notifier-slack-channel-1
  type: slack
  webhook: "linklinklink"
  severity: INFO

notifier-filters:
  - name: default
    rule:
    output:
      - ALL
EOT

## ZTP
echo " ### Pushing ZTP Script ###"
cat << EOT > /var/www/html/ztp_oob.sh
#!/bin/bash

###################
#   ZTP Script
###################

# This function provides more information should the script die somewhere during execution
function error() {
  echo -e "\e[0;33mERROR: The Zero Touch Provisioning script failed while running the command \$BASH_COMMAND at line \$BASH_LINENO.\e[0m" >&2
}

# Instructs the script to send any errors encountered to the function above
trap error ERR

# Setup SSH key authentication for Ansible
mkdir -p /home/cumulus/.ssh
#wget -O /home/cumulus/.ssh/authorized_keys http://192.168.0.254/authorized_keys
echo "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCzH+R+UhjVicUtI0daNUcedYhfvgT1dbZXgY33Ibm4MOo+X84Iwuzirm3QFnYf2O3uyZjNyrA6fj9qFE7Ekul4bD6PCstQupXPwfPMjns2M7tkHsKnLYjNxWNql/rCUxoH2B6nPyztcRCass3lIc2clfXkCY9Jtf7kgC2e/dmchywPV5PrFqtlHgZUnyoPyWBH7OjPLVxYwtCJn96sFkrjaG9QDOeoeiNvcGlk4DJp/g9L4f2AaEq69x8+gBTFUqAFsD8ecO941cM8sa1167rsRPx7SK3270Ji5EUF3lZsgpaiIgMhtIB/7QNTkN9ZjQBazxxlNVN6WthF8okb7OSt" >> /home/cumulus/.ssh/authorized_keys
chmod 700 -R /home/cumulus/.ssh
chown cumulus:cumulus -R /home/cumulus/.ssh

# Setup SUDO access that does not require a password for all users in the "sudo" group
echo "cumulus ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/10_cumulus

# Setup NTP
#   Remove the last 3 default NTP Servers
sed -i '/^server [1-3]/d' /etc/ntp.conf
#   Modify the first server to point to the oob-mgmt-server as the authoritative time source
sed -i 's/^server 0.cumulusnetworks.pool.ntp.org iburst/server 192.168.0.254 iburst/g' /etc/ntp.conf

# Check to see if the internet is reachable
ping 8.8.8.8 -c2
if [ "\$?" == "0" ]; then

  # Install the Cumulus External Repository Source
  cat << TOE > /etc/apt/sources.list.d/cumulus-apps.list
deb http://apps3.cumulusnetworks.com/repos/deb CumulusLinux-3 netq-1.1
TOE

  # Install NetQ
  apt-get update -qy
  apt-get install cumulus-netq -qy

  # Setup a Default configuration for NetQ
  cat << TOE > /etc/netq/netq.yml
#/etc/netq/netq.yml
# See /usr/share/doc/netq/examples for full configuration file
backend:
  port: 6379
  server: 192.168.0.254
  vrf: default
user-commands:
- commands:
  - command: /bin/cat /etc/network/interfaces
    key: config-interfaces
    period: '60'
  - command: /bin/cat /etc/ntp.conf
    key: config-ntp
    period: '60'
  service: misc
- commands:
  - command:
    - /usr/bin/vtysh
    - -c
    - show running-config
    key: config-quagga
    period: '60'
  service: zebra
TOE

  # Enable NTP and NetQ
  systemctl restart ntp
  systemctl restart netq-agent
  systemctl restart netqd
fi
#nohup bash -c 'sleep 2; shutdown now -r "Rebooting to Complete ZTP"' &
exit 0
# The line below is required to be a valid ZTP script
#CUMULUS-AUTOPROVISIONING
EOT

echo "############################################"
echo "      DONE!"
echo "############################################"
