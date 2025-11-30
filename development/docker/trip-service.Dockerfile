FROM alpine
WORKDIR /app

ADD build/trip-service build/trip-service

ENTRYPOINT ["build/trip-service"]