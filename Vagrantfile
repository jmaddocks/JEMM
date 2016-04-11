# -*- mode: ruby -*-
# vi: set ft=ruby :

masterIP = "192.168.1.112"

Vagrant.configure("2") do |config|
	config.vm.boot_timeout = 400
	
	config.vm.define "master" do |master|
		master.vm.synced_folder "modules", "/tmp/modules"
		master.vm.hostname = "JEMMmaster.qac.local"
		master.vm.box = "chad-thompson/ubuntu-trusty64-gui"
		master.vm.network "public_network", ip: masterIP 
		master.vm.provision :shell, path: "bootstrap_m.sh"
		master.vm.provider :virtualbox do |masterVM|
			masterVM.gui = true
			masterVM.name = "master"
			masterVM.memory = 4096
			masterVM.cpus = 2
		end
	end
	
	config.vm.define "agent1" do |agent1|
		agent1.vm.hostname = "jemmagent1.qac.local"
		agent1.vm.box = "chad-thompson/ubuntu-trusty64-gui"
		agent1.vm.network "public_network", ip: "192.168.1.113"
		agent1.vm.provision :shell, path: "bootstrap_a.sh"
		agent1.vm.provider :virtualbox do |agent1VM|
			agent1VM.gui = true
			agent1VM.name = "agent1"
			agent1VM.memory = 3072
			agent1VM.cpus = 2
		end
	end
end

