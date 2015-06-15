FROM freedev/java8

MAINTAINER Vincenzo D'Amore <v.damore@gmail.com>

WORKDIR /opt

RUN mkdir -p /opt/solr \
    && curl -SL http://www.eu.apache.org/dist/lucene/solr/5.2.1/solr-5.2.1.tgz \
    | tar -xz -C /opt/solr --strip-components=1

