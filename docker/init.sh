#!/usr/bin/env bash

set -eo pipefail; [[ "$TRACE" ]] && set -x

# There is no optional config generation with Confd
if [ "$CONSUL_SERVER" != "1" ]; then
    rm /etc/consul/20_server.json
fi
