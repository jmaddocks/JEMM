class jenkins::install {

  Exec {
  path => ['/bin', '/usr/bin', '/usr/sbin', '/usr/local/sbin', '/sbin']
  }

  exec {'keys':
  command => 'wget -q -O - http://pkg.jenkins-ci.org/debian binary/ > /etc/apt/source.list.d/jenkins.list'",
  require => Exec ['keys']
  }
		
  files { '/etc/apt/sources.list.d/jenkins.list',
  mode => '0644',
  owner => root,
  group => root,
  source => 'puppet:///modules/jenkins/jenkins.list'
  }

  exec { 'update':
  command => 'sudo apt-get update'
  require => File['/etc/apt.sources.list.d/jenkins.list']
  }

  exec { 'install':
  command => 'sudo apt-get install -y jenkins',
  require => Exec['update']
  }
  
  exec{ 'stop':
  command => 'sudo service jenkins stop'
  require => Exec['install']
  }

  exec { 'start':
  command => 'sudo service jenkins start'
  require => Exec['stop']
  }
}
