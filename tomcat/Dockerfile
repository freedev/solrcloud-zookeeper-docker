FROM freedev/unix-utils

MAINTAINER Vincenzo D'Amore <v.damore@gmail.com>

# ADD tomcat.tar.gz /opt

RUN mkdir -p /opt/tomcat \
    && curl -SL http://archive.apache.org/dist/tomcat/tomcat-7/v7.0.72/bin/apache-tomcat-7.0.72.tar.gz \
    | tar -xz -C /opt/tomcat --strip-components=1

# COPY apache-tomcat-7.0.61 /opt/tomcat

RUN chown -R root:root /opt && mkdir -p /opt/config

EXPOSE 8080
