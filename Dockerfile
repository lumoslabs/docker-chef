FROM ruby:2.3-alpine
MAINTAINER Lumos Labs <ops@lumoslabs.com>

ENTRYPOINT ["/sbin/tini", "-g", "--", "chef-client"]
ENV LANGUAGE=en_US.UTF-8 \
    LC_ALL=en_US.UTF-8 \
    LANG=en_US.UTF-8 \
    TINI_VERSION=v0.10.0 \
    TZ=UTC
RUN apk add --purge --update \
      bash \
      build-base \
      ca-certificates \
      jq \
      libffi-dev \
      openssh \
    && echo 'gem: --no-document' >>/root/.gemrc \
    && echo 'gem: --no-document' >>/etc/gemrc \
    && adduser -u 500 core -D \
    && rm -rvf /var/cache/apk/*
COPY Gemfile* /
RUN NPROC=$(grep -c ^processor /proc/cpuinfo 2>/dev/null || 1) \
    && echo NPROC=${NPROC} \
    && bundle install --system --retry=2 --jobs=${NPROC}
ADD https://github.com/krallin/tini/releases/download/${TINI_VERSION}/tini-static /sbin/tini
