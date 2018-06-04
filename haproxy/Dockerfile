FROM alpine:3.7
RUN apk add --update \
	--repository http://dl-3.alpinelinux.org/alpine/edge/main/ \
	--repository http://dl-3.alpinelinux.org/alpine/edge/testing/ \
	jq \
	curl \
	consul-template \
	haproxy \
	&& rm -rf /var/cache/apk/* /tmp/* $HOME/.cache

RUN mkdir -p /etc/haproxy/conf.d /etc/consul/haproxy
ADD ./conf/consul/* /etc/consul/haproxy/
ADD ./conf/haproxy/haproxy.cfg /etc/haproxy/haproxy.cfg
ADD docker-entrypoint.sh haprox_reload.sh /bin/

WORKDIR /etc/haproxy

ENTRYPOINT docker-entrypoint.sh
