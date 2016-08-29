FROM alpine
MAINTAINER Lumos Labs <ops@lumoslabs.com>

ENV LANGUAGE=en_US.UTF-8 \
    LC_ALL=en_US.UTF-8 \
    LANG=en_US.UTF-8
RUN echo 'http://dl-cdn.alpinelinux.org/alpine/edge/testing/' >>/etc/apk/repositories \
    # && echo 'http://dl-cdn.alpinelinux.org/alpine/edge/main/' >>/etc/apk/repositories \
    && apk add --purge --update \
      alpine-sdk \
      bash \
      ca-certificates \
      libffi-dev \
      openssh \
      ruby \
      ruby-dev \
      ruby-json \
      sigar \
    && echo 'gem: --no-document' >>/root/.gemrc \
    && echo 'gem: --no-document' >>/etc/gemrc \
    && gem install chef --no-document \
    && gem install aws-sdk --no-document \
    && adduser -u 500 core -D \
    && apk del --purge alpine-sdk \
    && rm -rvf /var/cache/apk/*
