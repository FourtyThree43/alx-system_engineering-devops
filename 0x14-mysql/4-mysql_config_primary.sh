#!/usr/bin/env bash
# Script: 4-mysql_config_Primary.sh
# Description: Update MySQL Configuration on Primary Server

# Check if the script is being run as root
if [[ $EUID -ne 0 ]]; then
    echo "This script must be run as root."
    exit 1
fi

# Comment out bind-address to allow connections from remote hosts
sudo sed -i '/^bind-address/s/^/#/' /etc/mysql/mysql.conf.d/mysqld.cnf

# Check if the settings are already present in the config file
if grep -qE '^server-id\s*=\s*1' /etc/mysql/mysql.conf.d/mysqld.cnf && grep -qE '^log_bin\s*=\s*/var/log/mysql/mysql-bin.log' /etc/mysql/mysql.conf.d/mysqld.cnf && grep -qE '^binlog_do_db\s*=\s*tyrell_corp' /etc/mysql/mysql.conf.d/mysqld.cnf; then
    echo "MySQL configuration is already up to date. Skipping changes."
else
	# Update MySQL Configuration on Primary Server (appending after the commented out bind-address)
	cat <<EOF | tee -a /etc/mysql/mysql.conf.d/mysqld.cnf
# bind-address	= 127.0.0.1
server-id = 1
log_bin = /var/log/mysql/mysql-bin.log
binlog_do_db = tyrell_corp
EOF

    # Check if the MySQL restart process has any errors
    if service mysql restart; then
        echo "MySQL configuration updated successfully."
        # Copy the config file to ~/4-mysql_configuration_replica
        cp /etc/mysql/mysql.conf.d/mysqld.cnf ~/4-mysql_configuration_primary
    else
        echo "Failed to restart MySQL. Please check the MySQL error logs for more details."
    fi
fi
