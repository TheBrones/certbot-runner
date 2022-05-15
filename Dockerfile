FROM ubuntu:21.10
#FROM certbot/certbot

# Install cron, certbot, curl, certbot and msmtp for sending mail
RUN apt update && apt upgrade -y
RUN apt install -y certbot cron msmtp rsync ssh curl

RUN rm -rf /var/lib/apt/list

# Add scripts
ADD run.sh /run.sh
ADD runmanual.sh /runmanual.sh
ADD entrypoint.sh /entrypoint.sh

RUN chmod +x /run.sh /runmanual.sh /entrypoint.sh
RUN mkdir /output/

ENTRYPOINT /entrypoint.sh