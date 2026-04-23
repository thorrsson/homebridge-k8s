#!/bin/bash

# WARNING: homebridge cannot run on Mac (https://github.com/homebridge/docker-homebridge#compatibility)
# so this script is of limited use.  See ./run-test-rpi.sh instead.

set -e

helm lint $(pwd)/../.

# docker pull homebridge/homebridge:latest

k3d cluster create --config k3d.yaml || true
# k3d image import homebridge/homebridge:latest -c homebridge-cluster

helm upgrade --install \
--namespace homebridge --create-namespace \
homebridge \
--debug \
--set image.digest=homebridge/homebridge:latest \
--set replicaCount=1 \
--set ports.ui.number=8581 \
--set ports.service.number=18083 \
../.

#k3d cluster delete homebridge-cluster