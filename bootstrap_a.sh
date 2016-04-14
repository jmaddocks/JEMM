#!/usr/bin/env bash

export DEBIAN_FRONTEND=noninteractive

sudo apt-get update 
sudo apt-get install -y openssh-server openssh-client
ifconfig
sudo ufw disable

if grep -aq "puppetmaster" /etc/hosts
then # provision has already been run - update hosts

	#update ip in hosts
	sed -i "192.168.1.112\tJEMMmaster.qac.local\tpuppetmaster/" /etc/hosts

else # run provision for first time - install all	

	apt-get install -y puppet

	echo -e "192.168.1.112\tJEMMmaster.qac.local\tpuppetmaster\n127.0.0.1\t$(facter fqdn)\tpuppet\n$(facter ipaddress_eth1)\t$(facter fqdn)\tpuppet" | cat - /etc/hosts > temp && sudo mv temp /etc/hosts

	sed -i '1s/.*/[main]\nserver=JEMMmaster.qac.local/' /etc/puppet/puppet.conf
	

fi 

exit 0