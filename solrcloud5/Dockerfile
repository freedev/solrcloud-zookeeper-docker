FROM freedev/solrcloud5-base

MAINTAINER Vincenzo D'Amore <v.damore@gmail.com>

RUN mkdir -p /store/solr

RUN mkdir -p /opt/bin

RUN mkdir -p /opt/logs

RUN mkdir -p /opt/config

ADD start-server.sh /opt/bin

ADD stop-server.sh /opt/bin

ADD kill-server.sh /opt/bin

RUN chmod +x /opt/bin/start-server.sh

RUN chmod +x /opt/bin/stop-server.sh

RUN chmod +x /opt/bin/kill-server.sh

ADD solr.xml /opt/config/solr.xml

ADD log4j.properties /opt/config/log4j.properties

EXPOSE 8080 1616

ADD supervisord.conf /etc/supervisor/conf.d/supervisord.conf

CMD ["/usr/bin/supervisord"]
