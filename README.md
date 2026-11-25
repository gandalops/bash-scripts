# bash-scripts

Small Bash scripts I wrote in July and August 2025 to practise Linux administration and automation on Debian-based systems.

## Scripts

| Script | What it does |
| --- | --- |
| add-local-user.sh | Creates a local user account. Prompts for the details and forces a password change at first login. |
| add-new-local-user.sh | Creates a local user account. Takes the username as an argument, treats the rest as a comment and generates a password. |
| install_git.sh | Installs git, with a root check and a log file. |
| pkg_validate.sh | Checks whether a package given on the command line is available on the host. |
| monitor_multipleServices.sh | Checks a list of services and sends an email alert through msmtp if one fails. |
| monitorSecretFile.sh | Sends an email alert if a monitored file is deleted. |
| attoolver.sh | Emails a report of installed DevOps tool versions. Written to practise the at command. |

## Notes

- These are practice scripts. Read them before running them as root.
- The email addresses in the scripts are placeholders. The mail scripts need msmtp to be configured.
- Commits come from two GitHub accounts on purpose. A second account acted as the developer, and this account acted as the central repository where I reviewed changes, to practise a team workflow.
