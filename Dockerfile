FROM alpinelinux/golang:latest

WORKDIR /app
COPY go.mod go.sum ./
RUN  go mod download
COPY init.go ./
USER root
RUN GOARCH=amd64 GOOS=linux go build init.go

FROM alpine:latest
RUN apk add --no-cache unzip bash file

COPY --from=0 /app/init /var/runtime/init

ARG FUNCTION_DIR="/var/task"
RUN mkdir -p ${FUNCTION_DIR}
# COPY app/* ${FUNCTION_DIR}
WORKDIR ${FUNCTION_DIR}
# RUN unzip echo.zip

ENV PATH=/usr/local/bin:/usr/bin/:/bin:/opt/bin \
    LD_LIBRARY_PATH=/lib64:/usr/lib64:/var/runtime:/var/runtime/lib:/var/task:/var/task/lib:/opt/lib \
    LANG=en_US.UTF-8 \
    TZ=:UTC \
    LAMBDA_TASK_ROOT=/var/task \
    LAMBDA_RUNTIME_DIR=/var/runtime \
    _LAMBDA_CONTROL_SOCKET=14 \
    _LAMBDA_SHARED_MEM_FD=11 \
    _LAMBDA_LOG_FD=9 \
    _LAMBDA_SB_ID=7 \
    _LAMBDA_CONSOLE_SOCKET=16 \
    _LAMBDA_RUNTIME_LOAD_TIME=1530232235231 \
    _AWS_XRAY_DAEMON_ADDRESS=169.254.79.2 \
    _AWS_XRAY_DAEMON_PORT=2000 \
    AWS_XRAY_DAEMON_ADDRESS=169.254.79.2:2000 \
    AWS_XRAY_CONTEXT_MISSING=LOG_ERROR \
    _X_AMZN_TRACE_ID='Root=1-dc99d00f-c079a84d433534434534ef0d;Parent=91ed514f1e5c03b2;Sampled=1'

ENTRYPOINT ["/var/runtime/init"]
