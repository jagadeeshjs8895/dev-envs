#/bin/ash
CONSUL_URL=${CONSUL_URL:-"consul_server:8500"}

# prepare backend
consul-template \
    -consul-addr=${CONSUL_URL} \
    -consul-retry \
    -template "/etc/consul/haproxy/consul-mapping.ctmpl:/etc/haproxy/consul-mapping" \
    -template "/etc/consul/haproxy/${SILO}_node.cfg.ctmpl:/etc/haproxy/conf.d/${SILO}_node.cfg" -once

# haprox
haproxy -f /etc/haproxy/haproxy.cfg -f /etc/haproxy/conf.d/ -p /var/run/haproxy.pid -D

# consul
consul-template \
    -consul-addr=${CONSUL_URL} \
    -consul-retry \
    -template "/etc/consul/haproxy/consul-mapping.ctmpl:/etc/haproxy/consul-mapping" \
    -template "/etc/consul/haproxy/${SILO}_node.cfg.ctmpl:/etc/haproxy/conf.d/${SILO}_node.cfg:/bin/haprox_reload.sh"
