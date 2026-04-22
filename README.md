# Homebridge

A Helm chart for a Kubernetes deployment of [Homebridge](https://github.com/homebridge/homebridge) using the official [`homebridge/homebridge`](https://hub.docker.com/r/homebridge/homebridge) Docker image.

## Versions

- **Chart**: see [`Chart.yaml`](./Chart.yaml).
- **Docker image**: [`homebridge/homebridge:latest`](https://hub.docker.com/r/homebridge/homebridge/tags) (multi-arch: `amd64`, `arm/v7`, `arm64/v8`, Ubuntu 24.04 base). `values.yaml` pins the `latest` manifest digest for reproducibility; override with `--set image.digest=homebridge/homebridge:latest` for the floating tag.
- **Kubernetes**: tested against `apps/v1` (Kubernetes 1.19+). Chart uses Helm 3 (`apiVersion: v2`).
- **k3d**: [`run/k3d.yaml`](./run/k3d.yaml) uses `k3d.io/v1alpha5` with a current `rancher/k3s` image.

> **Note**: The legacy `oznu/homebridge` image has been deprecated upstream. This chart now targets the official `homebridge/homebridge` image, which stores all state under a single `/homebridge` volume and serves its UI on port **8581** (previously `80`).

## Configuration

All Homebridge configuration resides in the `config/` directory. By default the chart renders `config/config.json` into a ConfigMap and mounts it at `/homebridge/config.json` inside the container. The file path can be overridden via `config.configFile.path`, and the behavior can be disabled entirely by setting `config.configFile.enabled=false` (useful when you'd rather manage configuration exclusively through the Homebridge UI).

Any changes to the configuration will trigger a redeployment.

`ffmpeg` is baked into the official image — no additional install step is required.

Plugins are now installed and managed through the Homebridge UI (or via a custom `startup.sh` in the mounted volume). The `package.json` ConfigMap mount that existed in previous versions of this chart has been removed.

## Data

The chart provisions a single `PersistentVolumeClaim` (`homebridge-pvclaim`) that is mounted at `/homebridge`. This directory holds the Homebridge config, the `persist/` directory with HomeKit accessory pairing data, and the `accessories/` directory with accessory state. Removing this volume will un-pair devices from the "Home" app, forcing reconfiguration. The PVC size can be tuned with `persistence.size` (default `1Gi`).

## Networking

The Deployment uses `hostNetwork: true` so that mDNS / Bonjour advertisements reach the local network — this is required by HomeKit. The bundled Avahi daemon can be disabled with `--set environment.enableAvahi=0` if the host already runs mDNS.

## Running locally

See [`run/run-k3d.sh`](./run/run-k3d.sh) for a k3d-based sandbox and [`run/run-test-rpi.sh`](./run/run-test-rpi.sh) for an example Raspberry Pi deployment.
