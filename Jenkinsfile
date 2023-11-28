properties([
  parameters([
    [$class: 'ChoiceParameter',
        choiceType: 'PT_SINGLE_SELECT',
        description: 'Select the Network from Dropdown list',
        filterLength: 1,
        filterable: false,
        name: 'NETWORK',
        script: [
          $class: 'GroovyScript',
          fallbackScript: [
            classpath: [],
            sandbox: false,
            script:
              'return[\'Could not get the Network\']'
          ],
          script: [
            classpath: [],
            sandbox: false,
            script:
              'return["fabric","besu","quorum","indy","r3-corda","r3-corda-ent"]'
          ]
        ]    
    ],
    [$class: 'CascadeChoiceParameter',
        choiceType: 'PT_SINGLE_SELECT',
        description: 'Select the Consensus from Dropdown list',
        filterLength: 1,
        filterable: false,
        name: 'CONSENSUS',
        referencedParameters: 'NETWORK',
        script: [
          $class: 'GroovyScript',
          fallbackScript: [
            classpath: [],
            sandbox: false,
            script:
              'return[\'Could not get the CONSENSUS\']'
          ],
          script: [
            classpath: [],
            sandbox: false,
            script:
              '''
                if (NETWORK.equals("fabric")){
                    return["raft"]
                }
                else if(NETWORK.equals("besu")){
                    return["ethash","ibft","qbft","clique"]
                }
                else if(NETWORK.equals("quorum")){
                    return["raft","ibft"]
                }
              '''
          ]
        ]   
    ],
    [$class: 'CascadeChoiceParameter',
        choiceType: 'PT_SINGLE_SELECT',
        description: 'Select the LoadBalancer from Dropdown list',
        filterLength: 1,
        filterable: false,
        name: 'PROXY',
        referencedParameters: 'NETWORK',
        script: [
          $class: 'GroovyScript',
          fallbackScript: [
            classpath: [],
            sandbox: false,
            script:
              'return[\'This parameter is vaild only for Fabric Network\']'
          ],
          script: [
            classpath: [],
            sandbox: false,
            script:
              '''
                if (NETWORK.equals("fabric")){
                    return["haproxy","edge-stack"]
                }
                else if(NETWORK.equals("besu")){
                    return["edge-stack"]
                }
                else if(NETWORK.equals("quorum")){
                    return["edge-stack"]
                }  
                else if(NETWORK.equals("indy")){
                    return["edge-stack"]
                }  
                else if(NETWORK.equals("r3-corda")){
                    return["edge-stack"]
                }
                else if(NETWORK.equals("r3-corda-ent")){
                    return["edge-stack"]
                }                
              '''
          ]
        ]   
    ],
    [$class: 'CascadeChoiceParameter',
        choiceType: 'PT_SINGLE_SELECT',
        description: 'Select the LoadBalancer from Dropdown list',
        filterLength: 1,
        filterable: false,
        name: 'EXTERNALURLSUFFIX',
        referencedParameters: 'PROXY',
        script: [
          $class: 'GroovyScript',
          fallbackScript: [
            classpath: [],
            sandbox: false,
            script:
              'return[\'Select the PROXY TYPE\']'
          ],
          script: [
            classpath: [],
            sandbox: false,
            script:
              '''
                if (PROXY.equals("edge-stack")){
                    return["sai.dev.aws.blockchaincloudpoc-develop.com"]
                }
                else if(PROXY.equals("haproxy")){
                    return["hf.dev2.aws.blockchaincloudpoc-develop.com"]
                }               
              '''
          ]
        ]   
    ],
    [$class: 'CascadeChoiceParameter',
        choiceType: 'PT_SINGLE_SELECT',
        description: 'Select the Transaction Manager from Dropdown list',
        filterLength: 1,
        filterable: false,
        name: 'TRANSACTION_MANAGER',
        referencedParameters: 'NETWORK',
        script: [
          $class: 'GroovyScript',
          fallbackScript: [
            classpath: [],
            sandbox: false,
            script:
              'return[\'Network should be either Besu or Quorum for Transaction manager, ignore for other Networks\']'
          ],
          script: [
            classpath: [],
            sandbox: false,
            script:
              '''
              if (NETWORK.equals("besu")){
                  return["tessera","orion"]
              }
              else if (NETWORK.equals("quorum")){
                  return["tessera","orion"]
              }

              '''
          ]
        ]   
    ],
    [$class: 'CascadeChoiceParameter',
        choiceType: 'PT_SINGLE_SELECT',
        description: 'Select the Action  from Dropdown list',
        filterLength: 1,
        filterable: false,
        name: 'ACTION',
        referencedParameters: 'NETWORK',
        script: [
          $class: 'GroovyScript',
          fallbackScript: [
            classpath: [],
            sandbox: false,
            script:
              'return[\'select the Action\']'
          ],
          script: [
            classpath: [],
            sandbox: false,
            script:
              '''
              if (NETWORK.equals("besu")){
                  return["deploy","reset","addmemberorg","addvalidatornode","addvalidatororg"]
              }
              else if (NETWORK.equals("fabric")){
                  return["deploy","reset","addneworg","addordererorg","addchannel","removeorg","addpeer","addraftorderer"]
              }
              else if (NETWORK.equals("quorum")){
                  return["deploy","reset","addnode"]
              }
              else if (NETWORK.equals("r3-corda")){
                  return["deploy","reset"]
              }
              else if (NETWORK.equals("r3-corda-ent")){
                  return["deploy","reset","addorg","addnotaryorg"]
              }
              else if (NETWORK.equals("indy")){
                  return["deploy","reset","addorg"]
              }

              '''
          ]
        ]   
    ],
    [$class: 'CascadeChoiceParameter',
        choiceType: 'PT_SINGLE_SELECT',
        description: 'Select the Issuer from the Dropdown List',
        filterLength: 1,
        filterable: false,
        name: 'Issuer',
        referencedParameters: 'NETWORK',
        script: [
          $class: 'GroovyScript',
          fallbackScript: [
            classpath: [],
            sandbox: false,
            script:
              'return[\'Select the Issuer\']'
          ],
          script: [
            classpath: [],
            sandbox: false,
            script: '''
            if (NETWORK.equals("besu")){
                return["default","letsencrypt"]
            }
            '''     
          ]
        ]   
    ],
  ])
])

pipeline {
  agent { 
    kubernetes {
      yaml '''
apiVersion: v1
kind: Pod
metadata: 
  name: jenkins-agent-pod
spec:
  serviceAccountName: jenkins-admin
  containers:
    - name: jnlp
      image: jenkins/inbound-agent:4.11.2-4
      command: ["sh","-x","/usr/local/bin/jenkins-agent"] 
    - name: ansible
      image: ghcr.io/hyperledger/bevel-build:jdk8-0.15.0.0
      command: ["sleep","10800"]
'''
    }
  }
  environment {
    JAVA_VERSION = "11"
    DOCKER_URL="ghcr.io/hyperledger"
    K8SCONTEXT="arn:aws:eks:eu-west-1:895052373684:cluster/bevel-dev-cluster-CLUSTER"
    config_file="/home/jenkins/.kube/config"
    REGION="eu-west-1"
    VAULT_URL="http://vault.internal.dev.aws.blockchaincloudpoc-develop.com:20002"
    VAULT_PORT="20002"
    secret_path="secretsv2/"
    GIT_BRANCH="bes-mon"
    EMAIL="sai.kumar.bommakanti@accenture.com"
    PUBLIC_IPS='["52.51.240.218","34.255.126.99"]' //# List of all public IP addresses of each availability zone from all organizations in the same k8s cluster
    GITURL="https://github.com/saikumarbommakanti/bevel-3.git"
    GITREPO="github.com/saikumarbommakanti/bevel-3.git"
    KMSKEY="kms-key"                    // AWS encryption key. If present, it's used as the KMS key id for K8S storage class encryption.
    AZ="eu-west-1a"                       //# AWS availability zone
    BESU_NETWORK_FILE="bevel/platforms/hyperledger-besu/configuration/samples/network-besu.yaml"
    BESU_ADD_MEMBER_ORG_NETWORK_FILE="bevel/build/networkfiles-inprogress/besu/network-besu-new-memberorg.yaml"
    BESU_ADD_VALIDATOR_NODE_NETWORK_FILE="bevel/build/networkfiles-inprogress/besu/network-besu-new-validatornode.yaml"
    BESU_ADD_VALIDATOR_ORG_NETWORK_FILE="bevel/build/networkfiles-inprogress/besu/network-besu-new-validatororg.yaml"
    FABRIC_NETWORK_FILE="bevel/build/networkfiles-inprogress/fabric/fabric-network-inprogress-for-jenkins.yaml"
    FABRIC_ADD_NEW_ORG_NETWORK_FILE="bevel/build/networkfiles-inprogress/fabric/network-fabric-add-organization.yaml"
    FABRIC_ADD_ORDERER_ORG_NETWORK_FILE="bevel/build/networkfiles-inprogress/fabric/network-fabric-add-ordererorg.yaml"
    FABRIC_ADD_PEER_NETWORK_FILE="bevel/build/networkfiles-inprogress/fabric/network-fabric-add-peer.yaml"
    FABRIC_ADD_RAFT_ORDERER_NETWORK_FILE="bevel/build/networkfiles-inprogress/fabric/network-fabricv2-raft-add-orderer.yaml"
    FABRIC_REMOVE_ORG_NETWORK_FILE="bevel/build/networkfiles-inprogress/fabric/network-fabric-remove-organization.yaml"
    FABRIC_ADD_CHANNEL_NETWORK_FILE="bevel/build/networkfiles-inprogress/fabric/network-fabric-add-new-channel.yaml"
    QUORUM_NETWORK_FILE="bevel/build/networkfiles-inprogress/quorum/quorum-network-inprogress-for-jenkins.yaml"
    QUORUM_ADD_NODE_NETWORK_FILE="bevel/build/networkfiles-inprogress/quorum/network-quorum-newnode.yaml"
    CORDA_NETWORK_FILE="bevel/build/networkfiles-inprogress/corda/cordav2-network-inprogress-for-jenkins.yaml"
    CORDA_ENT_NETWORK_FILE="bevel/build/networkfiles-inprogress/corda-ent/cordaent-network-inprogress-for-jenkins.yaml"   
    CORDA_ENT_ADD_NOTARY_NETWORK_FILE="bevel/build/networkfiles-inprogress/corda-ent/network-addNotary.yaml"
    INDY_NETWORK_FILE="bevel/build/networkfiles-inprogress/indy/indy-network-inprogress-for-jenkins.yaml"
    INDY_ADD_ORG_NETWORK_FILE="bevel/build/networkfiles-inprogress/indy/network-indy-newnode-to-baf-network.yaml" 

  }
  stages {
    stage('Copy KUBECONFIG') {
      steps {
        container("ansible") {
          sh "echo 'copy kubeconfig'"
          withCredentials([usernamePassword(credentialsId: 'AWS_CRED', passwordVariable: 'AWSSECRET', usernameVariable: 'AWSACCESS'), usernamePassword(credentialsId: 'GITHUB_CRED', passwordVariable: 'GITHUB_PASS', usernameVariable: 'GITHUB_USER'), string(credentialsId: 'vault_root_token', variable: 'VAULT_TOKEN'), file(credentialsId: 'DEMO_KUBE_CONFIG', variable: 'KUBECONFIGFILE')]) {
                sh "mkdir -p /home/jenkins/.kube"
                sh "mkdir -p /home/jenkins/besu"
                sh "cat $KUBECONFIGFILE > /home/jenkins/.kube/config"
                sh "chmod 600 /home/jenkins/.kube/config"
                // Add your additional script here
                sh """
                  #!/bin/bash

                  # Specify the OpenJDK version
                  JAVA_VERSION="11"

                  # Specify the download URL for OpenJDK 11 (adjust as needed)
                  DOWNLOAD_URL="https://download.java.net/java/GA/jdk11/9/GPL/openjdk-11.0.9_linux-x64_bin.tar.gz"

                  # Specify the installation directory
                  INSTALL_DIR="/opt/openjdk-$JAVA_VERSION"

                  # Download and extract OpenJDK
                  echo "Downloading and installing OpenJDK $JAVA_VERSION..."
                  mkdir -p "$INSTALL_DIR"
                  curl -L "$DOWNLOAD_URL" -o openjdk.tar.gz
                  tar -xf openjdk.tar.gz -C "$INSTALL_DIR" --strip-components=1
                  rm openjdk.tar.gz

                  # Set JAVA_HOME and update the PATH
                  export JAVA_HOME="$INSTALL_DIR"
                  export PATH="$JAVA_HOME/bin:$PATH"

                  # Display Java version
                  echo "Java installed successfully!"
                  java -version

                  # Display JAVA_HOME
                  echo "JAVA_HOME is set to: $JAVA_HOME"
                """
          }
        }
      }
    }
    stage('Prepare Network files') {
      steps {
        script {
          container("ansible") {
            sh "echo 'Prepare Network files...'"
            withCredentials([usernamePassword(credentialsId: 'GITHUB_CRED', passwordVariable: 'GITHUB_PASS', usernameVariable: 'GITHUB_USER')]) {
                sh "git clone --branch $GIT_BRANCH https://$GITHUB_USER:$GITHUB_PASS@$GITREPO"
                sh "mkdir -p bevel/build"
                sh "cp -rp bevel-3/platforms/hyperledger-besu/configuration/samples/network-besu.yaml bevel/build/network-besu.yaml"
            }
            if ( params.NETWORK == "besu" ) {
              withCredentials([usernamePassword(credentialsId: 'AWS_CRED', passwordVariable: 'AWSSECRET', usernameVariable: 'AWSACCESS'), usernamePassword(credentialsId: 'GITHUB_CRED', passwordVariable: 'GITHUB_PASS', usernameVariable: 'GITHUB_USER'), string(credentialsId: 'vault_root_token', variable: 'VAULT_TOKEN'), file(credentialsId: 'DEMO_KUBE_CONFIG', variable: 'KUBECONFIGFILE')]) {
                sh """
                  sed -i  "s|docker_username|$GITHUB_USER|g" bevel/build/network-besu.yaml
                  sed -i  "s|docker_password|$GITHUB_PASS|g" bevel/build/network-besu.yaml 
                  sed -i  "s|aws_region|$REGION|g" bevel/build/network-besu.yaml 
                  sed -i  "s|cluster_context|$K8SCONTEXT|g" bevel/build/network-besu.yaml
                  sed -i  "s|cluster_config|$config_file|g" bevel/build/network-besu.yaml
                  sed -i  "s|vault_addr|$VAULT_URL|g" bevel/build/network-besu.yaml
                  sed -i  "s|secret_path|$secret_path|g" bevel/build/network-besu.yaml 
                  sed -i  "s|vault_root_token|$VAULT_TOKEN|g" bevel/build/network-besu.yaml
                  sed -i -E \"s/(\\s*)branch: \\\"develop\\\"/\\1branch: \\\"$GIT_BRANCH\\\"/\" bevel/build/network-besu.yaml
                  sed -i  "s|https://github.com/<username>/bevel.git|$GITURL|g" bevel/build/network-besu.yaml 
                  sed -i  "s|github.com/<username>/bevel.git|$GITREPO|g" bevel/build/network-besu.yaml 
                  sed -i  "s|git_username|$GITHUB_USER|g" bevel/build/network-besu.yaml
                  sed -i  "s|git_access_token|$GITHUB_PASS|g" bevel/build/network-besu.yaml
                  sed -i  "s|git@email.com|$EMAIL|g" bevel/build/network-besu.yaml 
                  sed -i  "s|aws_access_key|$AWSACCESS|g" bevel/build/network-besu.yaml
                  sed -i  "s|aws_secret_key|$AWSSECRET|g" bevel/build/network-besu.yaml
                  sed -i  "s|EXTERNAL_URL_SUFFIX|$EXTERNALURLSUFFIX|g" bevel/build/network-besu.yaml
                  cat bevel/build/network-besu.yaml
                """             
              }   
            } 
          }
        }
      }
    }
    stage('Take necessary action') {
      steps {
        script {
          container("ansible") {
            if ( params.NETWORK == "besu" && params.ACTION == "deploy" ) {
                sh "ansible-playbook bevel-3/platforms/shared/configuration/site.yaml -e @bevel/build/network-besu.yaml"
            } else if ( params.NETWORK == "besu" && params.ACTION == "reset" ) {
                sh "ansible-playbook bevel-3/platforms/shared/configuration/site.yaml -e @bevel/build/network-besu.yaml -e 'reset=true' "
            } else if ( params.NETWORK == "besu" && params.ACTION == "addmemberorg" ) {
                sh "ansible-playbook bevel/platforms/shared/configuration/add-new-organization.yaml - @${env.BESU_ADD_MEMBER_ORG_NETWORK_FILE}"
            } else if ( params.NETWORK == "besu" && params.ACTION == "addvalidatornode" ) {
                sh "ansible-playbook bevel/platforms/hyperledger-besu/configuration/add-validator.yaml -e @${env.BESU_ADD_VALIDATOR_NODE_NETWORK_FILE}"
            } else if ( params.NETWORK == "besu" && params.ACTION == "addvalidatororg" ) {
                sh "ansible-playbook bevel/platforms/hyperledger-besu/configuration/add-validator.yaml -e @${env.BESU_ADD_VALIDATOR_ORG_NETWORK_FILE} -e 'add_new_org=true'"
            } else if  ( params.NETWORK == "fabric" && params.ACTION == "deploy" ) {
                sh "ansible-playbook bevel/platforms/shared/configuration/site.yaml -e @${env.FABRIC_NETWORK_FILE}"
            } else if ( params.NETWORK == "fabric" && params.ACTION == "reset" ) {
                sh "ansible-playbook bevel/platforms/shared/configuration/site.yaml -e @${env.FABRIC_NETWORK_FILE} -e 'reset=true' "
            } else if ( params.NETWORK == "fabric" && params.ACTION == "addneworg" ) {
                sh "ansible-playbook bevel/platforms/shared/configuration/add-new-organization.yaml - @${env.FABRIC_ADD_NEW_ORG_NETWORK_FILE}"
            } else if ( params.NETWORK == "fabric" && params.ACTION == "addordererorg" ) {
                sh "ansible-playbook bevel/platforms/hyperledger-fabric/configuration/add-orderer-organization.yaml -e @${env.FABRIC_ADD_ORDERER_ORG_NETWORK_FILE}"
            } else if ( params.NETWORK == "fabric" && params.ACTION == "addchannel" ) {
                sh "ansible-playbook bevel/platforms/hyperledger-fabric/configuration/add-new-channel.yaml -e @${env.FABRIC_ADD_CHANNEL_NETWORK_FILE}"
            } else if ( params.NETWORK == "fabric" && params.ACTION == "removeorg" ) {
                sh "ansible-playbook bevel/platforms/hyperledger-fabric/configuration/remove-organization.yaml -e @${env.FABRIC_REMOVE_ORG_NETWORK_FILE}"
            } else if ( params.NETWORK == "fabric" && params.ACTION == "addpeer" ) {
                sh "ansible-playbook bevel/platforms/hyperledger-fabric/configuration/add-peer.yaml -e @${env.FABRIC_ADD_PEER_NETWORK_FILE}"
            } else if ( params.NETWORK == "fabric" && params.ACTION == "addraftorderer" ) {
                sh "ansible-playbook bevel/platforms/hyperledger-fabric/configuration/add-orderer.yaml -e @${env.FABRIC_ADD_RAFT_ORDERER_NETWORK_FILE}"
            } else if  ( params.NETWORK == "quorum" && params.ACTION == "deploy" ) {
                sh "ansible-playbook bevel/platforms/shared/configuration/site.yaml -e @${env.QUORUM_NETWORK_FILE}"
            } else if  ( params.NETWORK == "quorum" && params.ACTION == "reset" ) {
                sh "ansible-playbook bevel/platforms/shared/configuration/site.yaml -e @${env.QUORUM_NETWORK_FILE} -e 'reset=true' "
            } else if  ( params.NETWORK == "quorum" && params.ACTION == "addnode" ) {
                sh "ansible-playbook bevel/platforms/shared/configuration/site.yaml -e @${env.QUORUM_ADD_NODE_NETWORK_FILE}"
            } else if  ( params.NETWORK == "r3-corda" && params.ACTION == "deploy" ) {
                sh "ansible-playbook bevel/platforms/shared/configuration/site.yaml -e @${env.CORDA_NETWORK_FILE}"
            } else if  ( params.NETWORK == "r3-corda" && params.ACTION == "reset" ) {
                sh "ansible-playbook bevel/platforms/shared/configuration/site.yaml -e @${env.CORDA_NETWORK_FILE} -e 'reset=true' "
            } else if  ( params.NETWORK == "r3-corda-ent" && params.ACTION == "deploy" ) {
                sh "ansible-playbook bevel/platforms/shared/configuration/site.yaml -e @${env.CORDA_ENT_NETWORK_FILE}"
            } else if  ( params.NETWORK == "r3-corda-ent" && params.ACTION == "reset" ) {
                sh "ansible-playbook bevel/platforms/shared/configuration/site.yaml -e @${env.CORDA_ENT_NETWORK_FILE} -e 'reset=true' "
            } else if  ( params.NETWORK == "r3-corda-ent" && params.ACTION == "addorg" ) {
                sh "ansible-playbook bevel/platforms/shared/configuration/add-new-organization.yaml -e @${env.CORDA_ENT_ADD_NOTARY_NETWORK_FILE}"
            } else if  ( params.NETWORK == "r3-corda-ent" && params.ACTION == "addnotaryorg" ) {
                sh "ansible-playbook bevel/platforms/r3-corda-ent/configuration/add-notaries.yaml -e @${env.CORDA_ENT_ADD_NOTARY_NETWORK_FILE}"
            } else if  ( params.NETWORK == "indy" && params.ACTION == "deploy" ) {
                sh "ansible-playbook bevel/platforms/shared/configuration/site.yaml -e @${env.INDY_NETWORK_FILE}"
            } else if  ( params.NETWORK == "indy" && params.ACTION == "reset" ) {
                sh "ansible-playbook bevel/platforms/shared/configuration/site.yaml -e @${env.INDY_NETWORK_FILE} -e 'reset=true' "
            } else if  ( params.NETWORK == "indy" && params.ACTION == "addorg" ) {
                sh "ansible-playbook bevel/platforms/shared/configuration/add-new-organization.yaml -e @${env.INDY_ADD_ORG_NETWORK_FILE} -e 'add_new_org_network_trustee_present=false' -e 'add_new_org_new_nyms_on_ledger_present=true' "
            }
          }
        }
      }
    }
  }
}

