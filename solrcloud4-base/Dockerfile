FROM freedev/solr-tomcat

MAINTAINER Vincenzo D'Amore <v.damore@gmail.com>

ADD http://www.eu.apache.org/dist/lucene/solr/4.10.4/solr-4.10.4.tgz /opt/solr-4.10.4.tgz

RUN cd /opt && tar xvf /opt/solr-4.10.4.tgz

RUN mv /opt/solr-4.10.4/dist/solr-4.10.4.war /opt/tomcat/webapps/solr.war

RUN rm -rf /opt/solr-4.10.4*
