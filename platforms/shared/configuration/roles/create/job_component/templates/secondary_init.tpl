# template for corda-init chart/job
global:
  serviceAccountName: vault-auth
  vault:
    type: hashicorp
    network: corda
    address: {{ vault.url }}
    authPath: {{ network.env.type }}
    secretEngine: {{ vault.secret_path | default("secretsv2") }}
    secretPrefix: "data/{{ network.env.type }}"
    role: vault-role
  cluster:
    provider: {{ org.cloud_provider }}
    cloudNativeServices: false
    kubernetesUrl: {{ kubernetes_url }}
settings:
  secondaryInit: true
