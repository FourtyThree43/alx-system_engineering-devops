#!/usr/bin/env bash
# Script: 0-install_mysql.sh
# Description: Installs MySQL 5.7.x on web-01 and web-02 servers with user: root, passwd: root

# Check if the script is being run as root
if [[ $EUID -ne 0 ]]; then
	echo "This script must be run as root."
	exit 1
fi

# Function to install MySQL
install_mysql() {
	# Add the MySQL APT repository
	# Get key: https://dev.mysql.com/doc/refman/5.7/en/checking-gpg-signature.html
	# and save to file: 0-mysql_pubkey.asc
	echo "Downloading the GPG key from the public keyserver..."
	gpg --import 0-mysql_pubkey.asc
	apt-key add ~/.gnupg/pubring.kbx

	# Check if the MySQL 5.7 repository already exists
	if ! grep -q "deb http://repo.mysql.com/apt/ubuntu bionic mysql-5.7" /etc/apt/sources.list.d/mysql.list; then
		sudo sh -c 'echo "deb http://repo.mysql.com/apt/ubuntu bionic mysql-5.7" >> /etc/apt/sources.list.d/mysql.list'
	fi

	# Update package list and install MySQL Server
	apt-get update

	# Check the available MySQL Server 5.7 versions and use grep to filter the desired version
	desired_version=$(sudo apt-cache policy mysql-server | grep -oP '5\.7\.\d+-\d+ubuntu\d+\.\d+')

	# Install the desired version of MySQL Server 5.7.x
	apt-get install -yyy mysql-client="$desired_version" mysql-community-server="$desired_version" mysql-server="$desired_version"

	# Optional: Secure MySQL installation (uncomment the following lines if needed)
	# mysql_secure_installation

	echo "MySQL $desired_version installed successfully."
}

# Call the install_mysql function
install_mysql
