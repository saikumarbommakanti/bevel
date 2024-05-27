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
      serviceAccountName: vault-auth
      cluster:
        provider: {{ org.cloud_provider }}
        cloudNativeServices: false
      vault:
        type: hashicorp
        network: corda
        address: {{ vault.url }}
        authPath: {{ network.env.type }}{{ name }}
        secretEngine: {{ vault.secret_path | default("secretsv2") }}
        secretPrefix: "data/{{ network.env.type }}{{ name }}"
        role: vault-role
      proxy:
        provider: {{ network.env.proxy }}
        externalUrlSuffix: {{ org.external_url_suffix }}
      cenm:
        sharedCreds:
          truststore: password 
          keystore: password
        identityManager:
          port: {{ node.idman.port }} # 10000
          revocation:
            port: 5053
          internal:
            port: 5052
        auth:
          port: {{ node.auth.port }} # 8081

          # enmPort: 25000 #zone.
          # adminPort: 12345
        networkmap:
          internal:
            port: 5050  
  storage:
    size: 1Gi
    dbSize: 5Gi
    allowedTopologies:
      enabled: false
    settings:
      removeKeysOnDelete: true

    tls:
      enabled: true
    image:
{% if network.docker.username is defined %}
      pullSecret: regcred
{% endif %}
      pullPolicy: IfNotPresent
      pki:
        repository: corda/enterprise-pkitool
        tag: 1.5.9-zulu-openjdk8u382
      hooks:
        repository: {{ network.docker.url }}/bevel-build
        tag: jdk8-stable