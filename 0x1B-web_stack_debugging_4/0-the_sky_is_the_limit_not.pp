# Puppet Manifest: 0-the_sky_is_the_limit_not.pp
# This manifest manages the ulimit configuration for Nginx and ensures the Nginx service is running.

class nginx_ulimit {

  # Set the ulimit value
  $ulimit_value = "-n 4096"

  # Define the exec resource to update the ulimit and restart Nginx
  exec { 'update_ulimit_and_restart_nginx':
    command     => "/bin/sed -i 's/^ULIMIT=.*/ULIMIT=\"$ulimit_value\"/' /etc/default/nginx",
    path        => '/bin:/usr/bin',
    refreshonly => true,
    before   => Exec['restart'],
  }

  exec {'restart':
    provider => shell,
    command  => 'sudo service nginx restart',
  }

  # Define a service resource to manage Nginx
  service { 'nginx':
    ensure    => running,
    enable    => true,
  }
}

include nginx_ulimit
