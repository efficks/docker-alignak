#!/usr/bin/env bash
set -e
set -x

rm -rf build

declare -A MODULES
MODULES["arbiter"]="7770"
MODULES["broker"]="7772"
MODULES["poller"]="7771"
MODULES["reactionner"]="7769"
MODULES["receiver"]="7773"
MODULES["scheduler"]="7768"

for MODULE in "${!MODULES[@]}"
do
	mkdir -p build/$MODULE
if [ "$MODULE" == "arbiter" ]
then
	m4 -D MODULENAME=$MODULE -D MODULEPORT=${MODULES[$MODULE]} Dockerfile.$MODULE > build/$MODULE/Dockerfile
else
	m4 -D MODULENAME=$MODULE -D MODULEPORT=${MODULES[$MODULE]} Dockerfile.other > build/$MODULE/Dockerfile
fi
	cd build/$MODULE;
	docker build --network=host -t alignak-$MODULE .
	cd -
done

mkdir -p build/backend
cp Dockerfile.backend build/backend/Dockerfile
cp alignakbackend.py build/backend
cd build/backend
docker build --network=host -t alignak-backend .
cd -
