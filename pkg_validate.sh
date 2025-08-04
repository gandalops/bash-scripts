#!/bin/bash

# Date: 26th July 2025              #Author: Yogesh

#shell script to install pkgs like docker nginx ansible and so on
clear

# 1st - take pkg name from cmd line, if no pkg name provided then give help or usgae guidance
# 2nd validate if pkg exist, then display appropriate message
# if pkg not found then install it and tell pkg installed successful mgs 
# But before that make sure you are a root user
# handle if user doesnot provide any pkg name from cmd line
# handle a situation where user enter wrong pkg name like doker instead of docker, for this capture the exit status of the cmd
# You get error msg like "sudo: aptinstall: command not found" with echo $? = 1
#read -rp 'Enter the package name to install: ' pkgName
pkgName=${1}

#command -v ${pkgName} 1> /dev/null 2>&1 && echo "Your package ${pkgName} is already installed" || sudo apt install ${pkgName} -y 
#UID != 0 || { echo "please login with root crdentails"; exit1; }
#$# -ne 1 && { echo "Enter the pkgname you want to install"; echo "Usage: <scriptname> <pkgname>"; exit 1; }
# pkgExitstatus == 0 && echo "package is installed succesfully" || echo "pkg is not installed succesfully"

# Check UID
if [[ $EUID != 0 ]]; then
    echo "please login with root credentails"
    exit 1
fi

# Check arguments
if [[ $# -ne 1 ]]; then 
    echo "Enter one package name that you want to install"
    echo "Usage: <scriptname> <pkgname>"
    exit 2
fi

# Check pkg installation
if command -v "${pkgName}" 1> /dev/null 2>&1 
then
    echo "Package '${pkgName}' is already installed"
else
    echo "Installing package '${pkgName}'"
    apt install "${pkgName}" -y > err.log 2>&1
    pkgExitStatus=$?
    
    if [[ ${pkgExitStatus} != 0 ]]; then
        echo "'${pkgName}' Installation failed. See err.log for details:"
        cat err.log
        exit 3
    else 
        echo "'${pkgName}' package installed succesfully" 
    fi
fi

