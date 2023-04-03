from kubernetes import client, config

config.load_kube_config()

api_instance = client.CoreV1Api()

pods = api_instance.list_pod_for_all_namespaces()

for pod in pods.items:
    print(pod.metadata.name)
