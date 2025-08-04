#!/bin/bash

#Script to show working of "at" cmd

clear

AWK=$(which awk || { echo "awk not found"; exit 1; })
CUT=$(which cut || { echo "cut not found"; exit 1; })
TR=$(which tr || { echo "tr not found"; exit 1; })
ECHO=$(which echo|| { echo "echo not found"; exit 1; } )
GIT=$(which git || { echo "git not found"; exit 1; })
DOCKER=$(which docker || { echo "docker not found"; exit 1; })
TERRAFORM=$(which terraform || { echo "terraform not found"; exit 1; })
ANSIBLE=$(which ansible || { echo "ansible not found"; exit 1; })
MSMTP=$(which msmtp || { echo "msmtp not found"; exit 1; })

# Log file setup
LOG_DIR="/home/av7579/linux/scripts/ud_scripts/cronjoblogs"
LOG_FILE="$LOG_DIR/sendDevOpsToolInfo.log"
mkdir -p "$LOG_DIR"

# Get versions
gitVersion=$(${GIT} -v | ${AWK} '{print $3}')
dockerVersion=$(${DOCKER} -v | ${AWK} '{print $3}' | ${TR} -d ',')
tfVersion=$(${TERRAFORM} -v | ${AWK} 'NR==1 {print $2}'| ${TR} -d 'v')
ansibleVersion=$(${ANSIBLE} --version | ${AWK} 'NR==1' | ${CUT} -d '[' -f2 | ${TR} -d ']' | ${AWK} '{print $2}')

${ECHO} -e "Script to give tools version"
${ECHO} "================================================="
${ECHO} -e "|\tToolName\t |\t Version\t|"
${ECHO} "================================================="
${ECHO} -e "|\tgit\t\t |\t ${gitVersion}\t\t|"
${ECHO} -e "|\tdocker\t\t |\t ${dockerVersion}\t\t|"
${ECHO} -e "|\tterraform\t |\t ${tfVersion}\t\t|"
${ECHO} -e "|\tansible\t\t |\t ${ansibleVersion}\t\t|" 
${ECHO} "================================================="



# HTML Content
HTML_CONTENT="
<html>
<head>
    <style>
        table {
            border-collapse: collapse;
            width: 50%;
            margin: auto;
        }
        th, td {
            border: 1px solid #dddddd;
            text-align: left;
            padding: 8px;
        }
        th {
            background-color: #f2f2f2;
        }
    </style>
</head>
<body>
    <h2>DevOps Tools Version Report</h2>
    <table>
        <tr>
            <th>ToolName</th>
            <th>Version</th>
        </tr>
        <tr>
            <td>git</td>
            <td>${gitVersion}</td>
        </tr>
                <tr>
            <td>docker</td>
            <td>${dockerVersion}</td>
        </tr>
        <tr>
            <td>terraform</td>
            <td>${tfVersion}</td>
        </tr>
        <tr>
            <td>ansible</td>
            <td>${ansibleVersion}</td>
        </tr>
    </table>
</body>
</html>
"
# Send Email with HTML
echo -e "Subject: DevOps Tools Version Report on host: ${HOSTNAME}\nMIME-Version: 1.0\nContent-Type: text/html\n\n$HTML_CONTENT" | ${MSMTP} youremail@mail.com