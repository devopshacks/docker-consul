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
    && mkdir -p /data \
    && chmod 0700 /data \
    && chown app:app /data \
    && mkdir -p /etc/consul \
    && chmod 0555 /etc/consul \

    && echo "Clean up" \
    && apk del go git zip \
    && rm -rf /tmp/*

COPY devopshacks-release /etc/devopshacks-release
COPY confd /etc/confd
COPY init.sh /usr/local/bin/docker-init

EXPOSE 8300 8301 8301/udp 8302 8302/udp 8400 8500 8600 8600/udp

VOLUME ["/data"]

CMD ["/bin/consul", "agent", "-config-dir=/etc/consul"]

ENV CONSUL_ACLDATACENTER=dc1 \
    CONSUL_ACLMASTERTOKEN= \
    CONSUL_ACLTOKEN= \
    CONSUL_BOOTSTRAPEXPECT=3 \
    CONSUL_BINDADDR=0.0.0.0 \
    CONSUL_CLIENTADDR=127.0.0.1 \
    CONSUL_DATACENTER=dc1 \
    CONSUL_DOMAIN=consul \
    CONSUL_ENCRYPT= \
    CONSUL_NODENAME= \
    CONSUL_RETRYJOIN=[] \
    CONSUL_SERVER=0
