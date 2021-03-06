class java::config {
	Exec {
	path => ['/bin','/usr/bin','/usr/sbin']
	}

	file {"/etc/profile.d/java.sh":
	require => Exec['install_java'],
	content => 'export JAVA_FOLDER=/usr/local/java/jdk1.8.0_45
export PATH=$JAVA_FOLDER/bin:$PATH',
	mode => 755
	}
}
