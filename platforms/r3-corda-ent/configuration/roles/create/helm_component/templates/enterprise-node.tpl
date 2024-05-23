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
      chart: {{ gitops.chart_source }}/enterprise-node
      sourceRef:
        kind: GitRepository
        name: flux-{{ network.env.type }}
        namespace: flux-{{ network.env.type }}
  values:
    global:
      serviceAccountName: vault-auth
      cluster:
        provider: {{ org.cloud_provider }}
        cloudNativeServices: false
      vault:
        type: hashicorp
        network: corda
        role: vault-role
        address: {{ vault.url }}
        authPath: {{ network.env.type }}{{ name }}
        secretEngine: {{ vault.secret_path | default("secretsv2") }}
        secretPrefix: "data/{{ network.env.type }}{{ name }}"
      proxy:
        provider: {{ network.env.proxy }}
        externalUrlSuffix: {{ org.external_url_suffix }}
        p2p: {{ node.p2p.ambassador | default('15010') }}
    storage:
      size: 1Gi
      dbSize: 2Gi
    image:
      node:
        repository: corda/corda-enterprise
        tag: 4.10.3-zulu-openjdk8-alpine

    network:
      creds:
        truststore: password

    tls:
      nameOverride: node   # should match the release name
      enabled: true

    nodeConf:
      legalName: "O=Node,OU=Node,L=London,C=GB"
      doormanPort: 443
      networkMapPort: 443
      doormanDomain: cenm-doorman.test.blockchaincloud.com
      networkMapDomain: cenm-nms.test.blockchaincloud.com
      networkMapURL: {{ nms_url | quote }}
      doormanURL: {{ doorman_url | quote }}
