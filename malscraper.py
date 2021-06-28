#python v 3.9.5
import os
import getpass
from time import sleep
import subprocess as sp
import requests
import zipfile

#Requires requests package in order to work correctly
#python -m pip install requests



def getUser():
    username = getpass.getuser()
    return username


test = "https://python.org/"


PayloadReport = ("C:\\Users\\" + getUser() + "\\Downloads\\PayloadReport.txt")
AMPReport = ("C:\\Users\\" + getUser() + "\\Downloads\\AMPReport.txt")
C2Report = ("C:\\Users\\" + getUser() + "\\Downloads\\C2Report.txt")
Top100 = ("C:\\Users\\" + getUser() + "\\Downloads\\Top100Report.txt")
HexReport = ("C:\\Users\\" + getUser() + "\\Downloads\\HexReport.txt")
HausMalDown = ("C:\\Users\\" + getUser() + "\\Downloads\\HausMalDown")
PhishTank = ("C:\\Users\\" + getUser() + "\\Downloads\\PhishTank.txt")
tempFile = ("C:\\Users\\" + getUser() + "\\Downloads\\temp.zip")



#Feed Locations
PayloadFeed = "https://urlhaus.abuse.ch/downloads/text/"
C2Feed = "http://cybercrime-tracker.net/all.php"
HexFeed = "http://tracker.h3x.eu/api/sites_1month.php"
PhishTankFeed = "http://data.phishtank.com/data/online-valid.csv"
HausMalDownFeed = "https://urlhaus.abuse.ch/downloads/csv/"
#print("testing screenclear")


def quickScan():
    ## -> this only seems to work in cmd os.system('cls')
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




def dirList():
    print("Success - Files written to: \n")
    print("1.  Payload Domains:   " + PayloadReport + "\n") 
    print("2.  AMP Report:   " + AMPReport + "\n")
    print("3.  C2 Servers:   " + C2Report + "\n")
    print("4.  Hex Report:   " + HexReport + "\n")
    print("5.  URLHaus Maldownloads:     " + HausMalDown + "\n")
    print("6.  PhishTank Phishing Pages:   " + PhishTank + "\n")
    print("7.  Most Recent 100:   " + Top100 + "\n")

        
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


def userOptions():
    print("some options")

    
def Exit():
    Question = input("Are you sure you want to exit?")
    Question = Question.upper()
    if (Question == "Y" ) or (Question == "YES"):
        quit()
    else:
        userOptions()
        
    


Question = input("would you like to do a quickscan Y/N  ")
Question = Question.upper()
if (Question == "Y" ) or (Question == "YES"):
    quickScan()

elif (Question == "EXIT"):
      Exit()

else:
    fullScan()
    
