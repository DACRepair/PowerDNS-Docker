FROM debian:jessie
MAINTAINER Derek Vance <dvance@cerb-tech.com>

ENV DEBIAN_FRONTEND noninteractive
ENV TZ "America/Detroit"

RUN \
  apt-get update && apt-get -y install curl ;\ 
  echo "Acquire::Languages \" none\";\nAPT::Install-Recommends \"true\";\nAPT::Install-Suggests \"false\";" > /etc/apt/apt.conf ;\
  echo $TZ > /etc/timezone && dpkg-reconfigure tzdata ;\
  echo "deb http://repo.powerdns.com/debian jessie-auth-40 main" > /etc/apt/sources.list.d/pdns.list ;\ 
  echo "Package: pdns-* ;\nPin: origin repo.powerdns.com ;\nPin-Priority: 600" ;\
  curl https://repo.powerdns.com/FD380FBB-pub.asc | sudo apt-key add - && ;\
  apt-get update && apt-get -y install pdns-server pdns-backend-mysql pdns-backend-sqlite3 ;\
  apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
  
ADD entrypoint.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/entrypoint.sh

CMD ["/usr/local/bin/entrypoint.sh"]

EXPOSE 53/udp 53/tcp
