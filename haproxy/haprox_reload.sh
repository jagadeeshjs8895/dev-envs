#!/bin/ash
haproxy -f /etc/haproxy/haproxy.cfg -f /etc/haproxy/conf.d/ -p /var/run/haproxy.pid -st $(cat /var/run/haproxy.pid)
