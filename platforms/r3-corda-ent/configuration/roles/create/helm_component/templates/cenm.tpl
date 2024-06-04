---
apiVersion: helm.toolkit.fluxcd.io/v2beta1
kind: HelmRelease
metadata:
  name: {{ component_name }}
  annotations:
    fluxcd.io/automated: "false"
  namespace: {{ component_ns }}
spec:
  releaseName: {{ component_name }}
  interval: 1m
  chart:
    spec:
      chart: {{ gitops.chart_source }}/cenm
      sourceRef:
        kind: GitRepository
        name: flux-{{ network.env.type }}
        namespace: flux-{{ network.env.type }}
  values:
    global:
      serviceAccountName: bevel-auth
      cluster:
        provider: azure
        cloudNativeServices: false
      vault:
        type: hashicorp
        role: vault-role
        address: http://98.64.226.131:20001
        authPath: entsupplychain
        secretEngine: secretsv2
        secretPrefix: "data/entsupplychain"
        network: corda-enterprise
      proxy:
        provider: "ambassador"
        externalUrlSuffix: corda.blockchaincloudpoc-develop.com
    storage:
      size: 1Gi
      dbSize: 5Gi
      allowedTopologies:
        enabled: false

    settings:
      removeKeysOnDelete: true # this will erase keys

    tls:
      enabled: true
