FROM freedev/solr-tomcat

MAINTAINER Vincenzo D'Amore <v.damore@gmail.com>

ADD http://www.eu.apache.org/dist/lucene/solr/4.10.4/solr-4.10.4.tgz /opt/solr-4.10.4.tgz

RUN cd /opt && tar xvf /opt/solr-4.10.4.tgz

RUN mv /opt/solr-4.10.4/dist/solr-4.10.4.war /opt/tomcat/webapps/solr.war

RUN rm -rf /opt/solr-4.10.4*

RUN mkdir -p /opt/solr-config/

ADD solr.xml /opt/solr-config/

# COPY *.jar /opt/solr-config/

ADD start-server.sh /

RUN chmod +x /start-server.sh

CMD ["/start-server.sh"]

EXPOSE 8080 1616

