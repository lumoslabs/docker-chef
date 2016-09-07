FROM alpine
MAINTAINER Lumos Labs <ops@lumoslabs.com>

ENTRYPOINT ["/usr/bin/tini", "-g", "--"]
ENV LANGUAGE=en_US.UTF-8 \
    LC_ALL=en_US.UTF-8 \
    LANG=en_US.UTF-8 \
    CHEF_LOGLEVEL=info
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
      tini \
    && echo 'gem: --no-document' >>/root/.gemrc \
    && echo 'gem: --no-document' >>/etc/gemrc \
    && gem install chef mixlib-shellout chef-sugar --no-document \
    && gem install aws-sdk fog fog-aws --no-document \
    && adduser -u 500 core -D \
    && apk del --purge alpine-sdk \
    && rm -rvf /var/cache/apk/*
ADD runchef /sbin/runchef
CMD ["/sbin/runchef"]
