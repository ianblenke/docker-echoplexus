FROM ubuntu:14.04
MAINTAINER ian@blenke.com

ENV DEBIAN_FRONTEND noninteractive
RUN apt-get update && \
    apt-get install -y build-essential python ruby git redis-server nodejs phantomjs npm supervisor && \
    gem install --no-rdoc --no-ri sass && \
    npm install -g coffee-script grunt grunt-cli supervisor bower testem browserify && \
    ln -sf /usr/bin/nodejs /usr/bin/node && \
    rm -fr /var/lib/apt/lists/*

ADD scripts/ /scripts
RUN chmod 755 /scripts/setup /scripts/init

RUN /scripts/setup

VOLUME ["/var/lib/redis"]

EXPOSE 5000

CMD ["/scripts/init"]
