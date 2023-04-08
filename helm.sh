#!/bin/bash

# Add Kubernetes Dashboard repo and install chart
helm repo add kubernetes-dashboard https://kubernetes.github.io/dashboard/
helm install my-release kubernetes-dashboard/kubernetes-dashboard

# Add NGINX Ingress Controller repo and install chart
helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx
helm install my-release ingress-nginx/ingress-nginx

# Add Prometheus repo and install chart
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm install my-release prometheus-community/prometheus

# Add Grafana repo and install chart
helm repo add grafana https://grafana.github.io/helm-charts
helm install my-release grafana/grafana

# Add Elasticsearch repo and install chart
helm repo add elastic https://helm.elastic.co
helm install my-release elastic/elasticsearch

# Add Fluentd repo and install chart
helm repo add fluent https://fluent.github.io/helm-charts
helm install my-release fluent/fluentd

# Add MySQL repo and install chart
helm repo add bitnami https://charts.bitnami.com/bitnami
helm install my-release bitnami/mysql

# Add Redis repo and install chart
helm repo add bitnami https://charts.bitnami.com/bitnami
helm install my-release bitnami/redis

# Add RabbitMQ repo and install chart
helm repo add bitnami https://charts.bitnami.com/bitnami
helm install my-release bitnami/rabbitmq

# Add Jenkins repo and install chart
helm repo add jenkins https://charts.jenkins.io
helm install my-release jenkins/jenkins
#!/bin/bash

# Add PostgreSQL repo and install chart
helm repo add bitnami https://charts.bitnami.com/bitnami
helm install my-release bitnami/postgresql

# Add Minio repo and install chart
helm repo add minio https://helm.min.io/
helm install my-release minio/minio

# Add Redis Exporter repo and install chart
helm repo add oliver006 https://oliver006.github.io/helm-charts
helm install my-release oliver006/redis-exporter

# Add Kafka repo and install chart
helm repo add confluentinc https://confluentinc.github.io/cp-helm-charts/
helm install my-release confluentinc/cp-kafka

# Add Jenkins X repo and install chart
helm repo add jenkins-x https://jenkins-x.github.io/jenkins-x-versions/
helm install my-release jenkins-x/jx

# Add Nexus repo and install chart
helm repo add sonatype https://sonatype.github.io/helm3-charts/
helm install my-release sonatype/nexus

# Add Elastic APM repo and install chart
helm repo add elastic https://helm.elastic.co
helm install my-release elastic/apm-server

# Add Argo CD repo and install chart
helm repo add argo https://argoproj.github.io/argo-helm
helm install my-release argo/argo-cd

# Add Keycloak repo and install chart
helm repo add codecentric https://codecentric.github.io/helm-charts
helm install my-release codecentric/keycloak

# Add Graylog repo and install chart
helm repo add graylog https://helm.graylog.org/
helm install my-release graylog/graylog
#!/bin/bash

# Add Kube State Metrics repo and install chart
helm repo add kube-state-metrics https://prometheus-community.github.io/helm-charts
helm install my-release kube-state-metrics kube-state-metrics/kube-state-metrics

# Add Vault repo and install chart
helm repo add hashicorp https://helm.releases.hashicorp.com
helm install my-release hashicorp/vault

# Add Traefik repo and install chart
helm repo add traefik https://helm.traefik.io/traefik
helm install my-release traefik traefik/traefik

# Add MongoDB repo and install chart
helm repo add bitnami https://charts.bitnami.com/bitnami
helm install my-release bitnami/mongodb

# Add Jenkinsfile Runner repo and install chart
helm repo add jenkins https://charts.jenkins.io
helm install my-release jenkins/jenkinsfile-runner

# Add Kiali repo and install chart
helm repo add kiali https://kiali.org/helm-charts
helm install my-release kiali kiali/kiali

# Add Istio repo and install chart
helm repo add istio https://istio.io/latest/
helm install my-release istio-base istio/istio-base
helm install my-release istiod istio/istiod

# Add Argo Workflows repo and install chart
helm repo add argo https://argoproj.github.io/argo-helm
helm install my-release argo/argo-workflows

# Add Cert-Manager repo and install chart
helm repo add jetstack https://charts.jetstack.io
helm install my-release jetstack/cert-manager

# Add Nginx Unit repo and install chart
helm repo add nginx-unit https://nginx.org/packages/helm/chart
helm install my-release nginx-unit nginx-unit/nginx-unit
