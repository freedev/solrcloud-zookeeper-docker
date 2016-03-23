FROM freedev/solrcloud5-base

MAINTAINER Vincenzo D'Amore <v.damore@gmail.com>

ADD start-server.sh /

RUN chmod +x /start-server.sh

ADD stop-server.sh /

RUN chmod +x /stop-server.sh

ADD kill-server.sh /

RUN chmod +x /kill-server.sh

RUN mkdir -p /store/solr

RUN mkdir -p /opt/logs

RUN mkdir -p /opt/config

ADD solr.xml /opt/config/solr.xml

ADD log4j.properties /opt/config/log4j.properties

# COPY *.jar /opt/solr-config/

EXPOSE 8080 1616

CMD ["/start-server.sh"]

