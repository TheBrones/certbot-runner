#!/bin/bash
# Probably the worst script you have ever seen, feel free to improve :-)
currentDate=`date`

# Load config
. /settings.conf

echo
echo "Please enter domain to request certificate"
read SITE

echo "---------- Manual job started on $currentDate ----------"

# Re-use code in loop:
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
    fi
    
  else
    echo -e "\e[1;31mError obtaining certificate!\e[0m"
  fi

echo '--------'
echo
echo "Finished requesting certificate manualy"

echo "Add domain to the domains-file for automatic renewal? y/n"
read RUNADD

if [ $RUNADD == "y" ]; then
  echo "Adding '$SITE' to domain file"
  echo $SITE >> /domains.conf
fi

echo "Run Actions? y/n"
read RUNACTIONS

if [ $RUNACTIONS == "y" ]; then
  echo
  echo "Execute configured action: $ACTION"
  $ACTION
  echo '--------'
  echo "End of run"
fi
exit 0