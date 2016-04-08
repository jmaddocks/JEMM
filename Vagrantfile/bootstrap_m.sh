#!/usr/bin/env bash

export DEBIAN_FRONTEND=noninteractive

sudo apt-get update
ifconfig
sudo ufw disable

#copy over puppet modules
cp -r /tmp/modules/* /etc/puppet/modules/

if grep -aq "puppetmaster" /etc/hosts
then # provision has already been run - update hosts
	#update ip in hosts
	sed -i "1s/.*/$(facter ipaddress_eth1)\t$(facter fqdn)\tpuppetmaster/" /etc/hosts
	
else # run provision for first time - install all
	#install packages
	apt-get install -y openssh-server openssh-client
	apt-get install -y openssh-server puppetmaster
	
	sed -i "1s/.*/$(facter ipaddress_eth1)\t$(facter fqdn)\tpuppetmaster/" /etc/hosts
	
	#hosts
	echo -e "127.0.0.1\t$(facter fqdn)\tpuppetmaster\n$(facter ipaddress_eth1)\t$(facter fqdn)\tpuppetmaster" | cat - /etc/hosts > temp && sudo mv temp /etc/hosts
	
	#site.pp
	echo -e "node '$(facter fqdn)' {\n\trequire java\n\trequrie jira\n\trequire maven\n\trequire git\n\trequire jenkins\n\trequire zabbix\n}" >> /etc/puppet/manifests/site.pp
	echo -e "node 'JEMMagent1.qac.local' {\n\trequire java\n\trequire jira\n\trequire maven\n\trequire git\n\trequire jenkins\n}" >> /etc/puppet/manifests/site.pp
	echo -e "node 'JEMMagent2.qac.local' {\n\trequire java\n\trequire jira\n\trequire maven\n\trequire git\n\trequire jenkins\n}" >> /etc/puppet/manifests/site.pp


	#set default puppet master
	echo -e "[agent]" >> /etc/puppet/puppet.conf
	sed -i '18s/.*/[agent]\nserver=JEMMmaster.qac.local/' /etc/puppet/puppet.conf

	
	#certification
	echo "JEMMagent1.qac.local" >> /etc/puppet/autosign.conf
	echo "JEMMagent2.qac.local" >> /etc/puppet/autosign.conf
	
	
	#create necessary directories
	mkdir /etc/puppet/modules/{git,java,jira,maven,zabbix,jenkins}
	mkdir /etc/puppet/modules/{git,java,jira,maven,zabbix,jenkins}/files
	
	#download files
	wget -nv http://$1/aaronmulholland/downloads/git-2.5.0.tar.qz -O /etc/puppet/modules/git/files/git-2.5.0.tar.qz
	wget -nv http://aaronmulholland.co.uk/java.tar.gz -O /etc/puppet/modules/java/files/java.tar.gz
	wget -nv http://aaronmulholland.co.uk/jira.bin -O /etc/puppet/modules/jira/files/jira.bin
	wget -nv http://aaronmulhollandco.uk/maven.tar.gz -O /etc/puppet/modules/maven/files/maven.tar.gz
	wget -nv http://repo.zabbix.com/zabbix/2.4/ubuntu/pool/main/z/zabbix-release/zabbix-release_2.4-1+trusty_all.deb -O /etc/puppet/modules/zabbix/files/zabbix-2.4.1.deb
	
fi

exit 0