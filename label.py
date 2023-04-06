from kubernetes import client, config

# Load the Kubernetes configuration
config.load_kube_config()

# Create a Kubernetes API client
api_client = client.AppsV1Api()

# Define the namespace to search for Deployments
namespace = "my-namespace"

# Retrieve all Deployments in the namespace
deployments = api_client.list_namespaced_deployment(namespace)

# Retrieve the labels for each Deployment and output them as a list and as a comma-separated string
labels_list = []
labels_string = ""
for deployment in deployments.items:
    labels = deployment.metadata.labels
    if labels:
        labels_list.append(labels)
        if labels_string:
            labels_string += ", "
        labels_string += ",".join([f"{k}={v}" for k, v in labels.items()])

# Print the results
print(f"Labels as list: {labels_list}")
print(f"Labels as string: {labels_string}")
