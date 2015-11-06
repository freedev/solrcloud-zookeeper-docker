FROM debian:jessie

MAINTAINER Vincenzo D'Amore <v.damore@gmail.com>

RUN \
  apt-get update && \
  apt-get install -y curl vim && \
  apt-get clean && \
  rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
