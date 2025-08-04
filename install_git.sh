#!/bin/bash

clear

#Log file path
LOG_FILE="/tmp/$(basename "$0")_$(date '+%F_%T').log"

#common function used in various place
INFO(){
    echo "$(date '+%F %T') : INFO      : ${*}" 
}

WARNING(){
    echo "$(date '+%F %T') : WARNING   : ${*}" 
}

ERROR(){
    echo "$(date '+%F %T') : ERROR     : ${*}" 
    exit "${2:-1}"
}
#------------------------------------------------------------------#
# Root check - no need to pass sudo
if [[ $(id -u) -ne 0 ]]; then
    WARNING "Run script with root or sudo privileges"
    exit 1
fi
#------------------------------------------------------------------#
DownloadPath="/root/Downloads"
mkdir -p ${DownloadPath} || ERROR "Failed to create ${DownloadPath}"

# Version input
read -rp "Enter the required Git Version (e.g., 2.45.0):: " reqGitVer 

# Version comparison function
if command -v git >> "${LOG_FILE}" 2>&1 ; then
    gitHostVer=$(git --version | awk '{print $NF}') >> "${LOG_FILE}" 2>&1 

    if [[ ${reqGitVer} == ${gitHostVer} ]] ; then
        INFO "Entered version ${reqGitVer} is already deployed on the host"
        exit 0      # Exiting with success
        
    elif [[ ${reqGitVer} < ${gitHostVer} ]] ; then
        WARNING "Requested version (${reqGitVer}) is older than installed version (${gitHostVer})"      
    fi
fi

INFO "Your required Git version is: ${reqGitVer}"
#------------------------------------------------------------------#
INFO "Installing dependencies..............."
# Dependency packages install, and silence the output
apt-get update >> "${LOG_FILE}" 2>&1 || ERROR "Failed to update packages" 
apt-get install -y libcurl4-openssl-dev libexpat-dev gettext libssl-dev zlib1g-dev gcc make libperl-dev >> "${LOG_FILE}" 2>&1 || ERROR "Dependency installation failed" 

#------------------------------------------------------------------#
### Git Source Download (wget)
cd ${DownloadPath} || ERROR "Failed to enter ${DownloadPath}" 
INFO "Downloading git-${reqGitVer}.tar.gz.............."
wget -q https://mirrors.edge.kernel.org/pub/software/scm/git/git-${reqGitVer}.tar.gz >> "${LOG_FILE}" 2>&1 || ERROR "Failed to download git-${reqGitVer}.tar.gz" 

#------------------------------------------------------------------#
###  Extraction 
INFO "Extracting git-${reqGitVer}.tar.gz.............."
tar xvzf "git-${reqGitVer}.tar.gz" >> "${LOG_FILE}" 2>&1  || ERROR "Failed to extract archive git version ${reqGitVer}" 

#------------------------------------------------------------------#
cd git-${reqGitVer} || ERROR "Failed to enter git-${reqGitVer}" 
#------------------------------------------------------------------#
# Compile and install
INFO "Compiling git (this may take a while).............."
make prefix=/usr/local all >> "${LOG_FILE}" 2>&1 || ERROR "Compilation failed" 

### Installation
INFO "Installing git to /usr/local.............."
make prefix=/usr/local install >> "${LOG_FILE}" 2>&1 || ERROR "Installation failed" 
#------------------------------------------------------------------#
# Cleanup (optional)
INFO "Cleaning up.............."
rm -f "${DownloadPath}/git-${reqGitVer}.tar.gz"
#------------------------------------------------------------------#
### Removing Preinstalled Git 
apt-get remove -y git >> "${LOG_FILE}" 2>&1
#------------------------------------------------------------------#
### Verification 

if [[ $(git --version | awk '{print $NF}') == ${reqGitVer} ]] ; then
    INFO "Successfully installed your required git version ${reqGitVer}.............."  
else
    ERROR "Installed version not same as required git version ${reqGitVer}.............."  
fi
#------------------------------------------------------------------#
    

