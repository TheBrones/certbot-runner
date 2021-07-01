#!/bin/bash
echo "Docker container has been started"

# Check all files
if test -f /settings.conf ; then
  . /settings.conf
else
  echo "No config file defined!"
  exit 1
fi

if test -f /domains.conf ; then
  :
else
  echo "No domains defined!"
  exit 1
fi

if test -f /etc/msmtprc ; then
  :
else
  echo "No msmtprc config defined!"
  exit 1
fi

# Setup a cron schedule
echo "* * * * * /run.sh >> /var/log/cron.log 2>&1 || msmtp -a $email
# This extra line makes it a valid cron" > scheduler.txt
crontab scheduler.txt

# Run and log
echo "" >> /var/log/cron.log
service cron start
tail -f /var/log/cron.log