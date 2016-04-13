class zabbix::install {

    Exec {
    path => ["/bin", "/usr/bin", "/usr/sbin", "/usr/local/sbin", "/sbin"]
    }

    package { "zabbix":
    ensure => installed
    }

    package { "zabbix-agent":
    ensure => installed
    }

    exec { "remove the original zabbix agent config":
    command => "rm /etc/zabbix/zabbix_agentd.conf",
    onlyif  => "grep -c 'Hostname=Zabbix server' /etc/zabbix/zabbix_agentd.conf"
    }->

    file {"/etc/zabbix/zabbix_agentd.conf":
    source  => "puppet:///modules/zabbix/zabbix_agentd.conf",
    owner   => "root",
    group   => "root",
    mode    => "0644",
    ensure  => "present",
    replace => false
    }->

#       file_line { "Update ois zabbix agent config":
#               line    => "Hostname=$hostname",
#               path    => "/etc/zabbix/zabbix_agentd.conf",
#               match   => "^Hostname=.*$",
#               ensure  => "present",
#               notify  => Service["zabbix-agent"]
#       }

    firewall { '202 allow communication with zabbix server':
    port    => [10050],
    proto   => tcp,
    action  => accept
    }

    service { 'zabbix-agent':
    ensure  => 'running',
    enable  => true,
    require => Package["zabbix-agent"]
    }

}
