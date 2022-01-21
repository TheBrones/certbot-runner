FROM ubuntu:latest
#FROM certbot/certbot

# Install cron, certbot, curl and msmtp for sending mail
RUN apt-get update && apt-get install -y certbot cron msmtp curl
RUN rm -rf /var/lib/apt/list

# Add scripts
ADD run.sh /run.sh
ADD runmanual.sh /runmanual.sh
ADD entrypoint.sh /entrypoint.sh

RUN chmod +x /run.sh /runmanual.sh /entrypoint.sh
RUN mkdir /output/

ENTRYPOINT /entrypoint.sh