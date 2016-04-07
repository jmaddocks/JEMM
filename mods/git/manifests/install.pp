class git::install(
	$gitPath = "/usr/lib/git/",
	$gitVersion = "git-2.5.0",
	$packages = ["libcurl4-gnutls-dev","libexpat1-dev", "gettext", "libz-dev", "libssl-dev"])
	{

	Exec {
		path => ['/bin','/usr/bin','/usr/sbin']
	}

	package{ $packages :
		ensure => "present"
	}

	file{"${gitPath}" :
		require => Package[[$packages]],
		ensure => "directory"
	}
	
	file { "${gitPath}git-2.5.0.tar.gz":
		ensure => 'present',
		source => "puppet:///modules/git/git-2.5.0.tar.gz",
		require => File["${gitPath}"]
	}

	exec{ "extract git" :
		require => File["${gitPath}git-2.5.0.tar.gz"],
		cwd	=> "${gitPath}",
		command => "tar zxvf ${gitVersion}.tar.gz"
	}

	exec{ "install git" :
		require => Exec["extract git"],
		cwd	=> "${gitPath}${gitVersion}",
		command => "make prefix=/usr/local all && make prefix=/usr/local install"
	}
}
