FROM freedev/unix-utils

MAINTAINER Vincenzo D'Amore <v.damore@gmail.com>

RUN mkdir -p /opt/zookeeper \
    && mkdir -p /opt/bin \
    && curl -SL http://apache.mirrors.pair.com/zookeeper/zookeeper-3.4.6/zookeeper-3.4.6.tar.gz \
    | tar -xz -C /opt/zookeeper --strip-components=1 && chown -R root:root /opt/zookeeper

ADD start-server.sh /opt/bin

RUN chmod +x /opt/bin/start-server.sh

ADD stop-server.sh /opt/bin

RUN chmod +x /opt/bin/stop-server.sh

ADD kill-server.sh /opt/bin

RUN chmod +x /opt/bin/kill-server.sh

EXPOSE 2181 2888 3888

ADD supervisord.conf /etc/supervisor/conf.d/supervisord.conf

CMD ["/usr/bin/supervisord"]
