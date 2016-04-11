class jira::install (
	$jira_file = "jira.bin",
	$jira_path = "/etc/puppet/modules/jira")

	{

	Exec {
		path => ['/bin','/usr/bin','/usr/sbin']
	}

	file { "${jira_path}":
		ensure	 => 'directory'
	} #making sure the file will be saved within the this directory


	file { "${jira_path}/${jira_file}":
		ensure  => 'present',
		source  => "puppet:///modules/jira/${jira_file}",
		mode 	=> 755,			  		  # script equivalent of chmod a+x 
		require => File ["${jira_path}"]  # ensuring the file exists if not find the source
	}
		
	exec { "install jira":
		cwd 	=> "${jira_path}",
		command => "printf \"o\n2\n\n\n2\n8079\n8005\n\ny\n\" | ./${jira_file}", #automate the express/custom and change of ports
		onlyif	=> "[ ! -e /opt/atlassian/jira/uninstall ]", #type reference thing
		require => File ["${jira_path}/${jira_file}"]
	}
}