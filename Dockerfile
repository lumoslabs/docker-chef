FROM alpine:3.3
MAINTAINER Lumos Labs <ops@lumoslabs.com>

ENV LANGUAGE=en_US.UTF-8 \
    LC_ALL=en_US.UTF-8 \
    LANG=en_US.UTF-8
RUN apk add --purge --update \
      alpine-sdk \
      bash \
      ca-certificates \
      libffi-dev \
      openssh \
      ruby \
      ruby-dev \
      ruby-json \
      ruby-nokogiri \
    && echo 'gem: --no-document' >>/root/.gemrc \
    && echo 'gem: --no-document' >>/etc/gemrc \
    && gem install chef mixlib-shellout --no-document \
    && gem install aws-sdk fog --no-document \
    && adduser -u 500 core -D \
    && apk del --purge alpine-sdk \
    && rm -rvf /var/cache/apk/*
