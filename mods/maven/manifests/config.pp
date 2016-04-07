class maven::config {
	Exec {
		path => ["/bin","/usr/bin","/usr/sbin"]
	}
	
	file {"/etc/profile.d/maven.sh":
		require => Exec["install maven"],
		content => 'export MAVEN_HOME=/usr/lib/maven/apache-maven-3.3.3
export PATH=$MAVEN_HOME/bin:$PATH',
		mode => 755
	}
}