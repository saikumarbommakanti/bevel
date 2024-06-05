global:
    serviceAccountName: vault-auth
    cluster:
        provider: {{ org.cloud_provider }}
        cloudNativeServices: false
    vault:
        type: hashicorp
        network: corda-enterprise
        address: {{ vault.url }}
        authPath: {{ network.env.type }}{{ name }}
        secretEngine: {{ vault.secret_path | default("secretsv2") }}
        secretPrefix: "data/{{ network.env.type }}{{ name }}"
        role: vault-role
    proxy:
        provider: {{ network.env.proxy }}
        externalUrlSuffix: {{ org.external_url_suffix }}
    storage:
      size: 1Gi
      dbSize: 5Gi
      allowedTopologies:
        enabled: false
    settings:
      removeKeysOnDelete: true
    tls:
      enabled: true