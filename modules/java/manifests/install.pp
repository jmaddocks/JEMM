class java::install (
  $java_archive = 'java.tar.gz',
  $java_home = '/usr/local/java',
  $java_version = 'jdk1.8.0_45/')
	
  {
  Exec {
  path => ['/bin', '/usr/bin', '/usr/sbin'] #path to place file
  }

  file {"${java_home}" :
  ensure => 'directory' #making java_home is the directory
  }

  file {"${java_home}${java_archive}":
  ensure  => 'present',
  source  => "puppet:///modules/java/${java_archive}",
  require => File ["${java_home}"],
  }

  exec {'extract_java':
  cwd 	  => '${java_home}',
  command => "tar zxvf ${java_archive}",
  creates => "${java_home}${java_version}",
  require => File["${java_home}${java_archive}"],
  }

  exec {'install_java':
  require   => Exec['extract_java'],
  logoutput => true,
  command   => "update-alternatives --install /bin/java java ${java_home}${java_version}bin/java 100 && update-alternatives --install /bin/javac javac ${java_home}${java_version}bin/javac 100",
  }	
}
