FROM ubuntu:latest
MAINTAINER u.seltmann@gmail.com
RUN apt-get update \
 && apt-get upgrade -y \
 && apt-get install -y software-properties-common
RUN apt-add-repository ppa:chris-lea/node.js \
 && apt-get update \
 && apt-get install -y nodejs python make g++ graphicsmagick
RUN npm install -g npm \
 && npm install -g pump.io databank-redis
RUN apt-get purge -y python make g++
ADD key /etc/ssl/private/key
RUN chmod 600 /etc/ssl/private/key
ADD crt /etc/ssl/certs/crt
RUN chmod 644 /etc/ssl/certs/crt
RUN groupadd -g 1000 app \
 && useradd -u 1000 -g 1000 -d /app -m app \
 && mkdir /app/uploads \
 && chown app:app /app -R
VOLUME [ "/app" ]
EXPOSE 31337
ADD pump.io.json /etc/
ADD docker/init /docker/init
RUN chmod a+x /docker/init
ENTRYPOINT [ "/docker/init" ]
