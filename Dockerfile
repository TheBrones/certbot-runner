FROM ubuntu:20.04
#FROM certbot/certbot

# Install cron
RUN apt-get update && apt-get install -y certbot cron 

# Add files
ADD run.sh /run.sh
ADD entrypoint.sh /entrypoint.sh

RUN chmod +x /run.sh /entrypoint.sh
RUN mkdir /output/

ENTRYPOINT /entrypoint.sh