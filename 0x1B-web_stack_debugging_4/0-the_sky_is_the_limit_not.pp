# Puppet Manifest: 0-the_sky_is_the_limit_not.pp
# This manifest manages the ulimit configuration for Nginx and ensures the Nginx service is running.

$ulimit_value = '-n 4096'

exec { 'update_ulimit':
  provider => shell,
  command  => "sudo sed -i 's/^ULIMIT=.*/ULIMIT=\"${ulimit_value}\"/' /etc/default/nginx",
  before   => Exec['restart_nginx'],
}

exec {'restart_nginx':
  provider  => shell,
  command   => 'sudo service nginx restart',
  subscribe => Service['nginx'],
}

service { 'nginx':
  ensure => running,
  enable => true,
}
