#!/usr/bin/env bash

export DEBIAN_FRONTEND=noninteractive


sudo apt-get update
sudo apt-get install -y openssh-server openssh-client
ifconfig
sudo ufw disable
sudo apt-get install -y vim
#copy over puppet modules
cp -r /tmp/modules/* /etc/puppet/modules/

if grep -aq "puppetmaster" /etc/hosts
then # provision has already been run - update hosts
	#update ip in hosts
	sed -i "1s/.*/$(facter ipaddress_eth1)\t$(facter fqdn)\tpuppetmaster/" /etc/hosts
	
else # run provision for first time - install all
	#install packages
	apt-get install -y openssh-server puppetmaster
	
	#hosts
	echo -e "$(facter ipaddress_eth1)\t$(facter fqdn)\tpuppetmaster\n127.0.0.1\t$(facter fqdn)\tpuppetmaster" | cat - /etc/hosts > temp && sudo mv temp /etc/hosts
	
	#site.pp
	echo -e "node '$(facter fqdn)' {\n\trequire java\n\trequire jira\n\trequire maven\n\trequire git\n\trequire jenkins\n\trequire zabbix\n}" >> /etc/puppet/manifests/site.pp
	echo -e "node 'JEMMagent1.qac.local' {\n\trequire java\n\trequire jira\n\trequire maven\n\trequire gitn\trequire jenkins\n}" >> /etc/puppet/manifests/site.pp
	echo -e "node 'JEMMagent2.qac.local' {\n\trequire java\n\trequire jira\n\trequire maven\n\trequire gitn\trequire jenkins\n}" >> /etc/puppet/manifests/site.pp
	echo "JEMMagent1.qac.local" >> /etc/puppet/autosign.conf
	echo "JEMMagent2.qac.local" >> /etc/puppet/autosign.conf

	#set default puppet master
	sed -i '1s/.*/[main]\nserver=JEMMmaster.qac.local/' /etc/puppet/puppet.conf
	
	#create necessary directories
	mkdir /etc/puppet/modules/{git,java,jira,maven,zabbix}/files 
	
		#download files
	wget -nv http://$1/aaron/downloads/git-2.8.0.tar.gz -O /etc/puppet/modules/git/files/git-2.8.0.tar.gz
	wget -nv http://$1/aaron/downloads/jdk-7u79-linux-x64.tar.gz -O /etc/puppet/modules/java/files/jdk-7u79-linux-x64.tar.gz
	wget -nv http://$1/aaron/downloads/atlassian-jira-6.4.9-x64.bin -O /etc/puppet/modules/jira/files/atlassian-jira-6.4.9-x64.bin
	wget -nv http://$1/aaron/downloads/apache-maven-3.3.3-bin.tar.gz -O /etc/puppet/modules/maven/files/apache-maven-3.3.3-bin.tar.gz
	wget -nv http://repo.zabbix.com/zabbix/3.0/ubuntu/pool/main/z/zabbix-release/zabbix-release_3.0-1+trusty_all.deb -O /etc/puppet/modules/zabbix/files/zabbix-3.0.1.deb
	
	#enable agenta.
	puppet agent --enable
fi

#run puppet update
puppet agent -tv
exit 0
