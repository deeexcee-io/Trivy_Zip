#!/bin/bash

red="\033[0;91m"
white="\033[0;97m"
NC="\033[0m"

printf "$red
 _____        _                   _____ _        
/__   \ _ __ (_)__   __ _   _    / _  /(_) _ __  
  / /\/| '__|| |\ \ / /| | | |   \// / | || '_ \ 
 / /   | |   | | \ V / | |_| |    / //\| || |_) |
 \/    |_|   |_|  \_/   \__, |   /____/|_|| .__/ 
                        |___/             |_|    $NC

${white}+-+-+-+  An ITHC Reporting Special  +-+-+-+${NC}"

sleep 1

printf "\n\n${white}Checking dependencies - all we need is jq to process the JSON and trivy to run the VulnScan${NC}\n"

sleep 0.5
if [ $(command -v jq) ] && [ $(command -v trivy) ]
then
        printf "\njq and trivy installed......nice one\n"
        sleep 1
elif [ ! $(command -v trivy) ]
then
        printf "\ntrivy is not installed. Please install trivy
                \nCheck this link https://aquasecurity.github.io/trivy/v0.32/getting-started/installation/ for installation instructions"
                sleep 2
                printf "\n\nPlease re-run once trivy is installed"
                #exit 1
else
        printf "\nno jq installed make program sad = (\nsudo apt install jq - do it now = )"
 #exit 1
exit 1
fi

#initial checks to see if there are zip files in the folder
#take all zip files, create directory and store new dirs in an array
zip_array=()

for zipFile in ./*.zip
        do
        subdir="${zipFile%.*}"
        #echo "$zipFile"
        if [ -e "$zipFile" ]
        then
                DIR="$subdir"
                mkdir -p "$DIR"
                mv "$zipFile" "$DIR"
                zip_array+=($subdir)
        else
                printf "\nNo zip files in folder"
                exit 1
        fi
done

sleep 1

newDir=trivyOutput
printf "\n\n+-+-+-+-+-+-+-+
        \nCreating Directory $newDir to store Vuln Scan info\n"

if [ -d ./$newDir ]
then
        printf "\n${white}\n$newDir folder exists, you have been here before!${NC}"
else
        printf "\n${white}Folder $newDir created\n\n${NC}"
        mkdir -p $newDir
fi

for d in ${zip_array[@]}
do
        (
        cd "$d"
        printf "\n+-+-+-+-+-+-+-+"
        printf "\nUnzipping $d.zip"
        sleep 0.5
        unzip *.zip > /dev/null 2>&1
        printf "\n+-+-+-+-+-+-+-+"
        printf "\nScanning $d with Trivy\n"
        sleep 0.5
        sudo trivy fs --no-progress -s MEDIUM,HIGH,CRITICAL -f json -o ../$newDir/$d.json .
        #vulns=$(grep -m 1 "Total:" ../$newDir/$d.txt)
        #printf "\n $red $vulns $NC\n"
        printf "\n\nConverting Output to .csv for eazeeeeeeee reporting"
        echo "VulnerabilityID,PkgName,InstalledVersion,FixedVersion,Title,Description,Severity" >> ../$newDir/$d.csv
        jq -r '.Results[].Vulnerabilities[] | [.VulnerabilityID, .PkgName, .InstalledVersion, .FixedVersion, .Title, .Description, .Severity] |@csv' ../$newDir/$d.json >> ../$newDir/$d.csv
        printf "\n$d done!"
        cd ..
        )
done

sleep 1

printf "\n\n+-+-+-+-+-+-+-+"
printf "\nAll ZIP Files have been extracted. csv files are saved in $newDir"
