#/bin/ash
CONSUL_URL=${CONSUL_URL:-"consul_server:8500"}
echo $CONSUL_URL

# prepare backend
consul-template \
    -consul-addr=${CONSUL_URL} \
    -consul-retry \
    -template "/etc/consul/haproxy/dynamic.cfg.ctmpl:/etc/haproxy/dynamic/dynamic.cfg" -once

# haprox
haproxy -f /etc/haproxy/haproxy.cfg -f /etc/haproxy/dynamic/ -p /var/run/haproxy.pid -D

# consul
consul-template \
    -consul-addr=${CONSUL_URL} \
    -consul-retry \
    -template="/etc/consul/haproxy/dynamic.cfg.ctmpl:/etc/haproxy/dynamic/dynamic.cfg:haproxy -f /etc/haproxy/haproxy.cfg -f /etc/haproxy/dynamic/ -p /var/run/haproxy.pid -D -sf $(cat /var/run/haproxy.pid)"
