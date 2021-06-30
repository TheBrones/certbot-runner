# Certbot-Runner
Work in progress and not working yet!
Ideas are described below.

Certbot in a docker container that runs a http server to use as a proxy backend. 
This container needs to catch the challange from Let's Encrypt so a rule on the proxy is required. 

Components:
  - Certbot standalone
  - Scheduled (cron) jobs to run everything
  - Logging and alert notifications, how do we know that the job was succesfully?
  - Actions, configurable actions to execute after succesful run to for example reload the configuration of the proxyserver(s).

This will need a file mounted with the certs to maintain "domains.conf".
```domains.conf
example.com example2.com
```

Output folder: /output/ for .pem files

Config file for actions?
https://stackoverflow.com/questions/5983558/reading-a-config-file-from-a-shell-script



# Sources
https://hub.docker.com/r/certbot/certbot
https://certbot.eff.org/docs/install.html#running-with-docker
https://blog.knoldus.com/running-a-cron-job-in-docker-container/