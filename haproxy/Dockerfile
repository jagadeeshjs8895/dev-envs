FROM alpine:3.7
RUN apk add --update \
	--repository http://dl-3.alpinelinux.org/alpine/edge/main/ \
	--repository http://dl-3.alpinelinux.org/alpine/edge/testing/ \
	jq \
	curl \
	consul-template \
	haproxy \
	&& rm -rf /var/cache/apk/* /tmp/* $HOME/.cache

RUN mkdir -p /etc/haproxy/dynamic /etc/consul/haproxy
ADD docker-entrypoint.sh /bin/docker-entrypoint.sh

WORKDIR /etc/haproxy

ENTRYPOINT docker-entrypoint.sh
