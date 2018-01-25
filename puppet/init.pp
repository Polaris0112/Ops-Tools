class motd{
  package{ ['setup','ntp','iftop']:
    ensure => present,
  }
  file{'/tmp/test.txt':
    #path        =>'/tmp/test.txt',
    ensure      =>'link',
    owner       =>'root',
    mode        =>'0664',
    target      =>'/etc/fstab',
  }
  user {'puppet':
    ensure  =>present,
    gid     =>'666',
    uid     =>'666',
    shell   =>'/bin/bash',
    home    =>'/home/puppet',
    managehome  =>true,
  }
  service {'ntpd':
    ensure  =>running,
    enable  =>true,
  }
  exec { "/bin/echo root >> /usr/lib/cron/cron.allow":
    path => "/usr/bin:/usr/sbin:/bin",
    unless => "grep root /usr/lib/cron/cron.allow 2>/dev/null"
  }
  # Pull down the main aliases file 
  file { "/etc/aliases":
    source => "puppet://server/module/aliases"
  }
  # Rebuild the database, but only when the file changes 
  exec { newaliases:
    path => ["/usr/bin", "/usr/sbin"],
    subscribe => File["/etc/aliases"],
    refreshonly => true
  }

}



