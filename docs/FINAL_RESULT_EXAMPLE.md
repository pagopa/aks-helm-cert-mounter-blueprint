# Final result

```yaml
---
# Source: cert-mounter-example/charts/cert-mounter-blueprint/templates/deployments.yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: release-name-cert-mounter-blueprint
  namespace: rtd
  labels:
    helm.sh/chart: cert-mounter-blueprint-1.0.0
    app.kubernetes.io/name: cert-mounter-blueprint
    app.kubernetes.io/instance: release-name
    canaryDelivery: "false"
    app.kubernetes.io/version: "0.0.0"
    app.kubernetes.io/managed-by: Helm
  annotations:
    reloader.stakater.com/auto: "true"
spec:
  replicas: 1
  selector:
    matchLabels:
      app.kubernetes.io/name: cert-mounter-blueprint
      app.kubernetes.io/instance: release-name
      canaryDelivery: "false"
  template:
    metadata:
      labels:
        aadpodidbinding: "rtd-pod-identity"
        app.kubernetes.io/name: cert-mounter-blueprint
        app.kubernetes.io/instance: release-name
        canaryDelivery: "false"
    spec:
      automountServiceAccountToken: false
      serviceAccountName: default
      securityContext:
        seccompProfile:
          type: RuntimeDefault
      containers:
        - name: crt-mounter
          securityContext:
            allowPrivilegeEscalation: false
          image: alpine:3.16.1@sha256:9b2a28eb47540823042a2ba401386845089bb7b62a9637d55816132c4c3c36eb
          command: ['tail', '-f', '/dev/null']
          resources:
            limits:
              memory: 16Mi
              cpu: 50m
          volumeMounts:
            - name: secrets-store-inline-crt-mock-certificate
              mountPath: "/mnt/secrets-store-crt-mock-certificate"
              readOnly: true
            - name: secrets-store-inline-crt-fake-cert
              mountPath: "/mnt/secrets-store-crt-fake-cert"
              readOnly: true
            - name: secrets-store-inline-crt-dev01-rtd-internal-dev-cstar-pagopa-it
              mountPath: "/mnt/secrets-store-crt-dev01-rtd-internal-dev-cstar-pagopa-it"
              readOnly: true
      volumes:

        ### TLS cert
        - name: secrets-store-inline-crt-mock-certificate
          csi:
            driver: secrets-store.csi.k8s.io
            readOnly: true
            volumeAttributes:
              secretProviderClass: release-name-cert-mounter-blueprint-mock-certificate
        - name: secrets-store-inline-crt-fake-cert
          csi:
            driver: secrets-store.csi.k8s.io
            readOnly: true
            volumeAttributes:
              secretProviderClass: release-name-cert-mounter-blueprint-fake-cert
        - name: secrets-store-inline-crt-dev01-rtd-internal-dev-cstar-pagopa-it
          csi:
            driver: secrets-store.csi.k8s.io
            readOnly: true
            volumeAttributes:
              secretProviderClass: release-name-cert-mounter-blueprint-dev01-rtd-internal-dev-cstar-pagopa-it
---
# Source: cert-mounter-example/charts/cert-mounter-blueprint/templates/secretproviderclass.yaml
apiVersion: secrets-store.csi.x-k8s.io/v1
kind: SecretProviderClass
metadata:
  name: release-name-cert-mounter-blueprint-mock-certificate
  namespace: rtd
spec:
  provider: azure
  secretObjects:
    - secretName: mock-certificate
      type: kubernetes.io/tls
      data:
        - key: tls.key
          objectName: mock-certificate
        - key: tls.crt
          objectName: mock-certificate
  parameters:
    usePodIdentity: "true"
    useVMManagedIdentity: "false"
    userAssignedIdentityID: ""
    keyvaultName: cstar-d-rtd-kv
    tenantId: 7788edaf-0346-4068-9d79-c868aed15b3d
    cloudName: ""
    objects: |
      array:
        - |
          objectName: mock-certificate
          objectType: secret
          objectVersion: ""
---
# Source: cert-mounter-example/charts/cert-mounter-blueprint/templates/secretproviderclass.yaml
apiVersion: secrets-store.csi.x-k8s.io/v1
kind: SecretProviderClass
metadata:
  name: release-name-cert-mounter-blueprint-fake-cert
  namespace: rtd
spec:
  provider: azure
  secretObjects:
    - secretName: fake-cert
      type: kubernetes.io/tls
      data:
        - key: tls.key
          objectName: fake-cert
        - key: tls.crt
          objectName: fake-cert
  parameters:
    usePodIdentity: "true"
    useVMManagedIdentity: "false"
    userAssignedIdentityID: ""
    keyvaultName: cstar-d-rtd-kv
    tenantId: 7788edaf-0346-4068-9d79-c868aed15b3d
    cloudName: ""
    objects: |
      array:
        - |
          objectName: fake-cert
          objectType: secret
          objectVersion: ""
---
# Source: cert-mounter-example/charts/cert-mounter-blueprint/templates/secretproviderclass.yaml
apiVersion: secrets-store.csi.x-k8s.io/v1
kind: SecretProviderClass
metadata:
  name: release-name-cert-mounter-blueprint-dev01-rtd-internal-dev-cstar-pagopa-it
  namespace: rtd
spec:
  provider: azure
  secretObjects:
    - secretName: dev01-rtd-internal-dev-cstar-pagopa-it
      type: kubernetes.io/tls
      data:
        - key: tls.key
          objectName: dev01-rtd-internal-dev-cstar-pagopa-it
        - key: tls.crt
          objectName: dev01-rtd-internal-dev-cstar-pagopa-it
  parameters:
    usePodIdentity: "true"
    useVMManagedIdentity: "false"
    userAssignedIdentityID: ""
    keyvaultName: cstar-d-rtd-kv
    tenantId: 7788edaf-0346-4068-9d79-c868aed15b3d
    cloudName: ""
    objects: |
      array:
        - |
          objectName: dev01-rtd-internal-dev-cstar-pagopa-it
          objectType: secret
          objectVersion: ""
```
