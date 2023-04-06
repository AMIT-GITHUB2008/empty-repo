from kubernetes import client, config
import yaml

# Load the Kubernetes configuration
config.load_kube_config()

# Create a Kubernetes API client
api_client = client.AppsV1Api()

# Define the Deployment name and namespace
deployment_name = "my-deployment"
namespace = "my-namespace"

# Get the Deployment YAML manifest
deployment = api_client.read_namespaced_deployment(name=deployment_name, namespace=namespace)
deployment_yaml = yaml.safe_load(api_client.api_client.sanitize_for_serialization(deployment))

# Get the ConfigMap, Secret, and Volume information
config_maps = set()
secrets = set()
volumes = deployment_yaml['spec']['template']['spec']['volumes']
for volume in volumes:
    if 'configMap' in volume:
        config_maps.add(volume['configMap']['name'])
    elif 'secret' in volume:
        secrets.add(volume['secret']['secretName'])

# Print the results
print(f"Deployment: {deployment_name} (Namespace: {namespace})")
print(f"ConfigMaps: {', '.join(config_maps)}")
print(f"Secrets: {', '.join(secrets)}")
