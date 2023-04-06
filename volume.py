from kubernetes import client, config

# Load the Kubernetes configuration
config.load_kube_config()

# Create a Kubernetes API client
api_client = client.AppsV1Api()

# Define the Deployment name and namespace
deployment_name = "my-deployment"
namespace = "my-namespace"

# Retrieve the Deployment object
deployment = api_client.read_namespaced_deployment(name=deployment_name, namespace=namespace)

# Extract the volume names from the Deployment spec
volumes = deployment.spec.template.spec.volumes
volume_names = [v.name for v in volumes]

# Print the results
print(f"Volumes attached to Deployment {deployment_name} in namespace {namespace}:")
print(volume_names)
