#!/bin/bash
#Probaly the worst script you have ever seen, feel free to improve :-)
currentDate=`date`
echo
echo
echo "---------- Job started on $currentDate ----------"

#Load config
. /settings.conf

#Loop trough domainnames in file
for SITE in $(cat /domains.conf )
do
  echo ------------------- ${SITE} -------------------
  certbot certonly --standalone --preferred-challenges http --http-01-port 80 --renew-by-default --non-interactive --email $EMAIL --rsa-key-size 4096 $TOS -d $SITE 
  # Check for errors
  RESULT=$?
  if [ $RESULT -eq 0 ]; then
    echo Succesfully requested certificate.

    # Check if folder and certificate files exist. (Does not mean that the last run was succesful)
    if [ -d "/etc/letsencrypt/live/$SITE/" ] && [ -d "/etc/letsencrypt/live/$SITE/fullchain.pem" ] && [ -d "/etc/letsencrypt/live/$SITE/privkey.pem" ]; then
      # Cat files to make combined .pem files in the output folder.
      cd /etc/letsencrypt/live/$SITE/
      cat /etc/letsencrypt/live/$SITE/fullchain.pem /etc/letsencrypt/live/$SITE/privkey.pem > /output/$SITE.pem
    else
      echo -e "\e[1;31mError merging certificate!\e[0m"  
      RESULT=1
    fi
    
  else
    echo -e "\e[1;31mError obtaining certificate!\e[0m"
  fi
done
echo
echo "Finished requesting certificates"

#Actions
echo "Execute configured action: $ACTION"
$ACTION

#Determine exit code
if [ $RESULT -eq 0 ]; then
  exit 0
else
  echo -e "Subject: Certbot-runner encountered an error while renewing one or more certificate(s)\n\ Certbot-runner encountered an error while renewing one or more certificate(s), see the logs for details." | msmtp $EMAIL
  exit 1
fi
