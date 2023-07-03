# Install Nginx package
package { 'nginx':
  ensure => installed,
}

# Replace Nginx default configuration
file { '/etc/nginx/nginx.conf':
  ensure  => file,
  source  => 'puppet:///modules/nginx/nginx.conf',
  require => Package['nginx'],
  notify  => Service['nginx'],
}

# Create a custom Nginx configuration file
file { '/etc/nginx/conf.d/custom_header.conf':
  ensure  => file,
  content => 'server {
                listen 80 default_server;
                listen [::]:80 default_server;
                server_name _;
                location / {
                  add_header X-Served-By $hostname;
                  root /var/www/html;
                  index index.html;
                }
              }',
  require => Package['nginx'],
  notify  => Service['nginx'],
}

# Restart Nginx service when configuration changes
service { 'nginx':
  ensure    => running,
  enable    => true,
  require   => Package['nginx'],
  subscribe => File['/etc/nginx/nginx.conf', '/etc/nginx/conf.d/custom_header.conf'],
}
