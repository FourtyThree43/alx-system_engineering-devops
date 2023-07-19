#!/usr/bin/env bash
# Script: 2-execute_sql_script.sh
# Description: Executes a SQL script to create the replica_user with appropriate replication permissions

# Check if the script is being run as root
if [[ $EUID -ne 0 ]]; then
	echo "This script must be run as root."
	exit 1
fi

# Check if a SQL script file is provided as an argument
if [[ $# -ne 1 ]]; then
	echo "Usage: $0 <user> <sql_script>"
	exit 1
fi

# Ensure the SQL script file exists
sql_script="$1"
if [[ ! -f "$sql_script" ]]; then
	echo "Error: SQL script '$sql_script' not found."
	exit 1
fi

# Function to execute the SQL script to set up replication user and grant privileges
execute_sql_script() {
    local user="$1"
    local mysql_pass=

    # Set the MySQL password based on the specified user
    if [[ "$user" == "root" ]]; then
        mysql_pass='root'
    elif [[ "$user" == "holberton_user" ]]; then
        mysql_pass='projectcorrection280hbtn'
    else
        echo "Error: Invalid user. Supported users: root or holberton_user."
        exit 1
    fi

    # Execute the SQL script using the MySQL client
    mysql -u"$user" -p"$mysql_pass" <"$sql_script"
}

# Call the setup_replication_user function
execute_sql_script
