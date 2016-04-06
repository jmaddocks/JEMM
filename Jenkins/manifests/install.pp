class jenkins::install(

//before doing this: deb http://pkg.jenkins-ci.org/debian binary/ is placed into files/../sources.list. This creates a source list for Jenkins

//wget http://...key for package keys are put into the bootstrap for vagrantfile
	
	$jenkins_path = "/etc/apt/sources.list.d/jenkins.list": //source list for Jenkins for software files
	
)

	Exec { 'install_jenkins_package_keys':class jenkins {
	
	exec { 'install_jenkins_package_keys':
		command => '/usr/bin/wget -q -O - http://pkg.jenkins-ci.org/debian/jenkins-ci.org.key | /usr/bin/apt-key add - ',
  }
		

	file { "${jenkins_path}":
		mode => 644
		owner => root,
		group => root,
		source => "puppet:///modules${jenkins_path}",
	}
	
	package { 'jenkins':
		ensure => latest,
		require => File ["${install_jenkins_package_keys}${jenkins_path}"],
	}
	
	service { "jenkins":
		ensure => running,
	}
}
}
