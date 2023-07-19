#!/usr/bin/env bash
# Script: add_public_key.sh
# Description: Copies the public key to web-01 and web-02 using ssh-copy-id

# hosts
WEB01='54.160.120.200'
WEB02='54.145.155.255'

# Check if the script is being run as root
if [[ $EUID -ne 0 ]]; then
	echo "This script must be run as root."
	exit 1
fi

# Check if a public key file is provided as an argument
if [[ $# -ne 1 ]]; then
	echo "Usage: $0 <PUBLIC_KEY_FILE>"
	exit 1
fi

# Ensure the Public key file exists
PUBLIC_KEY_FILE="$1"
if [[ ! -f "$PUBLIC_KEY_FILE" ]]; then
	echo "Error: Public key file '$PUBLIC_KEY_FILE' not found."
	exit 1
fi

# Function to add public key using ssh-copy-id
add_public_key() {
	SERVERS=("$WEB01" "$WEB02")

	for SERVER in "${SERVERS[@]}"; do
		echo "Copying public key to $SERVER..."
		ssh-copy-id -i "$PUBLIC_KEY_FILE" "$SERVER"
	done

	echo "Public key added to web-01 and web-02."
}

# Call the add_public_key function
add_public_key
