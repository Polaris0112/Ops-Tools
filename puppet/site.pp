$puppetserver = 'puppet-master.qtz.com'
node 'puppet-client.qtz.com'{
  include  motd
}
file
{ "/opt/test.txt":
source => "puppet://$puppetserver/files/test.txt",
owner => "puppet",
group => "puppet",
mode => 777,
}

