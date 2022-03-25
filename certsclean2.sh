#!/bin/bash
#set -x 
echo "Displaying today's date
-----------------------------"
sleep 2
DATE=$(date '+%Y-%m-%dT%H:%M:%S+00:00')
             

echo 'Today's date is ----- $DATE ------

echo '
Collecting certs IDs and parsing them into json file.
-----------------------------------------------------------'
for c in $(aws acm list-certificates --query 'CertificateSummaryList[].CertificateArn' --output text)
do aws acm describe-certificate  --certificate-arn $c  --output json | jq --arg date $DATE -r '.| select(.Certificate.NotAfter <= $date ) | .Certificate.CertificateArn' >> certs2.json
echo "Processing $c"
#Looping through each line of certs2.json to collect arn of each cert and then deleting it
done 
while read line; do aws acm delete-certificate --certificate-arn $line --output text
done <certs2.json

#echo "Deleting certs2.json File"
#rm -rf certs2.json

echo "---------------------All Expired Certificates are deleted!-------------------------"
