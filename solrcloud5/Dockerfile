FROM freedev/java

MAINTAINER Vincenzo D'Amore <v.damore@gmail.com>

ADD http://it.apache.contactlab.it/lucene/solr/5.2.0/solr-5.2.0.tgz /opt/solr-5.2.0.tgz

RUN cd /opt && tar xzf /opt/solr-5.2.0.tgz

RUN mv /opt/solr-5.2.0 /opt/solr

RUN rm /opt/solr-5.2.0.tgz

RUN chown -R root:root /opt

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

# COPY *.jar /opt/solr-config/

EXPOSE 8080 1616

CMD ["/start-server.sh"]

