FROM golang:1.17-buster AS build

WORKDIR /app
ADD . .

ENV CGO_ENABLED=0

COPY go.mod .
COPY go.sum .

RUN go mod download

RUN go build ./cmd/main.go

FROM alpine:latest

RUN apk upgrade --update-cache --available && \
    rm -rf /var/cache/apk/*

ENV PET_HOST 0.0.0.0
ENV PET_PORT 8080
ENV PET_DB db
ENV PET_MINIOROOTUSER minio
ENV PET_MINIOHOST 127.0.0.1
ENV PET_MINIOPORT 9000
ENV PET_MINIOROOTPASSWORD minio123
ENV PET_USERBUCKETNAME users

WORKDIR /app

COPY --from=build /app/ .
ADD cmd .

EXPOSE 8080

CMD ["./main"]
