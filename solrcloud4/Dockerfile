FROM freedev/solrcloud4-base

MAINTAINER Vincenzo D'Amore <v.damore@gmail.com>

RUN mkdir -p /opt/config


ADD solr.xml /opt/config/

ADD start-server.sh /

RUN chmod +x /start-server.sh

CMD ["/start-server.sh"]

EXPOSE 8080 1616

