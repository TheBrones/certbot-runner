#!/bin/bash
#Probaly the worst script you have ever seen, feel free to improve :-)
currentDate=`date`
echo
echo
echo "---------- Job started on $currentDate ----------"

#Load config
. /settings.conf

#EMAIL='example@gmail.com'
#TOS='--agree-tos --dry-run'

#Loop trough domainnames in file
for SITE in $(cat /domains.conf )

do
  # do something on $SITE #
  echo ------------------- ${SITE} -------------------
 
  # --dry-run
  #certbot certonly --standalone --preferred-challenges http --http-01-port 80 --renew-by-default \
  #--non-interactive --email $EMAIL --rsa-key-size 4096 $TOS -d $SITE 
  echo "E-mail = $EMAIL"
  echo "TOS = $TOS"
  
  RESULT=$?
  if [ $RESULT -eq 0 ]; then
    echo Success!
    echo 
    cd /etc/letsencrypt/live/$SITE/
    # Cat files to make combined .pem files.
    cat /etc/letsencrypt/live/$SITE/fullchain.pem /etc/letsencrypt/live/$SITE/privkey.pem > /output/$SITE.pem

  else
    echo -e "\e[1;31mError!\e[0m"
  fi
done

#Actions
echo "Execute action: $ACTION"
$ACTION
