FROM debian:bookworm-slim

ADD https://github.com /tmp/nut.tar.gz

RUN apt-get update && apt-get install -y --no-install-recommends \
    git build-essential autoconf automake libtool pkg-config libusb-1.0-0-dev python3 tar gzip \
    && mkdir -p /src && tar -xzf /tmp/nut.tar.gz -C /src --strip-components=1 \
    && cd /src && git init -q && ./autogen.sh \
    && ./configure \
        --prefix=/usr/local/ups \
        --sysconfdir=/etc/nut \
        --with-statepath=/var/run/nut \
        --with-user=root \
        --with-group=root \
        --with-usb \
        --without-serial \
        --without-snmp \
        --without-neon \
        --without-powerman \
        --without-modbus \
        --without-ipmi \
        --without-doc \
        --without-man \
    && make -j$(nproc) && make install \
    && mkdir -p /var/run/nut /etc/nut \
    && apt-get purge -y git build-essential autoconf automake libtool python3 \
    && apt-get autoremove -y && rm -rf /var/lib/apt/lists/* /src /tmp/nut.tar.gz

ENV PATH="/usr/local/ups/bin:/usr/local/ups/sbin:${PATH}"
EXPOSE 3493
CMD ["sh", "-c", "upsdrvctl start && upsd -F"]
