FROM golang:1.10.3 as builder 

RUN apt-get update \
    && apt-get install -y --no-install-recommends gettext

ADD cassandra /tmp/chart
RUN cd /tmp && tar -czvf /tmp/cassandra.tar.gz chart

ADD schema.yaml /tmp/schema.yaml

ARG REGISTRY
ARG TAG

RUN cat /tmp/schema.yaml \
    | env -i "REGISTRY=$REGISTRY" "TAG=$TAG" envsubst \
    > /tmp/schema.yaml.new \
    && mv /tmp/schema.yaml.new /tmp/schema.yaml

FROM ubuntu:latest

ENV WAIT_FOR_READY_TIMEOUT 1800
ENV TESTER_TIMEOUT 1800
EXPOSE 5556
