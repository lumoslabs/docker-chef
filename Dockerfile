FROM ruby:2.3-alpine
MAINTAINER Lumos Labs <ops@lumoslabs.com>

ENTRYPOINT ["/sbin/tini", "-g", "--", "/sbin/entry"]
ENV CHEF_LOGLEVEL=info \
    ETC_LINKS="passwd shadow group gshadow" \
    LANGUAGE=en_US.UTF-8 \
    LC_ALL=en_US.UTF-8 \
    LANG=en_US.UTF-8 \
    TINI_VERSION=v0.10.0
RUN apk add --purge --update \
      bash \
      build-base \
      ca-certificates \
      libffi-dev \
      openssh \
    && echo 'gem: --no-document' >>/root/.gemrc \
    && echo 'gem: --no-document' >>/etc/gemrc \
    && adduser -u 500 core -D \
    && rm -rvf /var/cache/apk/*
COPY Gemfile* /
RUN bundle install --system --retry=2 --jobs=$(nproc)
ADD https://github.com/krallin/tini/releases/download/${TINI_VERSION}/tini-static /sbin/tini
COPY ["entry", "runchef", "/sbin/"]
RUN chmod 0755 /sbin/tini /sbin/runchef /sbin/entry
CMD ["/sbin/runchef"]
