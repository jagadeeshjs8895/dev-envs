#!/bin/bash
default_ip(){
        if [[ -f $(which ip) ]]; then
                ip route get 8.8.8.8 | awk '{print $NF; exit}'
        else
                ifconfig en0 | grep inet | grep -v inet6 | cut -d ' ' -f2
        fi
}
echo "DEFAULT_IP=$(default_ip)" > .env
docker-compose up -d
while ! curl -I -XGET http://localhost:8500/v1/status/leader -f >/dev/null; do
	sleep 1
done
