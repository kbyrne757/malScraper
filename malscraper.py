#python v 3.9.5
import os
import getpass
from time import sleep
import subprocess as sp
import importlib.util
import sys
import zipfile
import random

#function to acquire username for directory listing
def getUser():
    username = getpass.getuser()
    return username

test = "https://python.org/"

#Default Directory locations for reports
PayloadReport = ("C:\\Users\\" + getUser() + "\\Downloads\\PayloadReport.txt")
AMPReport = ("C:\\Users\\" + getUser() + "\\Downloads\\AMPReport.txt")
C2Report = ("C:\\Users\\" + getUser() + "\\Downloads\\C2Report.txt")
Top100 = ("C:\\Users\\" + getUser() + "\\Downloads\\Top100Report.txt")
HexReport = ("C:\\Users\\" + getUser() + "\\Downloads\\HexReport.txt")
HausMalDown = ("C:\\Users\\" + getUser() + "\\Downloads\\HausMalDown")
PhishTank = ("C:\\Users\\" + getUser() + "\\Downloads\\PhishTank.csv")
tempFile = ("C:\\Users\\" + getUser() + "\\Downloads\\temp.zip")

#Feed Locations
PayloadFeed = "https://urlhaus.abuse.ch/downloads/text/"
C2Feed = "http://cybercrime-tracker.net/all.php"
HexFeed = "http://tracker.h3x.eu/api/sites_1month.php"
PhishTankFeed = "http://data.phishtank.com/data/online-valid.csv"
HausMalDownFeed = "https://urlhaus.abuse.ch/downloads/csv/"

#function for scan of one feed
def quickScan():
    opensesame = open(PayloadReport,"wb")
    req = requests.get(test)
    opensesame.write(req.content)
    print("Writing to file .....")
    sleep(5)
    opensesame.close()

    x = 99
    with open(PayloadReport,'r') as r1:
        data = r1.readlines()
    with open(Top100,'w') as f2:
        for line in data[:x]:
            f2.write(line)

        r1.close()
        f2.close()
        print("done")
        programName = "notepad.exe"
        fileName = Top100
        sp.Popen([programName, fileName])

#function for clearing screen
def clearScreen():
    os.system('cls')

#function for listing the directories
def dirList():
    print("Success - Files written to: \n")
    print("1.  Payload Domains:   " + PayloadReport + "\n") 
    print("2.  AMP Report:   " + AMPReport + "\n")
    print("3.  C2 Servers:   " + C2Report + "\n")
    print("4.  Hex Report:   " + HexReport + "\n")
    print("5.  URLHaus Maldownloads:     " + HausMalDown + "\n")
    print("6.  PhishTank Phishing Pages:   " + PhishTank + "\n")
    print("7.  Most Recent 100:   " + Top100 + "\n")

#function for full scan, pulls down from all feeds       
def fullScan():
    print("RIP Internet\n")


    req = requests.get(C2Feed)
    opensesame = open(C2Report, 'wb')
    opensesame.write(req.content)
    print("Stage 1 Complete - C2Report.......\n")
    opensesame.close()

    req = requests.get(HexFeed)
    opensesame = open(HexReport, 'wb')
    opensesame.write(req.content)
    print("Stage 2 Complete - HexReport.......\n")
    opensesame.close()
    
    req = requests.get(HausMalDownFeed)
    opensesame = open(tempFile, 'wb')
    opensesame.write(req.content)
    with zipfile.ZipFile(tempFile, 'r') as zip_ref:
        zip_ref.extractall(HausMalDown)
    opensesame.close()
    print("Stage 3 Complete - HausMaldown.......\n")
    os.remove(tempFile)
    
    req = requests.get(PhishTankFeed)
    opensesame = open(PhishTank, 'wb')
    opensesame.write(req.content)
    print("Stage 4 Complete - PhishTank.......\n")
    opensesame.close()

    opensesame = open(PayloadReport,"wb")
    req = requests.get(test)
    opensesame.write(req.content)
    print("Stage 5 Complete - PayloadReport........")
    sleep(5)
    opensesame.close()

    dirList()

def Help():
    print("help")


def helpText():
    print("HELP MENU     Available Options shown below\n")
    print("Tutorial: How to use the program   TUTORIAL\n")
    print("Show this help menu: HELP, GET-HELP, ?, MENU\n")
    print("Clear Screen: CLEAR, CLEAR-HOST, CLS\n")
    print("Return to Home Menu:      HOME, BACK\n")
    print("Open an existing report:    OPEN, REOPEN\n")
    print("Quit the program:            QUIT,EXIT\n")
    print("Perform Full Scan Note this may take ages: FULL, FULL-SCAN, FSCAN\n")
    print("Perform Quick-Scan (Most Recent 100 payload Domains):  QUICK, QUICK-SCAN, QSCAN\n")
    

def tutorial():
    print("tutorial")

def main():
    print("main")

def reOpen():
    print("reopen")
    
def userOptions():
    options = input()
    options = options.upper()
    print (options)

    if (options == "FULL") or (options == "FULL-SCAN") or (options == "FSCAN"):
        fullScan()

    elif (options == "QUICK") or (options == "QUICK-SCAN") or (options == "QSCAN"):
        quickScan()

    elif (options == "QUIT") or (options == "EXIT"):
        Exit()

    elif (options == "CLEAR") or (options == "CLEAR-HOST") or (options == "CLS"):
        clearScreen()

    elif (options == "HELP") or (options == "GET-HELP") or (options == "?") or (options == "MENU"):
        Help()

    elif (options == "BACK") or (options == "HOME"):
        main()

    elif (options == "TUTORIAL"):
        tutorial()

    elif (options == "REOPEN") or (options == "OPEN"):
        reOpen()

    else:
        clearScreen()
        print("Invalid Input")
        helpText()
        userOptions()


#function responsible for checking if requests module is installed before importing
def setupHost():
    package_name = "requests"
    spec = importlib.util.find_spec(package_name)
    if spec is None:
        print(package_name + " is not installed")
        print("Attempting install of " + package_name)
        sp.check_call([sys.executable, "-m", "pip", "install", package_name])
        import requests
        print("Import Succesful")
    else:
        import requests
        print("Import successful")
        

    
#function responsible for exiting the program    
def Exit():
    Question = input("Are you sure you want to exit?")
    Question = Question.upper()
    if (Question == "Y" ) or (Question == "YES"):
        clearScreen()
        quit()
    else:
        userOptions()
        
        
print("Passing through SetupHost first to check for modules......")
setupHost()
helpText()
userOptions()

Question = input("would you like to do a quickscan Y/N  ")
Question = Question.upper()
if (Question == "Y" ) or (Question == "YES"):
    quickScan()

elif (Question == "EXIT"):
    Exit()

else:
    fullScan()
    
