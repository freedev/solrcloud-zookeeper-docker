FROM freedev/solrcloud4-base

MAINTAINER Vincenzo D'Amore <v.damore@gmail.com>

RUN mkdir -p /opt/solr-config/

ADD solr.xml /opt/solr-config/

# COPY *.jar /opt/solr-config/

ADD start-server.sh /

RUN chmod +x /start-server.sh

CMD ["/start-server.sh"]

EXPOSE 8080 1616

