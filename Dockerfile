FROM rust:1.62.1-bullseye AS builder
RUN apt-get update && apt-get -y upgrade && apt-get install -y cmake libclang-dev protobuf-compiler
COPY . lighthouse
ARG FEATURES
ENV FEATURES $FEATURES
RUN cd lighthouse && make && make install-lcli

FROM ubuntu:22.04
RUN apt-get update && apt-get -y upgrade && apt-get install -y --no-install-recommends \
  libssl-dev \
  ca-certificates \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/*
COPY --from=builder /usr/local/cargo/bin/lighthouse /usr/local/bin/lighthouse
COPY --from=builder /usr/local/cargo/bin/lcli /usr/local/bin/lcli
