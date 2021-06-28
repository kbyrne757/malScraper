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

#function responsible for checking if requests module is installed before importing
def setupHost():
    package_name = "requests"
    spec = importlib.util.find_spec(package_name)
    if spec is None:
        print(package_name + " is not installed")
        print("Attempting install of " + package_name)
        sp.check_call([sys.executable, "-m", "pip", "install", package_name])
        sleep(2)
        import requests
        print("Import Succesful")
    else:
        import requests
        print("Import successful")



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
    sleep(2)
    opensesame.close()

    dirList()

def Help():
    print("help")


def helpText():
    print("\nHELP MENU     Available Options shown below\n")
    print("OPTION 1: Tutorial: How to use the program\n")
    print("OPTION 2: Help Menu \n")
    print("OPTION 3: Clear Screen\n")
    print("OPTION 4: Home Menu  \n")
    print("OPTION 5: Open an existing report\n")
    print("OPTION 6: Perform Full Scan Note this may take an extended period of time\n")
    print("OPTION 7: Perform Quick-Scan (Most Recent 100 payload Domains)\n")
    print("OPTION 0: Quit the program\n")
    userOptions(input())
    

def tutorial():
    print("tutorial")

def main():
    print("main")

def reOpen():
    print("reopen")
    
def userOptions(options):

    if (options == "1"):
        tutorial()

    elif (options == "2"):
        Help()
    
    elif (options == "3"):
        clearScreen()

    elif (options == "4"):
        main()

    elif (options == "5"):
        reOpen()

    elif (options == "6"):
        fullScan()

    elif (options == "7"):
        quickScan()
    
    elif (options == "0"):
        Exit()
        
    else:
        clearScreen()
        print("InVaLiD iNpUt")
        helpText()
        userOptions()

    
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

    
