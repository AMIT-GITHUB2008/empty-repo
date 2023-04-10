from kubernetes import client, config

# Load the Kubernetes configuration from the default location
config.load_kube_config()

# Create Kubernetes API clients
deployment_api = client.AppsV1Api()
service_api = client.CoreV1Api()

# Define the namespace
namespace = "default"

# Get a list of all deployments in the namespace
deployments = deployment_api.list_namespaced_deployment(namespace=namespace)

# Iterate over the deployments and retrieve their match labels
for deployment in deployments.items:
    deployment_name = deployment.metadata.name
    match_labels = deployment.spec.selector.match_labels
    
    # Find the service connected to the deployment using its matching label
    service = service_api.list_namespaced_service(namespace=namespace, label_selector=",".join([f"{k}={v}" for k, v in match_labels.items()]))
    
    # Print the deployment and service names
    if service.items:
        service_name = service.items[0].metadata.name
        print(f"Deployment {deployment_name} is connected to Service {service_name}")
    else:
        print(f"No service found for deployment {deployment_name}")
