#!/bin/bash
for folder in $(ls -d */); do
	pushd "${folder}"
	if [[ -f "refresh_env.sh" ]] && [[ -r "refresh_env.sh" ]]; then
		source refresh_env.sh
	fi
	docker-compose up -d
	popd
done
