A Bash script designed for automated scanning, vulnerability analysis and credential gathering of vulnerable ports and services in a network.

The script performs the following operations:
- Receives a network range from the user and tests whether or not the range is valid.
- Asks the user to choose between a "basic" (stealth TCP + UDP port scan, as well as services) or a "full" scan (also includes vulnerability analysis of services).
- Scans the given network range and informs the user whether or not vulnerable ports (ftp, ssh, rdp, telnet) or vulnerable services were located.
- Generates a CVE file if full scan was chosen and vulnerable services were found.
- Attempts to brute force vulnerable ports with either the user-given user and password lists, or with a default password list (uses John the Ripper's list as default).
- Gives the user the option to go over the results.
- Saves the results in a designated and timestamped folder.
- Gives the user the option of whether or not they'd want to zip the designated folder. 


Notes:
Script was tested on the Metasploitable VM as a proof of concept.


![1](https://github.com/icon5730/Port_Buster/assets/166230648/80666bb8-eada-49a2-b910-6adc9d2d8eb5)
![2](https://github.com/icon5730/Port_Buster/assets/166230648/56817e39-42e5-4a96-b4bb-f9f210757782)
![3](https://github.com/icon5730/Port_Buster/assets/166230648/6b932205-4cdc-4c3b-be73-18599dc2d309)
![4](https://github.com/icon5730/Port_Buster/assets/166230648/7cfc068b-7a5a-418d-8cd8-c3b591466745)
![5](https://github.com/icon5730/Port_Buster/assets/166230648/67fc44af-edb7-4286-8681-6bd5821faef3)
![6](https://github.com/icon5730/Port_Buster/assets/166230648/bfdbec8e-5e35-4ac1-bca1-1df5f78eab71)
