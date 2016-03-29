FROM freedev/solrcloud4-base

MAINTAINER Vincenzo D'Amore <v.damore@gmail.com>

RUN mkdir -p /opt/config

RUN mkdir -p /opt/bin

ADD solr.xml /opt/config/

ADD start-server.sh /opt/bin

ADD stop-server.sh /opt/bin

RUN chmod +x /opt/bin/start-server.sh

RUN chmod +x /opt/bin/stop-server.sh

EXPOSE 8080 1616

ADD supervisord.conf /etc/supervisor/conf.d/supervisord.conf

CMD ["/usr/bin/supervisord"]

