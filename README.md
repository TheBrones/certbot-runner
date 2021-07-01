# Certbot-Runner
Work in progress and not working yet!
Ideas are described below.

Certbot in a docker container that runs a http server to use as a proxy backend. 
This container needs to catch the challange from Let's Encrypt so a rule on the proxy is required. 

Components:
  - Certbot standalone
  - Scheduled (cron) jobs to run everything
  - Logging and alert notifications, how do we know that the job was succesfully? (not implemented)
  - Actions, configurable actions to execute after succesful run to for example reload the configuration of the proxyserver(s). (not implemented)

This will need a file mounted with the certs to maintain "domains.conf".
```domains.conf
example.com
example2.com
```

Also mount a "settings.conf" file for setting the following options, take note of the TOS parameter. 
```settings.conf
EMAIL='example@example.com'
TOS='--agree-tos --dry-run'
```

Output folder: /output/ for .pem files

Final start command:
-v /use/local/path/domains.conf:/domains.conf -v /use/local/path/settings.conf:/settings.conf -v /use/local/path/output:/output -p 80:80

Config file for actions?


# Sources
https://hub.docker.com/r/certbot/certbot 
https://certbot.eff.org/docs/install.html#running-with-docker 
https://blog.knoldus.com/running-a-cron-job-in-docker-container/ 