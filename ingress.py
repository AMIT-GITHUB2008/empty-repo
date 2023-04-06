from kubernetes import client, config

# Load the Kubernetes configuration
config.load_kube_config()

# Create a Kubernetes API client
api_client = client.NetworkingV1beta1Api()

# Get the list of Ingress resources in the cluster
ingress_list = api_client.list_ingress_for_all_namespaces().items

# Iterate over each Ingress resource
for ingress in ingress_list:
    print(f"Ingress: {ingress.metadata.name}")
    
    # Iterate over each rule in the Ingress resource
    for rule in ingress.spec.rules:
        # Get the Service associated with the rule
        service_name = rule.http.paths[0].backend.service_name
        service_namespace = rule.http.paths[0].backend.service_namespace
        
        # Print the name of the Service
        print(f"Service: {service_name} (Namespace: {service_namespace})")
