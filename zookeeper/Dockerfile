FROM freedev/java8

MAINTAINER Vincenzo D'Amore <v.damore@gmail.com>

ADD http://apache.mirrors.pair.com/zookeeper/zookeeper-3.4.6/zookeeper-3.4.6.tar.gz /opt/zookeeper.tar.gz

RUN cd /opt && tar xzf /opt/zookeeper.tar.gz

RUN mv /opt/zookeeper-3.4.6 /opt/zookeeper

RUN rm /opt/zookeeper.tar.gz

RUN chown -R root:root /opt/zookeeper

ADD start-server.sh /

RUN chmod +x /start-server.sh

ADD stop-server.sh /

RUN chmod +x /stop-server.sh

ADD kill-server.sh /

RUN chmod +x /kill-server.sh

CMD ["/start-server.sh"]

EXPOSE 2181 2888 3888
