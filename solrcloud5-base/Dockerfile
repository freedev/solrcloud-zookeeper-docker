FROM freedev/java8

MAINTAINER Vincenzo D'Amore <v.damore@gmail.com>

ADD http://www.eu.apache.org/dist/lucene/solr/5.2.0/solr-5.2.0.tgz /opt/solr-5.2.0.tgz

RUN cd /opt && tar xzf /opt/solr-5.2.0.tgz

RUN mv /opt/solr-5.2.0 /opt/solr

RUN rm /opt/solr-5.2.0.tgz

RUN chown -R root:root /opt

