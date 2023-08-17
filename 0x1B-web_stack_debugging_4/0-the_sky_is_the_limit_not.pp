# Puppet Manifest: 0-the_sky_is_the_limit_not.pp
# This manifest manages the ulimit configuration for Nginx and ensures the Nginx service is running.

class nginx_ulimit {

  # Set the ulimit value
  $ulimit_value = "-n 4096"

  # Define the exec resource to update the ulimit and restart Nginx
  exec { 'update_ulimit_and_restart_nginx':
    provider => shell,
    command  => "sudo sed -i 's/^ULIMIT=.*/ULIMIT=\"$ulimit_value\"/' /etc/default/nginx",
    before   => Exec['restart'],
  }

  exec {'restart':
    provider    => shell,
    command     => 'sudo service nginx restart',
    subscribe   => Service['nginx'],
  }

  service { 'nginx':
    ensure    => running,
    enable    => true,
  }
}

include nginx_ulimit
