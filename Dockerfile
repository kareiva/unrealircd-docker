FROM ubuntu:latest

ENV unrealircd_version="6.1.7.2"

RUN mkdir -p /app/unrealircd && \
  apt-get update && \
  apt-get install -y wget make binutils build-essential pkg-config gdb libssl-dev \
  libpcre2-dev libargon2-dev libsodium-dev libc-ares-dev libcurl4-openssl-dev && \
  wget -O /app/unrealircd.tar.gz https://www.unrealircd.org/downloads/unrealircd-${unrealircd_version}.tar.gz && \
  cd /app/ && tar xfvz unrealircd.tar.gz

COPY config.settings /app/unrealircd-${unrealircd_version}/

RUN cd /app/unrealircd-${unrealircd_version}/ && ./Config -quick && make && make install

RUN usermod -s /bin/bash irc && chown irc:irc -R /app/unrealircd 

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
