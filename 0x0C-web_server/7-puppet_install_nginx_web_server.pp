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

  # Create custom 404 HTML page
  file { '/var/www/html/404.html':
    ensure  => present,
    content => 'Ceci n\'est pas une page',
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

        error_page 404 /404.html;
        location = /404.html {
          return 404 'Ceci n\'est pas une page';
        }
      }
    ",
    require => Package['nginx'],
    notify  => Service['nginx'],
  }
}

# Apply nginx class
include nginx
