FROM golang:1.16-alpine as builder
ARG VERSION=0.0.1

ENV GO111MODULE=on
ENV CGO_ENABLED=0
ENV GOOS=linux
ENV GOARCH=amd64

# build
WORKDIR /go/src/k8s-scheduler-extender-example
COPY go.mod .
COPY go.sum .
RUN GO111MODULE=on go mod download
COPY . .
RUN go install -ldflags "-s -w -X main.version=$VERSION" k8s-scheduler-extender-example

# runtime image
FROM alpine:3.13
COPY --from=builder /go/bin/k8s-scheduler-extender-example /usr/bin/k8s-scheduler-extender-example
ENTRYPOINT ["k8s-scheduler-extender-example"]
