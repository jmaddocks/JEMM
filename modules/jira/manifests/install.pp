class jira::install (

	#binary file for download in bootstrap file
	$jira_file = "http://aaronmulholland.co.uk/jira.bin",
	$jira_path = "/opt/jira/", #where the jira will be installed
	)

	Exec {
		path => ['/bin','/usr/bin','/usr/sbin'] #binaries required for code below to be recognised
	}

	file { "${jira_path}":
		ensure	 => 'directory',
	} #making sure the file will be saved within the this directory

	file { "${jira_file}":
		ensure  => 'present',
		require => File  ["${java_path}"],
	} #ensure binary file is present- should be available through the bootstrap file

	file { "${jira_path}${jira_file}":
		ensure  => 'present',
		source  => "puppet:///modules/jira/${jira_file}",
		mode 	=> 755  	#script equivalent of chmod atx 
		require => File ["${jira_path}"], #ensuring the file exists if not find the source
	}
		

	exec { "install jira":
		cwd 	=> "${jira_path}",
		command => printf \"o\n2\n\n\n2\n8079\n8005\n\ny\n\", #automate the express/custom and change of ports
		onlyif	=> "[! -e /opt/atlassian/jira/uninstall ]" #type reference thing
		require => File ["${jira_path}${jira_file}"],
	}
