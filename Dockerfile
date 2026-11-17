FROM alpine:edge

RUN apk add --no-cache --repository=http://alpinelinux.org nut

EXPOSE 3493
CMD ["sh", "-c", "mkdir -p /var/run/nut && upsdrvctl -u root start && upsd -u root -F"]
