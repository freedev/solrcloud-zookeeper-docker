FROM freedev/solr-tomcat

MAINTAINER Vincenzo D'Amore <v.damore@gmail.com>

WORKDIR /opt

RUN mkdir -p /opt/solr \
    && curl -SL http://www.eu.apache.org/dist/lucene/solr/4.10.4/solr-4.10.4.tgz \
    | tar -xz -C /opt/solr --strip-components=1 && \
    mv /opt/solr/dist/solr-4.10.4.war /opt/tomcat/webapps/solr.war && \
    rm -rf /opt/solr
