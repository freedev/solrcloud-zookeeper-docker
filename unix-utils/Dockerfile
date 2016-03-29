FROM debian:jessie

MAINTAINER Vincenzo D'Amore <v.damore@gmail.com>

RUN \
  apt-get update && \
  apt-get install -y curl vim locales locales-all lsof less supervisor && \
  apt-get clean && \
  mkdir -p /var/log/supervisor && \
  locale-gen en_US en_US.UTF-8 && \
  dpkg-reconfigure locales && \
  echo "LC_ALL=en_US.UTF-8" > /etc/default/locale && \ 
  echo "LANG=en_US.UTF-8" >> /etc/default/locale && \ 
  rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8
