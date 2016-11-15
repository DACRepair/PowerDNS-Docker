FROM debian:jessie
MAINTAINER Derek Vance <dvance@cerb-tech.com>

ENV DEBIAN_FRONTEND noninteractive
ENV TZ "America/Detroit"

VOLUME "/data"

RUN apt-get update && apt-get -y install curl 
RUN echo "Acquire::Languages \" none\";\nAPT::Install-Recommends \"true\";\nAPT::Install-Suggests \"false\";" > /etc/apt/apt.conf
RUN echo $TZ > /etc/timezone && dpkg-reconfigure tzdata
RUN echo "deb http://repo.powerdns.com/debian jessie-auth-40 main" > /etc/apt/sources.list.d/pdns.list
RUN echo "Package: pdns-*\nPin: origin repo.powerdns.com\nPin-Priority: 600" > /etc/apt/preferences.d/pdns
RUN curl https://repo.powerdns.com/CBC8B383-pub.asc | apt-key add - &&
RUN apt-key update && apt-get update
RUN apt-get -y install pdns-server pdns-backend-mysql pdns-backend-sqlite3
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
  
ADD entrypoint.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/entrypoint.sh

CMD ["/usr/local/bin/entrypoint.sh"]

EXPOSE 53/udp 53/tcp
