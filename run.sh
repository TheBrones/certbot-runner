#!/bin/bash
# Probably the worst script you have ever seen, feel free to improve :-)
currentDate=`date`
ERROR=0
echo
echo
echo "---------- Job started on $currentDate ----------"

# Load config
. /settings.conf

# Loop trough domainnames in file
for SITE in $(cat /domains.conf )
do
  echo ------------------- ${SITE} -------------------
  certbot certonly --standalone --preferred-challenges http --http-01-port 80 --renew-by-default --non-interactive --email $EMAIL --rsa-key-size 4096 $TOS -d $SITE 
  # Check for errors
  RESULT=$?
  if [ $RESULT -eq 0 ]; then
    echo Succesfully requested certificate.

    # Check if folder and certificate files exist. (Does not mean that the last run was succesful) && [ -d "/etc/letsencrypt/live/$SITE/fullchain.pem" ] && [ -d "/etc/letsencrypt/live/$SITE/privkey.pem" ];
    if [ -d "/etc/letsencrypt/live/$SITE/" ]; then
      # Cat files to make combined .pem files in the output folder.
      cat /etc/letsencrypt/live/$SITE/fullchain.pem /etc/letsencrypt/live/$SITE/privkey.pem > /output/$SITE.pem
      chown $RIGHTS /output/$SITE.pem
    else
      echo -e "\e[1;31mError finding certificate!\e[0m"  
      ERROR=1
    fi
    
  else
    echo -e "\e[1;31mError obtaining certificate!\e[0m"
    ERROR=1
  fi
done
echo '--------'
echo
echo "Finished requesting certificates"
echo "Execute configured action: $ACTION"
$ACTION
echo '--------'

# Determine exit code
if [ $ERROR -eq 0 ]; then
  # Actions
  echo "No errors detected"
  echo -e "Subject: Certbot-runner succesfuly requested one or more certificate(s)\n\Certbot-runner was succesful requesting certificate(s), see the logs for details." | msmtp $EMAIL
  echo '--------'
  echo "End of run"
  exit 0
else
  # This command adds a / in the body of the E-mail, how to solve?
  echo "Something went wrong, sending E-mail to warn!"
  echo -e "Subject: Certbot-runner encountered an error while renewing one or more certificate(s)\n\Certbot-runner encountered an error while renewing one or more certificate(s), see the logs for details." | msmtp $EMAIL
  echo '--------'
  echo "End of run"
  exit 1
fi
