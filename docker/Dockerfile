FROM devopshacks/alpine-base:latest

ENV CONSUL_BUILD_TAG=v0.6.4

RUN \
    echo "Install packages" \
    && apk add --no-cache \
      go git zip \

    && echo "Install Consul" \
    && mkdir /tmp/go \
    && export GOPATH=/tmp/go PATH="/tmp/go/bin:$PATH" \
    && go get github.com/hashicorp/consul \
    && cd /tmp/go/src/github.com/hashicorp/consul \
    && git checkout ${CONSUL_BUILD_TAG} \
    && XC_OS="linux" XC_ARCH="amd64" make \
    && mv /tmp/go/bin/consul /bin/ \

    && echo "Clean up" \
    && apk del go git zip \
    && rm -rf /tmp/*

COPY devopshacks-release /etc/devopshacks-release

EXPOSE 8300 8301 8301/udp 8302 8302/udp 8400 8500
