FROM alpine:3.3
MAINTAINER Lumos Labs <ops@lumoslabs.com>

ENTRYPOINT ["/sbin/tini", "-g", "--", "/sbin/entry"]
ENV CHEF_LOGLEVEL=info \
    ETC_LINKS="passwd shadow group gshadow" \
    LANGUAGE=en_US.UTF-8 \
    LC_ALL=en_US.UTF-8 \
    LANG=en_US.UTF-8 \
    TINI_VERSION=v0.10.0
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
    && gem install chef mixlib-shellout chef-sugar --no-document \
    && gem install aws-sdk fog fog-aws --no-document \
    && adduser -u 500 core -D \
    && apk del --purge alpine-sdk \
    && rm -rvf /var/cache/apk/*
ADD https://github.com/krallin/tini/releases/download/${TINI_VERSION}/tini-static /sbin/tini
COPY ["entry", "runchef", "/sbin/"]
RUN chmod 0755 /sbin/tini /sbin/runchef /sbin/entry
CMD ["/sbin/runchef"]
