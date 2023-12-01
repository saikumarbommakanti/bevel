Jenkins Setup Guide
Follow these steps to set up Jenkins along with necessary plugins and credentials for a multi-branch pipeline:

1. Install Jenkins
Download and Extract Jenkins


# Download Jenkins Helm chart
helm pull jenkins/jenkins

# Extract Jenkins chart
tar -xzvf jenkins.tar.gz
Modify Storage Class in values.yaml
Edit the values.yaml file to set the storage class to awsstorageclass.

Upgrade Helm Chart

# custom-values.yaml

master:
  persistence:
    storageClass: "aws-storage-class"


# Upgrade and install Jenkins
helm upgrade --install myjenkins ./jenkins
2. Install Active Choices Plugin
Install the "Active Choices" plugin in Jenkins. This can be done through the Jenkins web interface.

3. Check for Kubernetes Plugin
Ensure that the Kubernetes plugin is installed in Jenkins. If not, install it through the Jenkins web interface.

Credentials Configuration
Configure the following credentials in Jenkins:



Credentials Configuration
Configure the following credentials in Jenkins:

1. GitHub Credentials

Type: Username with Password
2. Vault Credentials

Type: Secret Text
3. AWS Credentials

Type: Username with Password
4. Kubeconfig File

Type: Secret File

Add a Jenkinsfile to your repository with the filename as "Jenkinsfile". This file will contain your pipeline configuration.

Configure the pipeline to use choice parameters for deployment values:

Network
Consensus
Proxy
External URL Suffix
Transaction Manager
Action
Issuer

Adding the Kubernetes cloud to dynamically provision Jenkins agent pods.

The Jenkins Kubernetes plugin does not directly support creating service accounts as secrets. However, you can create a service account in the Kubernetes cluster and then create a secret in Jenkins that contains the service account token. This will allow you to use the service account to authenticate with the Kubernetes cluster from Jenkins.

To create a service account in the Kubernetes cluster, you can use the following command:

kubectl create sa <service-account-name>
To create a token for the service account, you can use the following command:

kubectl create secret generic <secret-name> --from-token=<service-account-name> --type=kubernetes.io/service-account-token

To create a secret in Jenkins that contains the service account token, you can follow these steps:

Go to Credentials > Secret Text.
Enter the following information:
ID: <secret-name>
Description: A description of the secret
Secret: The contents of the <secret-name> secret
The service account token will now be available as a Jenkins credential, and you can use it to authenticate with the Kubernetes cluster from Jenkins.

Here is an example of how to use the service account token to authenticate with the Kubernetes cluster from Jenkins:

Go to Manage Jenkins > Configure Clouds.
Click Add a new cloud.
Select Kubernetes and click Next.
Enter the following information:
Kubernetes URL: The URL of the Kubernetes cluster
Kubernetes server certificate key: The path to the Kubernetes server certificate key (optional)
Kubernetes Namespace: The namespace in which to run pods (optional)
Credentials: Select the <secret-name> secret
Click Test Connection.
If the connection is successful, click Save
