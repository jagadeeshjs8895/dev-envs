#!/bin/bash

default_ip(){
        if [[ -f $(which ip) ]]; then
                ip route get 8.8.8.8 | awk '{print $NF; exit}'
        else
                ifconfig en0 | grep inet | grep -v inet6 | cut -d ' ' -f2
        fi
}

unseal() {
	source ./.secret
	vault operator unseal ${VAULT_UNSEAL_KEY} 2>/dev/null
}
bootstrap(){
	export VAULT_ADDR="http://$(default_ip):8200"
	docker-compose down && docker-compose up -d
	
	while ! vault_init=$(vault operator init -key-shares=1 -key-threshold=1 2>/dev/null |grep -e "Unseal Key" -e "Initial Root Token"); do
		if [[ -f ./.secret ]] && unseal ; then
			exit 0
		fi
		sleep 1
	done
	 echo export VAULT_TOKEN=$(echo "${vault_init}" |grep 'Token'|cut -d ' ' -f 4) > ./.secret
	 echo export VAULT_UNSEAL_KEY=$(echo "${vault_init}"|grep 'Key'|cut -d ' ' -f 4) >> ./.secret

	unseal
	sleep 1
	vault write secret/admin user=yolo password=yolo
	vault read secret/admin
	vault delete secret/admin
}
echo "LOCAL_IP=$(default_ip)" > .env
bootstrap
