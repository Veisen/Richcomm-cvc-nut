FROM debian:bookworm-slim

RUN apt-get update && apt-get install -y --no-install-recommends curl gnupg ca-certificates \
    && curl -fsSL https://cloudsmith.io | gpg --dearmor -o /usr/share/keyrings/nut-devel.gpg \
    && echo "deb [signed-by=/usr/share/keyrings/nut-devel.gpg] https://cloudsmith.io bookworm main" > /etc/apt/sources.list.d/nut-devel.list \
    && apt-get update && apt-get install -y --no-install-recommends nut-server nut-client \
    && rm -rf /var/lib/apt/lists/*

EXPOSE 3493
CMD ["sh", "-c", "mkdir -p /var/run/nut && chown -R root:root /var/run/nut && upsdrvctl -u root start && upsd -u root -F"]
