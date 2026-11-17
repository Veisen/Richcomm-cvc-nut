FROM alpine:edge

RUN apk add --no-cache nut nut-usb

EXPOSE 3493
CMD ["sh", "-c", "mkdir -p /var/run/nut && chown -R root:root /var/run/nut && upsdrvctl -u root start && upsd -u root -F"]
