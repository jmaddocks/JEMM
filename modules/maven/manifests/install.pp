class maven::install {
	$mavenPath = "/usr/lib/maven/",
	$mavenVersion = "apache-maven-3.3.3")
	

	Exec {
		path => ["/bin","/usr/bin","/usr/sbin"]
	}

	file{"${mavenPath}" :
		ensure => 'directory'
	}
	
	file { "${mavenPath}${mavenVersion}-bin.tar.gz":
		ensure => 'present',
		source => "puppet:///modules/maven/${mavenVersion}-bin.tar.gz",
		require => File["${mavenPath}"]
	}

	exec{ "extract maven" :
		require	=> File["${mavenPath}${mavenVersion}-bin.tar.gz"],
		cwd	=> "${mavenPath}",
		command	=> "tar zxvf ${mavenVersion}-bin.tar.gz"
	}

	exec{ "install maven" :
		require => Exec["extract maven"],
		command => "update-alternatives --install /bin/mvn mvn ${mavenPath}${mavenVersion}/bin/mvn 1"
	}
}
