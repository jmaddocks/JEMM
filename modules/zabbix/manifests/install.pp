class zabbix::install {
	$zabbixPath= "/usr/lib/zabbix/",
	$zabbixVersion = "zabbix-2.4.1")
	

	Exec {
		path => ["/bin","/usr/bin","/usr/sbin"]
	}

	file {"${zabbixPath}" :
		ensure => 'directory'
	}
	
	file { "${zabbixPath}${zabbixVersion}-bin.tar.gz":
		ensure => 'present',
		source => "puppet:///modules/zabbix/${zabbixVersion}-bin.tar.gz",
		require => File["${zabbixPath}"]
	}

	exec { "extract zabbix" :
		require	=> File["${zabbixPath}${zabbixVersion}-bin.tar.gz"],
		cwd	=> "${zabbixPath}",
		command	=> "tar zxvf ${zabbixVersion}-bin.tar.gz"
	}

	exec { "install zabbix" :
		require => Exec["extract zabbix"],
		command => "update-alternatives --install /bin/zabbix zabbix ${zabbixPath}${zabbixVersion}/bin/zabbix 1"
	}
}
