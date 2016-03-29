FROM freedev/tomcat

MAINTAINER Vincenzo D'Amore <v.damore@gmail.com>

COPY conf /opt/tomcat/conf

COPY lib /opt/tomcat/lib

RUN mkdir -p /opt/bin

ADD setenv.sh /opt/tomcat/bin/

ADD start-server.sh /opt/bin

RUN chmod +x /opt/bin/start-server.sh

ADD stop-server.sh /opt/bin

RUN chmod +x /opt/bin/stop-server.sh

ADD kill-server.sh /opt/bin

RUN chmod +x /opt/bin/kill-server.sh

ADD tomcat-users.xml /opt/tomcat/conf/

EXPOSE 8080 1616

ADD supervisord.conf /etc/supervisor/conf.d/supervisord.conf

CMD ["/usr/bin/supervisord"]
