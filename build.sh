#!/usr/bin/env bash

for MODULE in arbiter scheduler broker poller reactionner receiver
do
	mkdir -p build/$MODULE
	m4 Dockerfile.$MODULE > build/$MODULE/Dockerfile

	cd build/$MODULE;
	docker build -t alignak-$MODULE .
	cd -
done
