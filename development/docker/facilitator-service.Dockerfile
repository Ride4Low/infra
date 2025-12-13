FROM alpine
WORKDIR /app

ADD build/facilitator-service build/facilitator-service

ENTRYPOINT ["build/facilitator-service"]