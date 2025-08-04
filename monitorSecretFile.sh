#!/bin/bash

# Author: Yogesh        Date: 30 July 2025
# Script to monitor secret files and send email alerts when delted

clear
SecretFile="/home/path/to/secret/file/location/db.pass"
mailTo="recipent@mail.com"
ECHO=$(which echo)
MSMTP=$(which MSMTP)
DATE=$(which date)


# Validate if file is available 
if [[ ! -e ${SecretFile} ]] ; then
    ${ECHO} -e "File does not exists in given location\n"
    ${ECHO} -e "From: your-email@example.com\n\
To: ${mailTo}\n\
Subject: Alert: Secret file deleted on host: ${HOSTNAME}\n\n\
The secretfile '${SecretFile}' is deleted on the host: ${HOSTNAME} at $(${DATE} '+%F %T')\n" | \
${MSMTP} --read-envelope-from ${mailTo}
fi
#------------------------------------------------------------------------------#

for (( ;; ))
do
    sleep 60
    if [[ ! -e ${SecretFile} ]] ; then
        echo -e "File does not exists in given location\n"
        echo -e "From: your-email@example.com\n\
    To: ${mailTo}\n\
    Subject: Alert: Secret file deleted on the host: ${HOSTNAME}\n\n\
    The secretfile '${SecretFile}' is deleted on the host: ${HOSTNAME} at $(date '+%F %T')\n" | \
    msmtp --read-envelope-from ${mailTo}
fi
#------------------------------------------------------------------------------#


