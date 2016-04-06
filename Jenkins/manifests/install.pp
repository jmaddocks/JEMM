class jenkins::install(

//before doing this: deb http://pkg.jenkins-ci.org/debian binary/ is placed into files/../sources.list. This creates a source list for Jenkins

//wget http://...key for package keys are put into the bootstrap for vagrantfile
	
	$jenkins_path = "/etc/apt/sources.list.d/jenkins.list": //source list for Jenkins for software files
	
)

	Exec { 'install_jenkins_package_keys':class jenkins {
	
		

	file { "${jenkins_path}":
		mode => 644
		owner => root,
		group => root,
		source => "puppet:///modules${jenkins_path}",
	}
	
	package { 'jenkins':
		ensure => latest,
		require => File ["${jenkins_path}"],
	}
	
	service { "jenkins":
		ensure => running,
	}
}

	
	
	//do I put in a require => wget key thingy even if the bootstrap has it in?
	
	
	
	
	
	
	
	
	
	
	
	

	//$jenkins_path 		= "/usr/lib/jenkins/",
//	$jenkins_tar	 	= "",
	//$jenkins_version	= "jenkins-1.656",
//	$jenkins_key		= "http://pkg.jenkins-ci.org/debian/jenkins-ci.org.key",
	



//need the jenkins binary installer first-possibly put into files folder

 //	Exec {
//		path => ["/bin", "/usr/bin", "/usr/sbin"] 
	//}//binaries required for code below to be recognised
	
//	file {"${jenkins_key}":
//		ensure => 
//	}
	
	
	
//	file { "${jenkins_path}":
//		ensure => 'directory',
//	} //making sure we are in that current directory
	
//	file { "${}":
//		ensure  => 'present',
//		require => File ["${jenkins_path}"]
//	}
	
	service { "jenkins":
		ensure => running,
	}
