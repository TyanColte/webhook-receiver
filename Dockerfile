FROM alpine:latest
RUN apk add --no-cache curl tar wget
RUN wget https://github.com/adnanh/webhook/releases/download/2.8.1/webhook-linux-amd64.tar.gz -O /tmp/webhook.tar.gz \
    && tar -xzf /tmp/webhook.tar.gz --strip-components=1 -C /usr/local/bin \
    && rm /tmp/webhook.tar.gz \
    && chmod +x /usr/local/bin/webhook \
    && webhook --version
EXPOSE 9000
ENTRYPOINT ["webhook", "-hooks=/hooks/hooks.json", "-verbose", "-hotreload"]
