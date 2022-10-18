# AKS cert mounter &middot; [![GitHub Release](https://img.shields.io/github/v/release/pagopa/aks-helm-cert-mounter-blueprint?style=flat)](https://github.com/pagopa/aks-helm-cert-mounter-blueprint/releases) [![GitHub Issues](https://img.shields.io/github/issues/pagopa/aks-helm-cert-mounter-blueprint?style=flat)](https://github.com/pagopa/aks-helm-cert-mounter-blueprint/issues) [![Open Source](https://badges.frapsoft.com/os/v1/open-source.svg?v=103)](https://opensource.org/)

The `aks-helm-cert-mounter-blueprint` chart is the best way to retrive certificates from kv into k8s. It contains all the required
components to get started, and it has several architectural aspects already
configured.

Some of the key benefits of this chart are:

- Highly secure environment thanks to Secret Store CSI Provider;

## Architecture

To see the entire architecture please see this page [architecture](docs/ARCHITECTURE.md)

## Pre requisites

- helm & kubernetes

### Static analysis

Install:

- <https://github.com/norwoodj/helm-docs>

## Installation

This is the official and recommended method to adopt this chart.

### Quick start

- Create a `helm` folder inside your microservice project in which install the
Helm chart:

```shell
mkdir helm && cd helm
```

- Add Helm repo:

```shell
helm repo add cert-mounter-blueprint https://pagopa.github.io/aks-helm-cert-mounter-blueprint
```

> If you had already added this repo earlier, run `helm repo update` to retrieve
> the latest versions of the packages.

- Add a very basic configuration in `Chart.yaml`:

```shell
cat <<EOF > Chart.yaml
apiVersion: v2
name: my-microservice
description: My microservice description
type: application
version: 1.0.0
appVersion: 1.0.0
dependencies:
- name: cert-mounter-blueprint
  version: 1.0.0
  repository: "https://pagopa.github.io/aks-helm-cert-mounter-blueprint"
EOF
```

- Install the dependency:

```shell
helm dep build
```

- Create a `values-<env>.yaml` for each environment:

```shell
touch values-dev.yaml values-uat.yaml values-prod.yaml
```

- Override all values that you need for example:

```yaml
cert-mounter-blueprint:
  namespace: "rtd"
  nameOverride: ""
  fullnameOverride: ""

  deployment:
    create: true

  kvCertificatesName:
    - mock-certificate
    - fake-cert
    - dev01-rtd-internal-dev-cstar-pagopa-it

  keyvault:
    name: "cstar-d-rtd-kv"
    tenantId: "7788edaf-0346-4068-9d79-c868aed15b3d"
```

- execute helm upgrade to install the chart: 

```sh
helm upgrade -i -n <namespace name> -f <file with values> <name of the helm chart> <chart folder>

helm upgrade -i -n mynamespace -f helm/values-dev.yaml cert-mounter helm
```

### Upgrading

Change version of the dependency and run the update:

```shell
cd helm && helm dep update .
```

## Template/App mandatory resources and configuration

To work as expect this template must request:

Azure:

- TLS certificate are present into the kv (for ingress)
- Managed POD identity are created

## Final Result

Here you can find a result of the template [final result](docs/FINAL_RESULT_EXAMPLE.md)

## Examples

In the [`example`](example/) folder, you can find a working examples.

### cert-mounter-example

install a cert mounter

## Yaml chart configuration properties (values.yaml)

see [README/Cert Mounter](charts/cert-mounter-blueprint/README.md) to understand how to use the values.

### Publish

The branch `gh-pages` contains the GitHub page content and all released charts.
To update the page content, use `bin/publish`.

## Known issues and limitations

- None.
