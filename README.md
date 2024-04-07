A Bash script designed for automated scanning, vulnerability analysis and credential gathering of vulnerable ports and services in a network.

The script performs the following operations:
- Receives a network range from the user and tests whether or not the range is valid.
- Asks the user to choose between a "basic" (stealth FTP + UDP port scan, as well as services) or a "full" scan (also includes vulnerability analysis of services).
- Scans the given network range and informs the user whether or not vulnerable ports (tcp, ssh, rdp, telnet) or vulnerable services were located.
- Generates a CVE file if full scan was chosen and vulnerable services were found.
- Attempts to brute force vulnerable ports with either the user-given user and password lists, or with a default password list (uses John the Ripper's list as default).
- Gives the user the option to go over the results.
- Saves the results in a designated and timestamped folder.
- Gives the user the option of whether or not they'd want to zip the designated folder. 
