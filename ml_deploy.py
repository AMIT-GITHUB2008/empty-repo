from kubernetes import client, config
import json

# Load the Kubernetes configuration from the default location
config.load_kube_config()

# Create a Kubernetes API client
api = client.AppsV1Api()

# Get a list of all deployments in the current namespace
deployments = api.list_namespaced_deployment(namespace="default")

# Create an empty dictionary to store the deployment labels
deployment_labels = {}

# Iterate over the deployments and retrieve their labels
for deployment in deployments.items:
    deployment_name = deployment.metadata.name
    deployment_labels[deployment_name] = deployment.metadata.labels

# Output the deployment labels as JSON
print(json.dumps(deployment_labels))

