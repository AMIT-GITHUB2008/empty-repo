from kubernetes import client, config
from prettytable import PrettyTable

# Load Kubernetes configuration
config.load_kube_config()

# Create Kubernetes API client
api = client.CoreV1Api()

# Specify the namespace and deployment name
namespace = "default"
deployment_name = "my-deployment"

# Get the deployment object
deployment = api.read_namespaced_deployment(deployment_name, namespace)

# Get the labels of the deployment
deployment_labels = deployment.spec.selector.match_labels

# Find all pods with matching labels
pod_list = api.list_namespaced_pod(namespace, label_selector=','.join([f'{k}={v}' for k, v in deployment_labels.items()]))

# Create table for output
table = PrettyTable()
table.field_names = ["Pod Name", "IP Address", "Labels"]

# Add rows to the table
for pod in pod_list.items:
    labels = ','.join([f"{k}={v}" for k, v in pod.metadata.labels.items()])
    table.add_row([pod.metadata.name, pod.status.pod_ip, labels])

# Print the table
print(table)
