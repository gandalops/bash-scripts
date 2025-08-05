#!/bin/bash

# Author: Yogesh 		Date: 05th August 2025
# Script to create new user on the local system,
# You will be prompted to enter the username (login), the person name and a password
# The username, password, and host for the account will be displayed
#
clear
# validate root user
if [[ "${UID}" -ne 0 ]]; then
	echo "Login with root or sudo previleges"
	exit 1
fi

# take input from the user

read -p "Enter the username (login): " USER_NAME
read -p "Enter the name for person who will be using the account: " COMMENT
echo -e "\nhelp---"
echo -e "Password must be >= 8 characters consits of Upper, lower, numeric and speacial characters\n"
read -p "Enter password with above suggestions: " PASSWORD

# Create user
#useradd -c "${COMMENT}" -m ${USER_NAME} # This will give /bin/sh shell, to give different shell use
useradd -c "${COMMENT}" -s /bin/bash -m ${USER_NAME}
# Default shell defined in  /etc/default/useradd or sudo useradd -D | grep SHELL

# validate user creation
if [[ "${?}" -eq 0 ]]; then
	echo "User ${USER_NAME} created successfully"
	
	# set password
	echo "${USER_NAME}:${PASSWORD}" | chpasswd
	if [[ "${?}" -ne 0 ]]; then
		echo "Failed to set the password for the account"
		exit 2
	fi
	
	# force to change password
	passwd -e ${USER_NAME}
else
	echo "User '${USER_NAME}' is not created for some reasons"
	exit 3
fi
# Display the username, password, and the host where the user was created
echo
echo "Username: ${USER_NAME}"
echo "Password: ${PASSWORD}"
echo "Hostname: ${HOSTNAME}"
exit 0


# to remove created user, use
# sudo userdel -r "${USER_NAME}"
# To verify user deletion
# grep -E '${USER_NAME}' /etc/passwd

