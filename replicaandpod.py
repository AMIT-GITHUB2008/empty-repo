from kubernetes import client, config

# Load the Kubernetes configuration from the default location
config.load_kube_config()

# Create Kubernetes API clients
deployment_api = client.AppsV1Api()
pod_api = client.CoreV1Api()
rs_api = client.AppsV1Api()

# Define the namespace
namespace = "default"

# Get a list of all deployments in the namespace
deployments = deployment_api.list_namespaced_deployment(namespace=namespace)

# Iterate over the deployments and retrieve their match labels
for deployment in deployments.items:
    deployment_name = deployment.metadata.name
    match_labels = deployment.spec.selector.match_labels
    
    # Find the pods connected to the deployment using its matching label
    pods = pod_api.list_namespaced_pod(namespace=namespace, label_selector=",".join([f"{k}={v}" for k, v in match_labels.items()]))
    
    # Find the replica set connected to the deployment using its UID
    replica_set = rs_api.read_namespaced_replica_set(deployment.metadata.uid, namespace=namespace)
    replica_set_name = replica_set.metadata.name
    
    # Print the deployment, pod, and replica set names
    if pods.items:
        for pod in pods.items:
            pod_name = pod.metadata.name
            print(f"Deployment {deployment_name} is connected to Pod {pod_name} and ReplicaSet {replica_set_name}")
    else:
        print(f"No pods found for deployment {deployment_name}")
