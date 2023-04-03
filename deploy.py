from kubernetes import client, config

config.load_kube_config()

api_instance = client.AppsV1Api()

deployments = api_instance.list_deployment_for_all_namespaces()

for deployment in deployments.items:
    print(deployment.metadata.name)
