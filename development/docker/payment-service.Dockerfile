FROM alpine
WORKDIR /app

ADD build/payment-service build/payment-service

ENTRYPOINT ["build/payment-service"]