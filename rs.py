# Find the replica set connected to the deployment using its generation
rs_list = rs_api.list_namespaced_replica_set(namespace=namespace, label_selector=",".join([f"{k}={v}" for k, v in match_labels.items()]))
for rs in rs_list.items:
    if rs.metadata.generation == deployment.status.observed_generation:
        replica_set_name = rs.metadata.name
        break
else:
    replica_set_name = None
