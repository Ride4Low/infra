FROM alpine
WORKDIR /app

ADD build/notifier build/notifier

ENTRYPOINT ["build/notifier"]