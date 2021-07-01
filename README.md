# Certbot-Runner
Work in progress and not working yet!

Certbot in a docker container that runs a http server to use as a proxy backend. 
This container needs to catch the challange from Let's Encrypt so a rule on the proxy is required. 

#Components:
  - Certbot standalone.
  - Scheduled (cron) jobs to run everything.
  - Msmtp for sending E-mail alerts when job fails (also logged).
  - Actions, configurable actions to execute after succesful run to for example reload the configuration of the proxyserver(s). (not implemented)


#Setup:
This will need a file mounted with the certs to maintain "domains.conf".
```domains.conf
example.com
example2.com
```

Also mount a "settings.conf" file for setting the following options, take note of the TOS parameter. 
Will look for a way to put these in a env parameter soon.
```settings.conf
EMAIL='example@example.com'
TOS='--agree-tos --dry-run'
ACTON='curl https://example.com/trigger && curl https://example.com/trigger '
```
E-mail parameter will be used to certbot and sending alerts.
The action parameter can be used to execute a command like curl. 

Output folder: /output/ for .pem files

Don't forget to add a file in the mount /etc/msmtprc for sending alerts. 
This file configures the msmtp service to send outbound mail.
```conf
msmtprc
account default
host mailserver.com
port 25
from "certificatealert@myserver.com"
logfile /var/log/msmtp.log
```

Final start command:
docker run thebrones\certbot-runner
  -v /use/local/path/domains.conf:/domains.conf \
  -v /use/local/path/settings.conf:/settings.conf \
  -v /use/local/path/output:/output -p 80:80 \
  -v /use/local/path/msmtprc:/etc/msmtprc \
  -p 8080:80

# Sources
  - https://hub.docker.com/r/certbot/certbot 
  - https://certbot.eff.org/docs/install.html#running-with-docker 
  - https://blog.knoldus.com/running-a-cron-job-in-docker-container/ 
  - https://owendavies.net/articles/setting-up-msmtp/