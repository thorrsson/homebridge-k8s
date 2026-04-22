#!/bin/bash

set -e

CONFIG_FILE=config/test-config.json

helm lint $(pwd)/../.
python3 -mjson.tool ../${CONFIG_FILE}

helm upgrade --install \
--namespace test-homebridge --create-namespace \
test-homebridge \
--debug \
--set image.digest=homebridge/homebridge:latest \
--set affinity.label=network \
--set affinity.value={mbit} \
--set replicaCount=1 \
--set ports.service.number=12345 \
--set config.configFile.enabled=true \
--set config.configFile.path=${CONFIG_FILE} \
../.