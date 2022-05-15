# Certbot-Runner
Release 1.2

Certbot in a docker container that runs a http server to use as a reverse-proxy backend. 
This container needs to catch the challange from Let's Encrypt so a rule on the reverse-proxy is required.
This container is useful on bigger clusters with multiple proxy-servers.

# Components:
  - Certbot standalone.
  - Scheduled (cron) job to run certbot monthly.
  - Curl for executing actions to other systems.
  - rysnc for uploading certificates to other servers.
  - Msmtp for sending E-mail alerts when job fails.
  - Configurable actions to execute after succesful run to for example rsync the config and reload the configuration of the proxyserver(s) or do a POST request using curl.

# Setup:
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
RIGHTS='1000:1000'
ACTON='curl https://example.com/trigger && curl https://example.com/trigger '
```
E-mail parameter will be used for certbot and sending alerts.
The action parameter can be used to execute a command like curl, it will only execute if it did not detect any error's while running certbot.
Rights parameter is for setting the uid and gid of the output file, useful for setting it to www-data for example.

Output folder: /output/ for .pem files

Don't forget to add a file in the mount /etc/msmtprc for sending alerts. 
This file configures the msmtp service to send outbound mail.
```conf
account default
host mailserver.com
port 25
from "certificatealert@myserver.com"
logfile /var/log/msmtp.log
```

Final start command:
```start
docker run thebrones\certbot-runner
  -v /use/local/path/domains.conf:/domains.conf \
  -v /use/local/path/settings.conf:/settings.conf \
  -v /use/local/path/output:/output -p 80:80 \
  -v /use/local/path/msmtprc:/etc/msmtprc \
  -p 8080:80
```

Or with compose:
````compose
version: '3'
services:
  certbot-runner:
    image: thebrones/certbot-runner
    ports:
    - 8080:80
    volumes:
      - /use/local/path/domains.conf:/domains.conf
      - /use/local/path/settings.conf:/settings.conf 
      - /use/local/path/output:/output
      - /use/local/path/msmtprc:/etc/msmtprc 
````

Example HAProxy configuration:
````haproxy.conf
# Frontend part for forwarding traffic to certbot:
frontend http_front
   bind *:80
   acl acme-challenge path_beg /.well-known/acme-challenge/
   use_backend certbot if acme-challenge

# Backend part:
backend certbot
   server certbot-runner certbot-runner-ip:8080
# Note that there is no check, backend is only up for a few seconds at a time.

````

# Sources
  - https://hub.docker.com/r/certbot/certbot 
  - https://certbot.eff.org/docs/install.html#running-with-docker 
  - https://blog.knoldus.com/running-a-cron-job-in-docker-container/ 
  - https://owendavies.net/articles/setting-up-msmtp/