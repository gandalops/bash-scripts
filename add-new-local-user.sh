#!/bin/bash

# Author: Yogesh 					Date: 05th August 2025
# Script to create new user on the local system,
# You will be prompted to enter the username (login), the person name and a password
# The username, password, and host for the account will be displayed
#----------------------------------------------------------------------------------
# Author: Yogesh 		version-0.1		Date:06th August 2025
# New requirements:
# 	1) Take username as argument to the script, anything afterthat as a comment for an account 
# 	2) Script should generate automatic passwords for an account
# 	3) Display the username, password and host for the account 
#----------------------------------------------------------------------------------
clear
# validate root user
if [[ "${UID}" -ne 0 ]]; then
	echo "Login with root or sudo previleges"
	exit 1
fi

# Validate arguments passsed
if [[ "${#}" -lt 1 ]]; then
	echo "Usage: ${0} USER_NAME [COMMENT]..."
	exit 2
fi

# Take the username
USER_NAME="${1}"

# Take the comment
shift
COMMENT="${@}"

# Create user
useradd -c "${COMMENT}" -s /bin/bash  -m "${USER_NAME}"

if [[ "$?" -ne 0 ]]; then
	echo "Failed to create user account"
fi

# Create Password
SPECIAL_CHAR=$(echo '~!@#$%^&*()_-=+`' | fold -w1 | shuf | head -c1)
PWD=$(date +%s%N | sha256sum | head -c48)
PASSWORD="${PWD}${SPECIAL_CHAR}"

if [[ "$?" -ne 0 ]]; then
        echo "Failed to create password"
fi

# Disply details
echo "Username: ${USER_NAME}"
echo "Actual Name: ${COMMENT}"
echo "Password: ${PASSWORD}"
echo "Hostname: ${HOSTNAME}"
exit 0
