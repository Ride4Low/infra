FROM alpine
WORKDIR /app

ADD build/driver-service build/driver-service

ENTRYPOINT ["build/driver-service"]