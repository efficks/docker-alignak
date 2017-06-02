#!/usr/bin/env bash
set -e
set -x

declare -a MODULES=("arbiter" "broker" "poller" "reactionner" "receiver" "scheduler")

for MODULE in "${MODULES[@]}"
do
	mkdir -p build/$MODULE
	jinja2 -D MODULENAME=$MODULE Dockerfile.common config.yaml > build/$MODULE/Dockerfile
        cd build/$MODULE;
	docker build --network=host -t alignak-$MODULE .
	cd -
done

# Backend
mkdir -p build/backend
cp Dockerfile.backend build/backend/Dockerfile
cp alignakbackend.py build/backend
cd build/backend
docker build --network=host -t alignak-backend .
cd -

# Webui
mkdir -p build/webui
cp Dockerfile.webui build/webui/Dockerfile
#cp alignakbackend.py build/backend
cd build/webui
docker build --network=host -t alignak-webui .
cd -
