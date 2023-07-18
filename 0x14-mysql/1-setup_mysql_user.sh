#!/usr/bin/env bash
# Script: 1-setup_mysql_user.sh
# Description: Creates a MySQL user named "holberton_user" on web-01 and web-02 with the required privileges

# Check if the script is being run as root
if [[ $EUID -ne 0 ]]; then
	echo "This script must be run as root."
	exit 1
fi

# Function to set up MySQL user
setup_mysql_user() {
	# Set MySQL root password (modify it accordingly if not 'root')
	MYSQL_ROOT_PASS='root'

	# MySQL commands to create the user and grant required privileges
	mysql -uroot -p"${MYSQL_ROOT_PASS}" -e "CREATE USER 'holberton_user'@'localhost' IDENTIFIED WITH mysql_native_password BY 'projectcorrection280hbtn';"
	mysql -uroot -p"${MYSQL_ROOT_PASS}" -e "GRANT REPLICATION CLIENT ON *.* TO 'holberton_user'@'localhost';"
	mysql -uroot -p"${MYSQL_ROOT_PASS}" -e "FLUSH PRIVILEGES;"

	echo "MySQL user 'holberton_user' created and granted replication privileges."

	MYSQL_HBU_PASS='projectcorrection280hbtn'

	mysql -uholberton_user -p"${MYSQL_HBU_PASS}" -e "SHOW GRANTS FOR 'holberton_user'@'localhost'"
}

# Call the setup_mysql_user function
setup_mysql_user
