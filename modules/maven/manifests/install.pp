class maven::install (
  $mavenPath = "/usr/lib/maven/",
  $mavenVersion = "apache-maven-3.3.9")
  
  {
  Exec {
  path => ['/bin','/usr/bin','/usr/sbin']
  }

  file {"${mavenPath}" :
  ensure => 'directory'
  }
	
  file { "${mavenPath}maven.tar.gz":
  ensure  => 'present',
  source  => "puppet:///modules/maven/maven.tar.gz",
  require => File["${mavenPath}"]
  }

  exec { "extract maven" :
  require	=> File["${mavenPath}maven.tar.gz"],
  cwd	    => "${mavenPath}",
  command	=> "tar zxvf maven.tar.gz"
  }

  exec { "install maven" :
  require => Exec["extract maven"],
  command => "update-alternatives --install /bin/mvn mvn ${mavenPath}${mavenVersion}/bin/mvn 1"
  }
}
