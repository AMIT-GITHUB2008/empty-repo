from kubernetes import client, config

# Load Kubernetes configuration
config.load_kube_config()

# Set namespace and deployment name
namespace = "your-namespace"
deployment_name = "your-deployment"

# Create Kubernetes API client
v1 = client.CoreV1Api()
apps_v1 = client.AppsV1Api()

# Get deployment object
deployment = apps_v1.read_namespaced_deployment(name=deployment_name, namespace=namespace)

# Get pod template from deployment object
pod_template = deployment.spec.template

# Get pod object from pod template
pod = client.V1Pod(
    api_version=pod_template.spec.api_version,
    kind=pod_template.kind,
    metadata=pod_template.metadata,
    spec=pod_template.spec,
)

# Get list of pods associated with deployment
pod_list = v1.list_namespaced_pod(namespace=namespace, label_selector=f"app={deployment_name}")

# Get list of replica sets associated with deployment
rs_list = apps_v1.list_namespaced_replica_set(namespace=namespace, label_selector=f"app={deployment_name}")

# Get service object associated with deployment
service_list = v1.list_namespaced_service(namespace=namespace, label_selector=f"app={deployment_name}")
if service_list.items:
    service = service_list.items[0]
else:
    service = None

# Get config map object associated with deployment
config_map_list = v1.list_namespaced_config_map(namespace=namespace, label_selector=f"app={deployment_name}")
if config_map_list.items:
    config_map = config_map_list.items[0]
else:
    config_map = None

# Get secret object associated with deployment
secret_list = v1.list_namespaced_secret(namespace=namespace, label_selector=f"app={deployment_name}")
if secret_list.items:
    secret = secret_list.items[0]
else:
    secret = None

# Get persistent volume object associated with deployment
pv_list = v1.list_persistent_volume()
pv_claim_map = {}
for claim in deployment.spec.template.spec.volumes:
    if claim.persistent_volume_claim:
        claim_name = claim.persistent_volume_claim.claim_name
        pv_claim_map[claim_name] = None
        for pv in pv_list.items:
            if pv.spec.claim_ref and pv.spec.claim_ref.name == claim_name:
                pv_claim_map[claim_name] = pv
                break
