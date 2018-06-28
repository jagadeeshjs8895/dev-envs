#!/bin/bash

default_ip(){
        if [[ -f $(which ip) ]]; then
                ip route get 8.8.8.8 | awk '{print $NF; exit}'
        else
                ifconfig en0 | grep inet | grep -v inet6 | cut -d ' ' -f2
        fi
}
echo "DEFAULT_IP=$(default_ip)" > .env

configure_elk_filtering (){
curl -XPOST -D- 'http://localhost:5601/api/saved_objects/index-pattern' \
    -b /tmp/sg_cookies \
    -H 'Content-Type: application/json' \
    -H 'kbn-version: 6.3.0' \
    -d '{"attributes":{"title":"logstash-*","timeFieldName":"@timestamp"}}'
}
bootstrap(){
	docker-compose up -d
	while [[ "$(curl -w ''%{http_code}'' -s -o /dev/null -XPOST  'http://localhost:5601/api/saved_objects/index-pattern' -b /tmp/sg_cookies -H 'Content-Type: application/json' -H 'kbn-version: 6.3.0' -d '{"attributes":{"title":"logstash-*","timeFieldName":"@timestamp"}}')" != "200" ]]; do sleep 5; done
}

bootstrap
