FROM freedev/java8

MAINTAINER Vincenzo D'Amore <v.damore@gmail.com>

RUN mkdir -p /opt/zookeeper \
    && curl -SL http://apache.mirrors.pair.com/zookeeper/zookeeper-3.4.6/zookeeper-3.4.6.tar.gz \
    | tar -xz -C /opt/zookeeper --strip-components=1 && chown -R root:root /opt/zookeeper

ADD start-server.sh /

RUN chmod +x /start-server.sh

ADD stop-server.sh /

RUN chmod +x /stop-server.sh

ADD kill-server.sh /

RUN chmod +x /kill-server.sh

CMD ["/start-server.sh"]

EXPOSE 2181 2888 3888
