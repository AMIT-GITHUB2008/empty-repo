from kubernetes import client, config

config.load_kube_config()

api_instance = client.CoreV1Api()
apps_api_instance = client.AppsV1Api()

deployment_name = "your-deployment-name"
namespace = "your-namespace"

# Get the deployment object
deployment = apps_api_instance.read_namespaced_deployment(deployment_name, namespace)

# Get the label selector for the deployment
label_selector = ",".join([f"{key}={value}" for key, value in deployment.spec.selector.match_labels.items()])

# Get the service object with the matching label selector
services = api_instance.list_namespaced_service(namespace, label_selector=label_selector)

for service in services.items:
    print(service.metadata.name)
