FROM ubuntu:16.04

RUN apt-get update -y -q && apt-get upgrade -y -q 

RUN DEBIAN_FRONTEND=noninteractive apt-get install --no-install-recommends -y -q curl build-essential ca-certificates git unzip gcc

RUN curl -s https://storage.googleapis.com/golang/go1.14.1.linux-amd64.tar.gz| tar -v -C /usr/local -xz


ENV GOPATH /go
ENV GOROOT /usr/local/go
ENV PATH $PATH:/usr/local/go/bin