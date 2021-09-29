# Dockerfile for jenkins/sfyt integration demonstration
FROM debian:stable
RUN apt-get update && \
    apt-get -y install nginx-light && \
    rm -rf /var/lib/apt/lists/*
CMD /bin/sh
