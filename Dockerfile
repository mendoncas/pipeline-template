FROM golang:1.22-alpine as build
COPY src/  .
RUN go build -o bin/app .

FROM alpine:3.14
COPY --from=build go/bin/app .
ARG PORT
ARG MESSAGE
ENTRYPOINT ./app
