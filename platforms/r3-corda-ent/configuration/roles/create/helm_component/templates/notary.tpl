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
{% if network.docker.username is defined %}
      pullSecret: regcred
{% endif %}
      pullPolicy: IfNotPresent
      node:
        repository: corda/corda-enterprise
        tag: 4.10.3-zulu-openjdk8-alpine
      bevelAlpine:
        repository:  {{ network.docker.url }}/bevel-alpine
        tag: latest

    network:
      creds:
        truststore: password
    tls:
      nameOverride: notary   # should match the release name
      enabled: false

    dataSourceProperties:
      dataSource:
        user: node-db-user
        password: node-db-password
        url: "jdbc:h2:file:./h2/node-persistence;DB_CLOSE_ON_EXIT=FALSE;WRITE_DELAY=0;LOCK_TIMEOUT=10000"
        dataSourceClassName: org.h2.jdbcx.JdbcDataSource

    nodeConf:
      creds:
        truststore: cordacadevpass
        keystore: trustpass
      crlCheckSoftFail: true
      tlsCertCrlDistPoint: ""
      tlsCertCrlIssuer: ""
      devMode: false
      monitoring:
        enabled: true
        port: 8090
      allowDevCorDapps:
        enabled: true
      p2pPort: "{{ node.p2p.port }}" #10002
      rpc:
        port: "{{ node.rpc.targetPort }}" #10003
        adminPort: "{{ node.rpcadmin.targetPort }}" #10005
        users:
        - name: node
          password: nodeP
          permissions: ALL
      ssh:
          enabled: true
          sshdPort: 2222
      removeKeysOnDelete: false
      legalName: {{ node.subject|e }} #use peer-node level subject for legalName
      notary:
        validating: true
        serviceLegalName: "O=Notary,OU=Notary Service,L=London,C=GB"
      doormanPort: 443
      networkMapPort: 443
      doormanDomain: cenm-doorman.corda.blockchaincloudpoc-develop.com
      networkMapDomain: cenm-nms.corda.blockchaincloudpoc-develop.com
      networkMapURL: https://cenm-nms.corda.blockchaincloudpoc-develop.com
      doormanURL: https://cenm-doorman.corda.blockchaincloudpoc-develop.com
    firewall:
      enabled: false
  {% if org.cordapps is defined %}
    cordApps: 
      #Provide if you want to provide jars in cordApps
      #Eg. getCordApps: true or false
      getCordApps: false
      jars: {{ org.cordapps.jars }}
  {% endif %}
      # Sleep time (in seconds) after an error occured
      sleepTimeAfterError: 180
      # path to base dir
      baseDir: /opt/corda
