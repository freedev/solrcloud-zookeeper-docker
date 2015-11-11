FROM debian:jessie

MAINTAINER Vincenzo D'Amore <v.damore@gmail.com>

RUN \
  apt-get update && \
  apt-get install -y curl vim locales && \
  apt-get clean && \
  locale-gen en_US.UTF-8 && \
  rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8
