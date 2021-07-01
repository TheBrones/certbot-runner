#!/bin/bash

# Start the run once job.
echo "Docker container has been started"

# Setup a cron schedule
echo "* * * * * /run.sh >> /var/log/cron.log 2>&1
# This extra line makes it a valid cron" > scheduler.txt
crontab scheduler.txt

#check files
if test -f /settings.conf ; then
  :
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


#run and log
echo "" >> /var/log/cron.log
service cron start
tail -f /var/log/cron.log