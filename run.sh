#!/bin/bash
echo
echo
echo "Job started:"

#Load certificates
domains=(example.com)
domains=$(cat domains.conf)

#Load config
EMAIL=(example@gmail.com)
#   Add parameters
PAR(--agree-tos)

## get item count using ${domains[@]} ##

for SITE in "${domains[@]}"

do
  # do something on $SITE #
  echo ----------------------------------------------------
  echo Renewing ${SITE}:
 
  # --dry-run
  certbot certonly --standalone --preferred-challenges http --http-01-port 80 --renew-by-default \
  --non-interactive --email $EMAIL --rsa-key-size 4096 $PAR -d $SITE 
  
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


#Notifications?
#Email complete log file?



#Actions?
# Cron url?





