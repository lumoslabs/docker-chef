FROM alpine
MAINTAINER Lumos Labs <ops@lumoslabs.com>

ENV LANGUAGE=en_US.UTF-8 \
    LC_ALL=en_US.UTF-8 \
    LANG=en_US.UTF-8
RUN apk --repository http://dl-3.alpinelinux.org/alpine/edge/testing/ --update \
    && apk add --purge \
      alpine-sdk \
      bash \
      libffi-dev \
      openssh
      ruby \
      ruby-dev \
      ruby-json \
      shadow \
    && echo 'gem: --no-document' >>/root/.gemrc \
    && echo 'gem: --no-document' >>/etc/gemrc \
    && gem install chef --no-document \
    && gem install aws-sdk --no-document \
    && chef gem install aws-sdk \
    && apk del --purge alpine-sdk \
    rm -rf /var/cache/apk/*
