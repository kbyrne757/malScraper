#!/usr/bin/env bash
#global vars

#formatting
RED='\033[0;31m' #red
GRN='\033[0;32m' #green
NC='\033[0m' #no colour 
bold=$(tput bold) #bold
normal=$(tput sgr0) #normal
Purple='\033[1;35m' #purple
Cyan='\033[1;36m' #cyan
Yellow='\033[1;33m' #yellow

#splash-text arrays
arr[0]=$(echo -e "\U0001F50E Generating list...")
arr[1]=$(echo -e "\U0001F50E Scraping data...")
arr[2]=$(echo -e "\U0001F50E Spinning web...")

#time-on-run
timestamp=$(date +%Y-%m-%d-%H:%M)

#data locations
PayloadReport=/home/$USER/Desktop/malScraper/PayloadReport.txt
AMPReport=/home/$USER/Desktop/malScraper/AMPReport.txt
C2Report=/home/$USER/Desktop/malScraper/C2Report.txt
Top100=/home/$USER/Desktop/malScraper/Top100.txt
HexReport=/home/$USER/Desktop/malScraper/HexReport.csv
HausMalDown=/home/$USER/Desktop/malScraper/HausMalDown.csv
PhishTank=/home/$USER/Desktop/malScraper/Phishing/PhishTank.csv

#pull random token from array
rand=$[$RANDOM % ${#arr[@]}]

#feed locations
PayloadFeed=$(base64 -d <<<"H4sIAHp5QF0AA8soKSkottLXLy3KyUgsLdZLTCotTtVLztBPyS/Py8lPTCnWL0mtKNHnAgCoVL2S
KQAAAA==" | gunzip)
C2Feed=$(base64 -d <<<"H4sIAMwQQ10AA0uuTEotSi7KzE3VLSlKTM5OLdLLSy3RT8zJ0SvIKOACAD03/gcfAAAA" | gunzip)
HexFeed=$(base64 -d <<<"H4sIACgpRF0AA8soKSmw0tcvKUpMzk4t0sswrtBLLdVPLMjUL84sSS2ON8zNzyvJ0CvIKOACAJtI
bs0rAAAA" | gunzip)
#Broken :( OpenPhish=$(base64 -d <<<"H4sIACJFXV0AA8soKSkottLXzy9IzSvIyCzO0EvOz9VPS01N0SupKOECAGyI4nkfAAAA" | gunzip)
PhishTank=$(base64 -d <<<"H4sIAHFCXV0AA8soKSmw0tdPSSxJ1CvIyCzOKEnMy9ZLzs8FC+nn5+Vk5qXqliXmZKboJReXcQEA
oid3DTAAAAA=" | gunzip)
HausMalDown=$(base64 -d <<<"H4sIAJqXXl0AA8soKSkottLXLy3KyUgsLdZLTCotTtVLztBPyS/Py8lPTCnWTy4u0+cCAON9198o
AAAA" | gunzip)

#functions
dirList() {
	printf "${GRN}${bold}Success - Files written to:\n${normal}${NC}"
	printf "${GRN}${bold}1. ${normal}${RED}${bold}Payload Domains:${normal}${NC}"
	printf "/home/$USER/Desktop/malScraper/${bold}PayloadReport.txt${normal}\n"
	printf "${GRN}${bold}2. ${normal}${RED}${bold}AMP Report:${normal}${NC}"
	printf "/home/$USER/Desktop/malScraper/${bold}AMPReport.txt${normal}\n"
	printf "${GRN}${bold}3. ${normal}${RED}${bold}C2 Servers:${normal}${NC}"
	printf "/home/$USER/Desktop/malScraper/${bold}C2Report.txt${normal}\n"
	printf "${GRN}${bold}4. ${normal}${RED}${bold}Hex Report:${normal}${NC}"
	printf "/home/$USER/Desktop/malScraper/${bold}HexReport.txt${normal}\n"
	printf "${GRN}${bold}5. ${normal}${RED}${bold}URLHaus Maldownloads:${normal}${NC}/home/$USER/Desktop/malScraper/${bold}HausMalDown.csv${normal}\n"
	printf "${GRN}${bold}6. ${normal}${RED}${bold}PhishTank Phishing Pages:${normal}${NC}/home/$USER/Desktop/malScraper/Phishing/${bold}PhishTank.csv${normal}\n"
	printf "${GRN}${bold}7. ${normal}${RED}${bold}Most Recent 100:${normal}${NC}"
	printf "/home/$USER/Desktop/malScraper/${bold}Top100.txt${normal}\n\n"
}

fullScan() {
	clear
	echo $(date)
	echo ${arr[$rand]}
	if test -f "$PayloadReport"; then
	rm /home/$USER/Desktop/malScraper/PayloadReport.txt
	#echo "Updating existing payload report..."
	fi
	if test -f "$AMPReport"; then
		rm /home/$USER/Desktop/malScraper/AMPReport.txt
		#echo "Updating existing AMP report..."
	fi
	if test -f "$C2Report"; then
		rm /home/$USER/Desktop/malScraper/C2Report.txt
		#echo "Updating existing AMP report..."
	fi
	if test -f "$HexReport"; then
		rm /home/$USER/Desktop/malScraper/Top100.txt
		#echo "Updating existing AMP report..."
	fi
	if test -f "$HexReport"; then
		rm /home/$USER/Desktop/malScraper/HexReport.csv
		#echo "Updating existing AMP report..."
	fi
	if test -f "$PhishTank"; then
		rm /home/$USER/Desktop/malScraper/Phishing/PhishTank.csv
		#echo "Updating existing AMP report..."
	fi
	if test -f "$HausMalDown"; then
		rm /home/$USER/Desktop/malScraper/HausMalDown.csv
		#echo "Updating existing AMP report..."
	fi

	printf "#############################################\n# C2 Servers Report sourced from http://cybercrime-tracker.net/ \n#############################################\n" >> /home/$USER/Desktop/malScraper/C2Report.txt
	#pull reports from feeds
	curl -s $C2Feed >> /home/$USER/Desktop/malScraper/C2Report.txt
	curl -s $HexFeed >> /home/$USER/Desktop/malScraper/HexReport.csv
	curl -s $PayloadFeed >> /home/$USER/Desktop/malScraper/PayloadReport.txt
	curl -# $HausMalDown >> /home/$USER/Desktop/malScraper/HausMalDown.csv
	wget -q -P /home/$USER/Desktop/malScraper/Phishing/ $PhishTank 
	cd /home/$USER/Desktop/malScraper/Phishing
	mv online-valid.csv PhishTank.csv
	cd /home/$USER/Desktop/malScraper/
	#strip domains of their http:// and www. headers for ez amp
	cat PayloadReport.txt | egrep -o "http://([^/]*)/" | sed -e 's/^http:\/\///g' | sed 's/www\./ /g' | sed 's/\/$/ /g' | sed 's/ //g' >> AMPReport.txt
	head -100 /home/$USER/Desktop/malScraper/PayloadReport.txt > /home/$USER/Desktop/malScraper/Top100.txt
	#sort temp1.txt | uniq > PayloadReport.txt
	#sort temp2.txt | uniq > AMPReport.txt
	#rm temp*
	#printf "\n"
	clear
	#presentation
	#figlet malScraper
	dirList
	#read -n 1 -s -r -p "Press any key to open Malware Domains..."
	#printf "\n"
	#prompt user & open report
	read -p "Which feed would you like to open?" option
	printf "\n"

	while [[ $option >=1 ]] || [[ $option <=7 ]]; do

		if [[ $option == "1" ]]
		then
			xdg-open /home/$USER/Desktop/malScraper/PayloadReport.txt
			userOptions
		
		elif [[ $option == "2" ]]
		then
			xdg-open /home/$USER/Desktop/malScraper/AMPReport.txt
			userOptions
		
		elif [[ $option == "3" ]]
		then
			xdg-open /home/$USER/Desktop/malScraper/C2Report.txt
			userOptions
		
		elif [[ $option == "4" ]]
		then
			xdg-open /home/$USER/Desktop/malScraper/HexReport.csv
			userOptions
		
		elif [[ $option == "5" ]]
		then
			xdg-open /home/$USER/Desktop/malScraper/HausMalDown.csv
			userOptions
		
		elif [[ $option == "6" ]]
		then
			xdg-open /home/$USER/Desktop/malScraper/Phishing/PhishTank.csv
			userOptions
		
		elif [[ $option == "7" ]]
		then
			xdg-open /home/$USER/Desktop/malScraper/Top100.txt
			userOptions
		
		else
			clear
			printf "${RED}${bold}Error: ${normal}${NC}Invalid Option.\n"
			dirList
			read -p "Which feed would you like to open?" option
		fi
	done
	userOptions
}

quickScan() {
	clear
	echo $(date)
	echo ${arr[$rand]}
	if test -f "$PayloadReport"; then
		rm /home/$USER/Desktop/malScraper/PayloadReport.txt
		#echo "Updating existing payload report..."
	fi
	if test -f "$AMPReport"; then
		rm /home/$USER/Desktop/malScraper/AMPReport.txt
		#echo "Updating existing AMP report..."
	fi
	if test -f "$C2Report"; then
		rm /home/$USER/Desktop/malScraper/C2Report.txt
		#echo "Updating existing AMP report..."
	fi
	if test -f "$HexReport"; then
		rm /home/$USER/Desktop/malScraper/Top100.txt
		#echo "Updating existing AMP report..."
	fi
	if test -f "$HexReport"; then
		rm /home/$USER/Desktop/malScraper/HexReport.csv
		#echo "Updating existing AMP report..."
	fi
	if test -f "$PhishTank"; then
		rm /home/$USER/Desktop/malScraper/Phishing/PhishTank.csv
		#echo "Updating existing AMP report..."
	fi
	if test -f "$HausMalDown"; then
		rm /home/$USER/Desktop/malScraper/HausMalDown.csv
		#echo "Updating existing AMP report..."
	fi

	curl -# $PayloadFeed >> /home/$USER/Desktop/malScraper/PayloadReport.txt
	head -100 /home/$USER/Desktop/malScraper/PayloadReport.txt > /home/$USER/Desktop/malScraper/Top100.txt 
	xdg-open /home/$USER/Desktop/malScraper/Top100.txt
	sleep 1
	printf "\n"
	userOptions
}

exit() {
	#close terminal
	read -p "Are you sure? (Y/N)" closeConf
	closeConf=${closeConf^^} #force user input to uppercase
	if [[ $closeConf == "Y" ]] || [[ $closeConf == "YES" ]]
	then
		echo -e "Bye... \U0001F44B\U0001F622"
		sleep .5
		wmctrl -c :ACTIVE:
	elif [[ $closeConf == "N" ]] || [[ $closeConf == "NO" ]]
		then
			printf "\n"
			userOptions
	else
		printf "${RED}${bold}Error - ${normal}${NC}invalid operation\n"
		helpText
		userOptions
	fi
}

userOptions() {
	read -p "malScraper>" option #store user input

	option=${option^^} #force user input to uppercase

	#track user input
	if [[ $option == "FULL" ]] || [[ $option == "FULL-SCAN" ]] || [[ $option == "FSCAN" ]]
	then
		fullScan
	elif [[ $option == "QUICK" ]] || [[ $option == "QUICK-SCAN" ]] || [[ $option == "QSCAN" ]]
		then
			quickScan
	elif [[ $option == "QUIT" ]] || [[ $option == "EXIT" ]]
		then
			exit
	elif [[ $option == "CLEAR" ]] || [[ $option == "CLEAR-HOST" ]] || [[ $option == "CLS" ]]
		then
			clearScreen
	elif [[ $option == "HELP" ]] || [[ $option == "GET-HELP" ]] || [[ $option == "?" ]] || [[ $option == "-?" ]] || [[ $option == "/?" ]] || [[ $option == "MENU" ]]
		then
			help
	elif [[ $option == "BACK" ]] || [[ $option == "CD .." ]] || [[ $option == "HOME" ]]
		then
			main
	elif [[ $option == "TUTORIAL" ]]
		then
			tutorial
	elif [[ $option == "OPEN" ]] || [[ $option == "OFEED" ]] || [[ $option == "-O" ]]
		then
			openReport
	elif [[ $option == "RECENT" ]] || [[ $option == "RHASH" ]] || [[ $option == "RH" ]]
		then
			mostRecentHash
	elif [[ $option == "VIRUSTOTAL" ]] || [[ $option == "VTREPORT" ]] || [[ $option == "VT" ]]
		then
			vtScan
	else
		printf "${RED}${bold}Error - ${normal}${NC}invalid operation\n"
		helpText
		userOptions
	fi
}

openReport() {
	echo -e "Go away you egg, this menu is unfinished. \U0001F620"
	sleep .5
	printf "\n"
	userOptions
}

setupHost() {
	#wmctrl -r :ACTIVE: -b add,maximized_vert,maximized_horz
	#create working dirs
	mkdir -p /home/$USER/Desktop/malScraper
	mkdir -p /home/$USER/Desktop/malScraper/Phishing
	#check if preRequisates are installed
	figlet=/usr/bin/figlet
	if test -f $figlet
	then
		#echo "Figlet is installed, continuing..."
		echo
	else 
		printf "Figlet not found on system, preparing to install...\n"
		sleep 2
		clear
		sudo apt-get install figlet
		clear
	fi
	wmctrl=/usr/bin/wmctrl
	if test -f $wmctrl
	then
		#echo "wmctrl is installed, continuing..."
		echo
	else 
		printf "\nwmctrl not found on system, preparing to install...\n"
		sleep 2
		clear
		sudo apt-get install wmctrl
		clear
	fi
	curlInst=/usr/bin/curl
	if test -f $curlInst
	then
		#echo "curl is installed, continuing..."
		echo
	else 
		printf "\ncurl not found on system, preparing to install...\n"
		sleep 2
		clear
		sudo apt-get install curl
		clear
	fi
	#echo "Pre-Requisates installed, loading UI!"
	#sleep 2
	#clear
	main
}

clearScreen() {
	clear
	userOptions
}

helpText() {
	printf "${Cyan}HELP MENU${NC} ${bold}::${normal} Available ${Yellow}options${NC} shown below:\n\n"
	printf "${bold}[*]${normal} ${Cyan}Tutorial${NC} of how to use this tool\t\t\t\t\t${Yellow}TUTORIAL${NC}\n"
	printf "${bold}[*]${normal} Show this ${Cyan}Help${NC} Menu\t\t\t\t\t\t\t${Yellow}HELP,GET-HELP,?,-?,/?,MENU${NC}\n"
	printf "${bold}[*]${normal} ${Cyan}Show options${NC} for this tool\t\t\t\t\t\t${Yellow}SHOW OPTIONS,SHOW,OPTIONS${NC}\n"
	printf "${bold}[*]${normal} ${Cyan}Clear${NC} screen\t\t\t\t\t\t\t${Yellow}CLEAR,CLEAR-HOST,CLS${NC}\n"
	printf "${bold}[*]${normal} Return to ${Cyan}Home${NC} Menu\t\t\t\t\t\t\t${Yellow}HOME,BACK,CD ..${NC}\n"
	printf "${bold}[*]${normal} ${Cyan}Quit${NC} malScraper\t\t\t\t\t\t\t${Yellow}QUIT,EXIT${NC}\n"
	printf "${bold}[*]${normal} Perform ${Cyan}Full-Scan${NC} (Note this may take some time)\t\t\t${Yellow}FULL,FULL-SCAN,FSCAN${NC}\n"
	printf "${bold}[*]${normal} Perform ${Cyan}Quick-Scan${NC} Most recent 100 Payload Domains\t\t\t${Yellow}QUICK,QUICK-SCAN,QSCAN${NC}\n"
	printf "${bold}[*]${normal} ${Cyan}Open existing${NC} previously generated report file\t\t\t${Yellow}OPEN,OFEED,-O${NC}\n"
	printf "${bold}[*]${normal} Print ${Cyan}MD5 Hash${NC} of most recently downloaded file\t\t\t${Yellow}RECENT,RHASH,RH${NC}\n"
	printf "${bold}[*]${normal} Generate a ${Cyan}VirusTotal${NC} report of most recently downloaded file\t${Yellow}VirusTotal,VTReport,VT${NC}\n\n"
}

help() {
	helpText
	userOptions
}

mostRecentHash() {
	clear
	cd /home/$USER/Downloads/
	mostRecent="$(ls -t | head -n1)"
	printf "${GRN}${bold}Most Recent Hash / Filename:\n${NC}"
	md5sum "$mostRecent"
	VTHash=$(md5sum $(ls -t | head -n1) | awk '{print $1}')#
	printf "\n"
	userOptions
}

vtScan() {
	VTAPIToken=63c74add1fbcb18cd03e860185b2716cc6f756071f698674d7ab125d5e38840d
	cd /home/$USER/Downloads/
	
	if [ "$VTAPIToken" == "" ] || [ "$VTAPIToken" == " " ]; then
		printf "${RED}ERROR:${NC} No API key detected. Fetch your API key from: https://www.virustotal.com/gui/user/<YOURUSERNAME>/apikey\n" #print the help menu to the screen
		exit 1 #force exit script
	fi
	
	printf "${bold}${GRN}--------------------------------\n${NC}${normal}"
	printf "${GRN}${bold}Downloads Folder Hash/Filename\n${normal}${NC}"
	printf "${bold}${GRN}--------------------------------\n${NC}${normal}"
	
	for file in *; do
		md5sum "$file"
	done | sed 's/  /+,/' | awk -F"+" '{print $1, $2, $3}' | sed 's/ ,/,/g'
	
	printf "${bold}${GRN}--------------------------------\n${NC}${normal}"
	printf "${GRN}${bold}Most Recent File:\n${NC}"
	md5sum "$mostRecent"
	printf "${bold}${GRN}--------------------------------\n${NC}${normal}"
	VTHash=$(md5sum $(ls -t | head -n1) | awk '{print $1}')
	printf "${GRN}${bold}VirusTotal Summary:\n${normal}${NC}"
	curl -A "Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:68.0) Gecko/20100101 Firefox/68.0" -s -X POST 'https://www.virustotal.com/vtapi/v2/file/report' --form apikey=$VTAPIToken --form resource=$VTHash | awk -F 'positives\":' '{printf "\nDetected Malicious by: " $2}' | awk -F ' ' '{print $1$2$3$6$7}' | sed 's|["}]||g' 
	printf "${bold}${GRN}--------------------------------\n${NC}${normal}"
	read -n 1 -s -r -p "Press any key to generate full VirusTotal Report..."
	printf "\n"
	printf "${GRN}${bold}Full VirusTotal Report:\n${normal}${NC}"
	curl -A "Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:68.0) Gecko/20100101 Firefox/68.0" -s -X POST 'https://www.virustotal.com/vtapi/v2/file/report' --form apikey=$VTAPIToken --form resource=$VTHash | sed 's|\},|\}\n|g' | column -t -s "," | sed 's/detected//g' | sed 's/version//g' | sed 's/"//g' | sed 's/"//g' | sed 's/{//g' | sed 's/://g' | sed 's/true//g' | sed 's/false//g' | sed 's/result//g' | sed 's/}//g' | sed 's/scans//g' | sed 's/null/NoResult/g' | sed 's/update//g' | sed 's/v //g' | sed 's/-- //g' | sed 's/AB //g' | sed 's/- //g' | sed 's/a //g' | sed 's/variant //g' | sed 's/of //g' | sed 's/( //g' | sed 's/eff //g' | sed 's/ )//g' | sed 's/) //g' | sed 's/(high //g' | sed 's/confidence) //g' | sed 's/ confidence)//g' | sed 's/of //g' | sed 's/(ai //g' | sed 's/score= //g' | sed 's/(A //g' | sed 's/(CLOUD //g' | sed 's/(W //g' | sed 's/confidence //g' | sed 's/ Malicious PE/Malicious PE/g' | sed 's/ PE/PE/g' | sed 's/[[:digit:]]\+\.//g' | sed 's/[0-9]//g' | sed 's/- //g' | sed 's/-- //g' | sed 's/ -//g'  | sed 's/v //g' | sed 's/AB //g' | column -t -s " " #| awk -F '{print $1}' #| sed 's/"//g' | sed 's/{//g' | sed 's/ /|/g'| sed 's/://g' | sed 's/detected//g' | sed 's/,//g' | sed 's/version//g' | sed 's/true//g' | sed 's/false//g' | sed 's/}//g' 
	#printf "\n"
	printf "\n"
	userOptions
}
tutorial() {
	echo -e "Go away you egg, this menu is unfinished. \U0001F620"
	sleep .5
	printf "\n"
	userOptions
}

main() {
	clear
	#force maximum window
	wmctrl -r :ACTIVE: -b add,maximized_vert,maximized_horz
	figlet malScraper

	printf "\t${Purple}Tool\t :: malScraper\n"
	printf "\tAuthor\t :: Ryan Monaghan\n"
	printf "\tTwitter\t :: @rynmonaghan\n"
	printf "\tGithub\t :: https://github.com/Ryan-Monaghan/malScraper\n"
	printf "\tBranch\t :: Experimental\n"
	printf "\tVersion\t :: 1.0\n\n${NC}"
	

	helpText
	userOptions
}

setupHost

#testing
#read -n 1 -s -r -p "Press any key to read report..."
#cat PayloadReport.txt
#was going to pull IP Addressed associated with domains, but made script runtime waaaay too long
#due to number of IPs that were being parsed through geoiplookup :(
#for domain in $(cat "AMPReport.txt"); do dig +short $domain | tr '\n' ' ' >> Blacklist.csv | geoiplookup $domain | awk 'NR==1{print ", " $5,$6,$7,$8}' >> Blacklist.csv ; done
