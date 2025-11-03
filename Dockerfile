FROM quay.io/centos/centos:latest

ENV unrealircd_version="6.2.1"

RUN echo fastestmirror=true >> /etc/dnf/dnf.conf

# Generic preparation layer
RUN rpm -i https://dl.fedoraproject.org/pub/epel/epel-release-latest-10.noarch.rpm && \
  dnf install -y 'dnf-command(config-manager)' && /usr/bin/crb enable && dnf upgrade -y --refresh && \
  dnf clean all

# Build dependency layer
RUN dnf install -y wget make file binutils gdb cmake-filesystem openssl-devel pcre2-devel libcurl-devel \
    automake gcc gcc-c++ diffutils pkgconf-pkg-config openssl pcre2-devel libargon2-devel libsodium-devel \
    c-ares c-ares-devel util-linux-core procps-ng && dnf clean all

# Unrealircd layer
RUN mkdir -p /app/unrealircd && \
  wget -O /app/unrealircd.tar.gz https://www.unrealircd.org/downloads/unrealircd-${unrealircd_version}.tar.gz && \
  cd /app/ && tar xfvz unrealircd.tar.gz

# Certbot layer
RUN dnf install -y python3-pip && dnf clean all && pip install --no-cache-dir certbot

COPY config.settings /app/unrealircd-${unrealircd_version}/

RUN cd /app/unrealircd-${unrealircd_version}/ && ./Config -quick && make && make install

RUN useradd -M irc && usermod -s /bin/bash irc && chown irc:irc -R /app/unrealircd 

USER irc

WORKDIR /app/unrealircd

CMD [ "bin/unrealircd", "-f", "./unrealircd.conf", "-F" ]

VOLUME /app/unrealircd/conf
VOLUME /app/unrealircd/conf/tls
VOLUME /app/unrealircd/logs

EXPOSE 6667/tcp
EXPOSE 6668/tcp
EXPOSE 6697/tcp
EXPOSE 7001/tcp
EXPOSE 8443/tcp
EXPOSE 8000/tcp
EXPOSE 8600/tcp
