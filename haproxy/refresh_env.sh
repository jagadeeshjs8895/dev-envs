#!/bin/bash

default_ip(){
        if [[ -f $(which ip) ]]; then
                ip route get 8.8.8.8 | awk '{print $NF; exit}'
        else
                ifconfig en0 | grep inet | grep -v inet6 | cut -d ' ' -f2
        fi
}


echo "DEFAULT_IP=$(default_ip)" > .env
