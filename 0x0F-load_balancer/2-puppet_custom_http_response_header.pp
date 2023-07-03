# Install Nginx package
package { 'nginx':
  ensure => 'installed',
}

# Configure Nginx with custom HTTP response header
file { '/etc/nginx/conf.d/custom_headers.conf':
  ensure  => 'file',
  owner   => 'root',
  group   => 'root',
  mode    => '0644',
  content => 'add_header X-Served-By $hostname;',
  notify  => Service['nginx'],
}

# Ensure Nginx service is running and enabled
service { 'nginx':
  ensure  => 'running',
  enable  => true,
  require => Package['nginx'],
}
