FROM alpine:latest
RUN apk add --no-cache curl tar wget
RUN wget https://github.com/adnanh/webhook/releases/download/2.8.1/webhook-linux-amd64.tar.gz -O /tmp/webhook.tar.gz \
    && tar -tzf /tmp/webhook.tar.gz \
    && tar -xzf /tmp/webhook.tar.gz -C /tmp \
    && find /tmp/webhook-linux-amd64 -type f \
    && mv /tmp/webhook-linux-amd64/webhook /usr/local/bin/webhook \
    && rm -rf /tmp/webhook* \
    && chmod +x /usr/local/bin/webhook
EXPOSE 9000
ENTRYPOINT ["webhook", "-hooks=/hooks/hooks.json", "-verbose", "-hotreload"]
