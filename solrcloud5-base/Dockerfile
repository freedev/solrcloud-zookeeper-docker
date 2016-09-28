FROM freedev/java8

MAINTAINER Vincenzo D'Amore <v.damore@gmail.com>

WORKDIR /opt

RUN mkdir -p /opt/solr \
    && curl -SL http://archive.apache.org/dist/lucene/solr/5.3.1/solr-5.3.1.tgz \
    | tar -xz -C /opt/solr --strip-components=1

