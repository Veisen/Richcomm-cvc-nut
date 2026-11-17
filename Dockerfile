FROM debian:bookworm-slim

COPY nut-src /src

RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential autoconf automake libtool pkg-config libusb-1.0-0-dev python3 perl \
    && cd /src && ./autogen.sh \
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
    && apt-get purge -y build-essential autoconf automake libtool python3 \
    && apt-get autoremove -y && rm -rf /var/lib/apt/lists/* /src

ENV PATH="/usr/local/ups/bin:/usr/local/ups/sbin:${PATH}"
EXPOSE 3493
CMD ["sh", "-c", "upsdrvctl start && upsd -F"]
