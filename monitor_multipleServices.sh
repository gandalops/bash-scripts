#!/bin/bash

# Author: Yogesh        Date: 02 Aug 2025
# script to monitor service or services on host for every minute

clear

declare -a Services=("httpd" "nginx" "docker" "apache2" "python3")
#------------------------------------------------------------------------------#
ECHO=$(which echo)
DATE=$(which date)
MSMTP=$(which msmtp)
TEE=$(which tee)
DIRNAME=$(which dirname)

# Email details
#------------------------------------------------------------------------------#
RECIPIENT="recipent@mail.com"
SENDER="sender@mail.com"

# Log file path
#------------------------------------------------------------------------------#
LOGFILE="$(${DIRNAME} "$0")/serviceStatus.log"
${ECHO} -e "Script to check service status $(${DATE} '+%Y-%m-%d %H:%M:%S')" | ${TEE} -a ${LOGFILE}

# to check status of service on the host
#------------------------------------------------------------------------------#
# This block sends failed service email seperately

FAILED_SERVICES=()

for ServiceName in "${Services[@]}"
do
    # Check if service exists on the host 
    command -v "${ServiceName}" > /dev/null 2>&1
    if [[ $? -ne 0 ]]; then
        ${ECHO} -e "\nWARNING: Service '${ServiceName}' does not appear to be installed on '${HOSTNAME}'" | ${TEE} -a ${LOGFILE}
        continue
    fi

    # Check service status
    if systemctl is-active --quiet "${ServiceName}"; then
        ${ECHO} -e "\nService '${ServiceName}' is up and running on '${HOSTNAME}'" | ${TEE} -a ${LOGFILE}
    else
        ${ECHO} -e "\nERROR: Service '${ServiceName}' is not active on '${HOSTNAME}'" | ${TEE} -a ${LOGFILE}
        FAILED_SERVICES+=("${ServiceName}")
    fi
    sleep 1
    echo 
done

# After loop, send one combined email if there are failed services
if [ ${#FAILED_SERVICES[@]} -gt 0 ]; then
    
    SUBJECT="Service Status Alert: ${FAILED_SERVICES[*]} on ${HOSTNAME}"
    BODY="The following services are not running on '${HOSTNAME}' since $(${DATE} '+%Y-%m-%d %H:%M:%S'):\n\n"
    
    for svc in "${FAILED_SERVICES[@]}"; do
        BODY+="- ${svc}\n"
    done
    
    BODY+="\nPlease investigate\n\nThank You\nDummy Monitoring Team"

    ${ECHO} -e "From: ${SENDER}\nTo: ${RECIPIENT}\nSubject: [CRITICAL] ${SUBJECT}\n\n${BODY}" \
    | ${MSMTP} -t 2>&1 || { ${ECHO} "ERROR: Failed to send email alert!" | ${TEE} -a ${LOGFILE}; }
fi

echo -e "=================End of script=================" | ${TEE} -a ${LOGFILE}