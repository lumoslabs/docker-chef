FROM ruby:2.3
MAINTAINER Lumos Labs <ops@lumoslabs.com>

ENTRYPOINT ["/sbin/tini", "-g", "--", "/sbin/entry"]
ENV CHEF_LOGLEVEL=info \
    DEBIAN_FRONTEND=noninteractive \
    ETC_LINKS="passwd shadow group gshadow" \
    TINI_VERSION=v0.10.0
RUN apt-get update \
    && apt-get install -y locales \
    && sed -i 's|# en_US.UTF-8|en_US.UTF-8|' /etc/locale.gen \
    && locale-gen --purge en_US.UTF-8 \
    && echo -e 'LANG="en_US.UTF-8"\nLANGUAGE="en_US:en"\n' > /etc/default/locale \
    && dpkg-reconfigure locales
ENV LANGUAGE=en_US.UTF-8 \
    LC_ALL=en_US.UTF-8 \
    LANG=en_US.UTF-8
RUN apt-get install -y --no-install-recommends \
      build-essential \
      ca-certificates \
    && echo 'gem: --no-document' >>/root/.gemrc \
    && echo 'gem: --no-document' >>/etc/gemrc \
    && useradd --uid 500 --no-create-home core
COPY Gemfile* /
RUN bundle install --system --retry=2 --jobs=$(nproc)
ADD https://github.com/krallin/tini/releases/download/${TINI_VERSION}/tini-static /sbin/tini
COPY ["entry", "runchef", "/sbin/"]
RUN chmod 0755 /sbin/tini /sbin/runchef /sbin/entry
CMD ["/sbin/runchef"]
