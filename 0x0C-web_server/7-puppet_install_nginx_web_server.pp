# Class: nginx
#
# This class installs and configures Nginx web server.
#
# Parameters:
#   None
#
class nginx {
  # Install Nginx package
  package { 'nginx':
    ensure => installed,
  }

  # Configure Nginx service
  service { 'nginx':
    ensure  => running,
    enable  => true,
    require => Package['nginx'],
  }

  # Create custom index HTML page
  file { '/var/www/html/index.html':
    ensure  => present,
    content => 'Hello World!',
    require => Package['nginx'],
  }

  # Configure Nginx server block
  file { '/etc/nginx/sites-available/default':
    ensure  => present,
    content => "
      server {
        listen 80 default_server;
        listen [::]:80 default_server;

        root /var/www/html;
        index index.html index.htm;

        location /redirect_me {
          return 301 https://www.youtube.com/watch?v=QH2-TGUlwu4;
        }

        location / {
          try_files $uri $uri/ =404;
        }
      }
    ",
    require => Package['nginx'],
    notify  => Service['nginx'],
  }
}

# Apply nginx class
include nginx
