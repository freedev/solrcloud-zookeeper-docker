FROM freedev/java

MAINTAINER Vincenzo D'Amore <v.damore@gmail.com>

# ADD tomcat.tar.gz /opt

ADD http://mirror.nohup.it/apache/tomcat/tomcat-7/v7.0.62/bin/apache-tomcat-7.0.62.tar.gz /opt/tomcat.tar.gz

RUN cd /opt && tar xzf /opt/tomcat.tar.gz

RUN mv /opt/apache-tomcat-7.0.62 /opt/tomcat

RUN rm /opt/tomcat.tar.gz

# COPY apache-tomcat-7.0.61 /opt/tomcat

RUN chown -R root:root /opt

EXPOSE 8080
