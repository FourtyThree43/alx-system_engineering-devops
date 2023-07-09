#!/usr/bin/env bash
# This script installs Certbot and HAProxy, configures them, and starts the services.

set -euo pipefail

# Install required packages
install_packages() {
	local packages=("haproxy" "certbot")

	for package in "${packages[@]}"; do
		if ! command -v "$package" &>/dev/null; then
			echo "Installing package: $package"
			sudo apt-get update -qq
			sudo apt-get -qq install -y "$package"
		else
			echo "Package $package is already installed"
		fi
	done
}

# Configure Certbot and obtain SSL certificate
configure_certbot() {
    local domains=("fourtythree43.tech" "www.fourtythree43.tech")  # Replace with your own domain names

    echo "Configuring Certbot for domains: ${domains[*]}"

    # Check if Certbot is already running and stop it
    if pgrep -f "certbot" &>/dev/null; then
        echo "Stopping existing Certbot instance"
        sudo pkill -f "certbot"
        sleep 5  # Wait for Certbot process to stop gracefully
    fi

    # Configure Certbot and obtain SSL certificate
    sudo certbot certonly --standalone ${domains[@]/#/-d }
}

# Create or recreate the symbolic link
recreate_symbolic_link() {
	local cert_dir="/etc/haproxy/certs"
	local symbolic_link="/etc/haproxy/certs/www.fourtythree43.tech.pem"
	local cert_file="/etc/letsencrypt/live/fourtythree43.tech/fullchain.pem"

	if [ ! -d "$cert_dir" ]; then
		sudo mkdir -p "$cert_dir"
	fi

	if [ -L "$symbolic_link" ]; then
		echo "Symbolic link already exists: $symbolic_link. Removing..."
		sudo rm "$symbolic_link"
	fi

	echo "Creating new symbolic link: $symbolic_link"
	sudo ln -s "$cert_file" "$symbolic_link"
}

# Configure HAProxy
configure_haproxy() {
	local config_file="/etc/haproxy/haproxy.cfg"

	# Backup the current configuration file if backup doesn't exist
	if [ ! -f "${config_file}_$(date +%Y%m%d%H%M%S).backup" ]; then
		sudo mv "$config_file" "${config_file}_$(date +%Y%m%d%H%M%S).backup"
		echo "Backed up the current configuration file to ${config_file}_$(date +%Y%m%d%H%M%S).backup"
	fi

	sudo touch "$config_file"

	local server_config="
    global
        log /dev/log local0
        log /dev/log local1 notice
        chroot /var/lib/haproxy
        stats socket /run/haproxy/admin.sock mode 660 level admin
        stats timeout 30s
        user haproxy
        group haproxy
        daemon

        # Default SSL material locations
        ca-base /etc/ssl/certs
        crt-base /etc/ssl/private

        # Default ciphers to use on SSL-enabled listening sockets.
        # For more information, see ciphers(1SSL). This list is from:
        #  https://hynek.me/articles/hardening-your-web-servers-ssl-ciphers/
        # ssl-default-bind-options ssl-min-ver TLSv1.2 prefer-client-ciphers
        # ssl-default-bind-ciphersuites TLS_AES_128_GCM_SHA256:TLS_AES_256_GCM_SHA384:TLS_CHACHA20_POLY1305_SHA256
        # ssl-default-bind-ciphers ECDH+AESGCM:ECDH+CHACHA20:ECDH+AES256:ECDH+AES128:!aNULL:!SHA1:!AESCCM
        # ssl-default-server-options ssl-min-ver TLSv1.2
        # ssl-default-server-ciphersuites TLS_AES_128_GCM_SHA256:TLS_AES_256_GCM_SHA384:TLS_CHACHA20_POLY1305_SHA256
        # ssl-default-server-ciphers ECDH+AESGCM:ECDH+CHACHA20:ECDH+AES256:ECDH+AES128:!aNULL:!SHA1:!AESCCM
        # tune.ssl.default-dh-param 2048

        # See: https://ssl-config.mozilla.org/#server=haproxy&server-version=2.0.3&config=intermediate
        ssl-default-bind-ciphers ECDHE-ECDSA-AES128-GCM-SHA256:ECDHE-RSA-AES128-GCM-SHA256:ECDHE-ECDSA-AES256-GCM-SHA384:ECDHE-RSA-AES256-GCM-SHA384:ECDHE-ECDSA-CHACHA20-POLY1305:ECDHE-RSA-CHACHA20-POLY1305:DHE-RSA-AES128-GCM-SHA256:DHE-RSA-AES256-GCM-SHA384
        ssl-default-bind-ciphersuites TLS_AES_128_GCM_SHA256:TLS_AES_256_GCM_SHA384:TLS_CHACHA20_POLY1305_SHA256
        ssl-default-bind-options ssl-min-ver TLSv1.2 no-tls-tickets

    defaults
        log global
        mode http
        option httplog
        option dontlognull
        timeout connect 5000
        timeout client 50000
        timeout server 50000
        timeout http-request 50000
        errorfile 400 /etc/haproxy/errors/400.http
        errorfile 403 /etc/haproxy/errors/403.http
        errorfile 408 /etc/haproxy/errors/408.http
        errorfile 500 /etc/haproxy/errors/500.http
        errorfile 502 /etc/haproxy/errors/502.http
        errorfile 503 /etc/haproxy/errors/503.http
        errorfile 504 /etc/haproxy/errors/504.http

    frontend FT43-tech-frontend
        bind *:80
        mode http
        default_backend FT43-tech-backend

    frontend FT43-tech-frontend-https
        bind *:443 ssl crt /etc/haproxy/certs/www.fourtythree43.tech.pem
        http-request set-header X-Forwarded-Proto https
        default_backend FT43-tech-backend

    backend FT43-tech-backend
        balance roundrobin
        server 195416-web-01 54.160.120.200:80 check
        server 195416-web-02 54.145.155.255:80 check
    "

	echo "$server_config" | sudo tee "$config_file" >/dev/null
}

# Enable HAProxy service to start on boot
enable_haproxy_init() {
	sudo sed -i 's/ENABLED=0/ENABLED=1/' /etc/default/haproxy
}

# Start HAProxy service
start_services() {
	sudo service haproxy start
}

# Verify status of HAProxy service
verify_services_status() {
	if sudo service haproxy status | grep -q "active (running)"; then
		echo "HAProxy is running."
	else
		echo "HAProxy is not running."
	fi
}

# Main script execution
install_packages
configure_certbot
recreate_symbolic_link
configure_haproxy
enable_haproxy_init
start_services
verify_services_status
