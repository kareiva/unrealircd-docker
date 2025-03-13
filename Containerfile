FROM registry.access.redhat.com/ubi9/ubi:9.5

ENV unrealircd_version="6.1.9.1"

RUN mkdir -p /app/unrealircd && \
  rpm -i https://dl.fedoraproject.org/pub/epel/epel-release-latest-9.noarch.rpm && \
  /usr/bin/crb enable && \
  dnf install -y wget make file binutils gdb cmake-filesystem openssl-devel pcre2-devel libcurl-devel \
    automake gcc gcc-c++ diffutils pkgconf-pkg-config pcre2-devel libargon2-devel libsodium-devel python3-pip && \
  rpm -i https://mirror.stream.centos.org/9-stream/BaseOS/x86_64/os/Packages/c-ares-1.19.1-2.el9.x86_64.rpm \
    https://mirror.stream.centos.org/9-stream/AppStream/x86_64/os/Packages/c-ares-devel-1.19.1-2.el9.x86_64.rpm && \
  wget -O /app/unrealircd.tar.gz https://www.unrealircd.org/downloads/unrealircd-${unrealircd_version}.tar.gz && \
  pip install certbot && cd /app/ && tar xfvz unrealircd.tar.gz

COPY config.settings /app/unrealircd-${unrealircd_version}/

RUN cd /app/unrealircd-${unrealircd_version}/ && ./Config -quick && make && make install

RUN useradd -M irc && usermod -s /bin/bash irc && chown irc:irc -R /app/unrealircd 

USER irc

WORKDIR /app/unrealircd

CMD [ "bin/unrealircd", "-f", "./unrealircd.conf", "-F" ]

VOLUME /app/unrealircd/conf
VOLUME /tls
VOLUME /app/unrealircd/logs

EXPOSE 6667/tcp
EXPOSE 6668/tcp
EXPOSE 6697/tcp
EXPOSE 7001/tcp
EXPOSE 8443/tcp
EXPOSE 8000/tcp
EXPOSE 8600/tcp
