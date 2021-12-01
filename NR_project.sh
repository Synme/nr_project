#!/bin/bash

#Introduction for the script

echo "You are about to be anonymized!"
echo "Checking for nipe package"
echo "loading..."

#Variables
nipe=$(ls | grep nipe)
openssh_client=$(apt list --installed 2>/dev/null | grep openssh-client | awk -F/ '{print $1}')
sshpass=$(apt list --installed 2>/dev/null | grep sshpass | awk -F/ '{print $1}')

#function to install openssh
function openssh()
{
	sudo apt-get install openssh-client
}

#function to install sshpass
function sshpass()
{
	sudo apt-get install sshpass
}

#function to install nipe
function install_nipe ()
{
	git clone https://github.com/htrgouvea/nipe && cd nipe
	sudo cpan install Try::Tiny Config::Simple JSON
	sudo perl nipe.pl install
}

#Checks if nipe is installed
#Spacing between "[" and the variables is important "]"
if [ "$nipe" == "nipe" ]
then
	echo -e " \n *** Great!!! Nipe installed ***"
else
	echo -e " \n *** Nipe package is not available here, proceeding for installation... *** \n"
	install_nipe
	echo -e " \n *** Great!!! Nipe installed ***"
fi

echo -en " \n Do you want to continue with nipe and become anonymous or quit? (c/q) "
read cont_nipe

if [ "$cont_nipe" == "q" ]
then
	echo -e " \n Thank you and BYE BYE! :( "
exit
else
	echo -e " \n Great choice!"
fi

echo -ne " \n [*] Please check your nipe status before we proceed to connect VPS. Make sure that you are *anonymous* before proceeding!!! \n Do you want to check the nipe status and activate it? (y/n) "
read proceed_vps

while true
do
if [ "$proceed_vps" == "n" ]
then
	echo -e " \n We will connect you to a VPS soon..."
break
fi
echo -e " \n [*]Please choose from the 4 options below: \n (1)Nipe Status \n (2)Start nipe \n (3)Stop nipe \n (4)Restart nipe"
echo -n "Enter option by number: " 
read option
	
case $option in

1)
	cd /home/kali/project/nipe
	sudo perl nipe.pl status
	;;
	
2)
	cd /home/kali/project/nipe
	sudo perl nipe.pl start
	sudo perl nipe.pl status
	;;
	
3)
	cd /home/kali/project/nipe
	sudo perl nipe.pl stop
	sudo perl nipe.pl status
	;;
	
4)
	cd /home/kali/project/nipe
	sudo perl nipe.pl restart
	sudo perl nipe.pl status
	;;
*)
	echo "Invalid entry!!! Please enter the option number you would like to proceed with..."
	;;
esac

echo -ne "[*]Do you want to perform other option before we proceed to connect VPS? Once again, please make sure that you are *anonymous* before proceeding :) (y/n)"
read proceed_vps

done

#Checks if openssh-client is installed
echo -e " \n Checking for openssh-client package"
echo "loading..."

if [ "$openssh_client" == "openssh-client" ]
then
	echo -e " \n *** Great!!! openssh-client installed ***"
else
	echo -e " \n *** Openssh-client package is not available here, proceeding for installation... *** \n"
	openssh
	echo -e " \n *** Great!!! openssh-client installed ***"
fi

#Checks if sshpass is installed
echo -e " \n Checking for sshpass package"
echo "loading..."

if [ "$sshpass" == "sshpass" ]
then
	echo -e " \n *** Great!!! sshpass installed ***"
else
	echo -e " \n *** sshpass package is not available here, proceeding for installation... *** \n"
	sshpass
	echo -e " \n *** Great!!! sshpass installed ***"
fi

echo -e "Please enter your VPS credential below: \n"
echo -n "Username: " 
read username
echo -n "IP address: " 
read ipaddress
echo -n "Password: " 
read password
echo -e " \n Connecting VPS..... \n"

#echo "sudo apt-get install nmap" 
#echo -e "\n *** Great! Nmap ready is available *** \n" 
#echo "sudo apt-get install whois" 
#echo -e "\n *** Great! whois ready is available ***" 
echo -n "Enter the IP address/range or domain name that you would like to scan: " 
read nmapip
echo -e "\n *** Please note that whichever IP/Domain you have input, the results will be accumulated in nmap.txt for the mmap results and whois.txt for domain lookup in your VPS \home\(username) directory *** \n"

#sudo sshpass -p $password ssh $username@$ipaddress 
sudo sshpass -p "$password" ssh $username@$ipaddress "nmap $nmapip | tee -a >> nmap.txt" 
sudo sshpass -p "$password" ssh $username@$ipaddress "whois $nmapip | tee -a >> whois.txt"
