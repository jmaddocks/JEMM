class git::install (
  $git_path     = "/usr/lib/git/",
  $git_version  = "git-2.8.1",
  $packages = ["libcurl4-gnutls-dev","libexpat1-dev", "gettext", "libz-dev", "libssl-dev"])
  {
  Exec {
  path => ['/bin','/usr/bin','/usr/sbin'] 
  }

  package { $packages :
  ensure => 'installed',
  }

  file { "${git_path}"} :
  ensure  => 'directory',
  require => Package[[$packages]],		#make sure directory
  }

  file { "${git_path}git-2.8.1.tar.gz":
  ensure  => 'present',
  source  => "puppet:///modules/git/git-2.8.1.tar.gz",
  require => File["${git_path}"],
  }

  exec { "extract git":
  cwd     => "${git_path}",
  command => "tar zxvf git-2.8.1.tar.gz",
  require => File["${git_path}git-2.8.1.tar.gz"] 	
  }

  exec { "install git":
  require => Exec["extract git"],
  cwd  	  => "${git_path}${git_version}",
  command => "make prefix=/usr/local all && make prefix=/usr/local install" 	#Install
  }
}
