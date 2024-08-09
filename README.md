A Bash script designed for automated scanning, vulnerability analysis and credential gathering of vulnerable ports and services in a network.

The script performs the following operations:
- Receives a network range from the user and tests whether or not the range is valid.
- Asks the user to choose between a "basic" (stealth TCP + UDP port scan, as well as services) or a "full" NMAP scan (scans full port range with services, and includes vulnerability analysis).
- Scans the given network range and informs the user whether or not vulnerable ports and services (ftp, ssh, rdp, telnet) were located.
- Generates a CVE file if full scan was chosen and vulnerable services were found by applying Searchsploit on the vulnerabilities.
- Attempts to Brute Force vulnerable ports by using Hydra with either the user-given username and password lists, or with a default password list (set to use John the Ripper's list as default).
- Gives the user the option to go over the results.
- Saves the results in a designated and timestamped folder.
- Gives the user the option of whether or not they'd want to zip the designated folder. 


Notes:
Script was tested with Windows Server 2019, and Metasploitable Virtual Machines as a proof of concept.

<b>Full Script Run:</b>

![1](https://github.com/user-attachments/assets/a96ebead-b726-4cd7-bb0c-d870acd2637c)
![2](https://github.com/user-attachments/assets/b01dbf19-3423-4444-9f36-12140eba0418)
![3](https://github.com/user-attachments/assets/bed8c68a-5d1e-4c46-a252-35d1dfd4875e)

<b>Folder Contents:</b>

![4](https://github.com/user-attachments/assets/b3c745ff-0809-4762-821f-dc04d5539cb1)
![5](https://github.com/user-attachments/assets/54f26ded-2c04-470f-8b0d-e7ac80cfc0ab)
![6](https://github.com/user-attachments/assets/56b29f1c-6503-4553-8e1d-4bf7feaa39cd)

<b>Scan File Contents</b>

![7](https://github.com/user-attachments/assets/2f102224-d27e-4bc0-9740-ed1a96a539a2)
![8](https://github.com/user-attachments/assets/350cfffd-5069-4d43-8d7e-46239d1ac41f)
