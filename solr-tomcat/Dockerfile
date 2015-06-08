FROM freedev/tomcat

MAINTAINER Vincenzo D'Amore <v.damore@gmail.com>

COPY conf /opt/tomcat/conf

COPY lib /opt/tomcat/lib

ADD setenv.sh /opt/tomcat/bin/

ADD start-server.sh /

RUN chmod +x /start-server.sh

ADD stop-server.sh /

RUN chmod +x /stop-server.sh

ADD kill-server.sh /

RUN chmod +x /kill-server.sh

ADD tomcat-users.xml /opt/tomcat/conf/

EXPOSE 8080 1616

CMD ["/start-server.sh"]
