class git::install (
	#declaring variables to reduce repeating long winded file names
	
	$git_path     = "/usr/lib/git/", 		#where to save file
	$git_version  = "git-2.8.0",		    #version of git to install
	$git_tar	  = "git-2.8.0.tar.gz", 	#git tarball
	$git_packages = "[libcurl4-gnutls-dev","libexpat1-dev", "gettext", "libz-dev", "libssl-dev]",
	#git requres these packages to function properly:URL transfer library;XML parsing c library development kit;internationalise the language;virtual package;SSL development libraries
	)

	Exec {
		path => ['/bin','/usr/bin','/usr/sbin'] #binaries required for code below to be recognised
	}

	package { $git_packages:
		ensure => "present",					#package installed
	}
	
	file { "${git_path"}:
		ensure  => directory,
		require => Package[$git_packages],		#make sure directory
	}
	
	file { "${git_path}${git_tar}":
		ensure  => 'present',
		source  => "puppet:///modules/git/${git_tar}",
		require => File["${git_path}"],			#ensuring the file exists if not find the source
	}
		
	exec { "extract git":
		cwd   	=> "${git_path}",
		command => "tar zxvf ${git_tar}",
		create  => "${git_path}${git_version}",
		require => File["${git_path}${git_tar}"], 	#Extract java
	}
	
	exec { "install git":
		require => Exec["${extract git}"],
		cwd  	=> "${git_path}${git_version}",
		command => "make prefix=/usr/local all && make prefix=/usr/local install", 	#Install
	}	
	

	
	
	
	