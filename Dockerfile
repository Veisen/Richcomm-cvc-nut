FROM debian:bookworm-slim

ADD https://github.com /tmp/nut.tar.gz

RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential autoconf automake libtool pkg-config libusb-1.0-0-dev python3 tar gzip \
    && mkdir -p /src && tar -xzf /tmp/nut.tar.gz -C /src --strip-components=1 \
    && cd /src && ./autogen.sh \
    && ./configure --with-usb --with-user=root --with-group=root --prefix=/usr/local/ups --sysconfdir=/etc/nut --with-statepath=/var/run/nut \
    && make -j$(nproc) && make install \
    && mkdir -p /var/run/nut /etc/nut \
    && apt-get purge -y build-essential autoconf automake libtool python3 \
    && apt-get autoremove -y && rm -rf /var/lib/apt/lists/* /src /tmp/nut.tar.gz

ENV PATH="/usr/local/ups/bin:/usr/local/ups/sbin:${PATH}"
EXPOSE 3493
CMD ["sh", "-c", "upsdrvctl start && upsd -F"]
