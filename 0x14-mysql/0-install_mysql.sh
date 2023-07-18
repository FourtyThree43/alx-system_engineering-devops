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
	apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 5072E1F5
	echo "deb http://repo.mysql.com/apt/ubuntu $(lsb_release -sc) mysql-5.7" | tee /etc/apt/sources.list.d/mysql.list

	# Update package list and install MySQL Server
	apt-get update
	apt-get install -y mysql-server-5.7

	# Set root password
	mysql -uroot -e "ALTER USER 'root'@'localhost' IDENTIFIED WITH mysql_native_password BY 'root'; FLUSH PRIVILEGES;"

	# Optional: Secure MySQL installation (un/comment the following lines if needed)
	mysql_secure_installation

	echo "MySQL 5.7.x installed successfully."
}

# Call the install_mysql function
install_mysql
