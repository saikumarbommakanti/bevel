apiVersion: helm.toolkit.fluxcd.io/v2
kind: HelmRelease
metadata:
  name: {{ component_name }}
  namespace: {{ component_ns }}
  annotations:
    fluxcd.io/automated: "false"
spec:
  releaseName: {{ component_name }}
  interval: 1m
  chart:
   spec:
    chart: {{ charts_dir }}/enterprise-node
    sourceRef:
      kind: GitRepository
      name: flux-{{ network.env.type }}
      namespace: flux-{{ network.env.type }}
  values:
    global:
    serviceAccountName: vault-auth
    cluster:
      provider: {{ cloud_provider }} 
      cloudNativeServices: false
    vault:
      type: hashicorp
      role: vault-role
      address: 
      authPath: {{ org_name }}
      secretEngine: secretsv2
      secretPrefix: "data/{{ org_name }}"
    proxy:
      provider: "ambassador"
      externalUrlSuffix: {{ external_url_suffix }}
    cenm:
      sharedCreds:
        truststore: password
        keystore: password
      identityManager:
        port: 10000 # svc.idman.ports.external
        revocation:
          port: 5053 # svc.idman.ports.revocation
        internal:
          port: 5052 # svc.idman.ports.internal
      auth:
        port: 8081
      gateway:
        port: 8080
      zone:
        enmPort: 25000
      networkmap:
        port: 10000
        internal:
          port: 5050

    storage:
    size: 1Gi
    dbSize: 5Gi
    allowedTopologies:
      enabled: false

    database:
      driverClassName: "org.h2.Driver"
      jdbcDriver: ""
      url: "jdbc:h2:file:./h2/networkmap-manager-persistence;DB_CLOSE_ON_EXIT=FALSE;LOCK_TIMEOUT=10000;WRITE_DELAY=0;AUTO_SERVER_PORT=0"
      user: "networkmap-db-user"
      password: "networkmap-db-password"
      runMigration: true

    image: 
      pullSecret:
      pullPolicy: IfNotPresent
      enterpriseCli:
        repository: corda/enterprise-cli
        tag: 1.5.9-zulu-openjdk8u382
      networkmap:
        repository: corda/enterprise-networkmap
        tag: 1.5.9-zulu-openjdk8u382

    nmapUpdate: false
    sleepTimeAfterError: 120
    baseDir: /opt/cenm

    adminListener:
      port: 6000
