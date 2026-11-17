FROM debian:bookworm-slim

ARG REPO_PATH=networkupstools/nut.git

RUN apt-get update && apt-get install -y --no-install-recommends \
    git build-essential autoconf automake libtool pkg-config libusb-1.0-0-dev ca-certificates python3 \
    && git clone --depth 1 "https://github.com{REPO_PATH}" /src \
    && cd /src && ./autogen.sh \
    && ./configure --with-usb --with-user=root --with-group=root --prefix=/usr/local/ups --sysconfdir=/etc/nut --with-statepath=/var/run/nut \
    && make -j$(nproc) && make install \
    && mkdir -p /var/run/nut /etc/nut \
    && apt-get purge -y git build-essential autoconf automake libtool python3 \
    && apt-get autoremove -y && rm -rf /var/lib/apt/lists/* /src

ENV PATH="/usr/local/ups/bin:/usr/local/ups/sbin:${PATH}"
EXPOSE 3493
CMD ["sh", "-c", "upsdrvctl start && upsd -F"]
