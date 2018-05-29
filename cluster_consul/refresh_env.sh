#!/bin/bash
docker-compose up -d
while ! curl -I -XGET http://localhost:8500/v1/status/leader -f >/dev/null; do
	sleep 1
done
