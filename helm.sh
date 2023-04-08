#!/bin/bash

# Add Kubernetes Dashboard repo and install chart
helm repo add kubernetes-dashboard https://kubernetes.github.io/dashboard/
helm install release-1 kubernetes-dashboard/kubernetes-dashboard

# Add NGINX Ingress Controller repo and install chart
helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx
helm install release-2 ingress-nginx/ingress-nginx

# Add Prometheus repo and install chart
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm install release-3 prometheus-community/prometheus

# Add Grafana repo and install chart
helm repo add grafana https://grafana.github.io/helm-charts
helm install release-4 grafana/grafana

# Add Elasticsearch repo and install chart
helm repo add elastic https://helm.elastic.co
helm install release-5 elastic/elasticsearch

# Add Fluentd repo and install chart
helm repo add fluent https://fluent.github.io/helm-charts
helm install release-6 fluent/fluentd

# Add MySQL repo and install chart
helm repo add bitnami https://charts.bitnami.com/bitnami
helm install release-7 bitnami/mysql

# Add Redis repo and install chart
helm repo add bitnami https://charts.bitnami.com/bitnami
helm install release-8 bitnami/redis

# Add RabbitMQ repo and install chart
helm repo add bitnami https://charts.bitnami.com/bitnami
helm install release-9 bitnami/rabbitmq

# Add Jenkins repo and install chart
helm repo add jenkins https://charts.jenkins.io
helm install release-10 jenkins/jenkins

# Add PostgreSQL repo and install chart
helm repo add bitnami https://charts.bitnami.com/bitnami
helm install release-11 bitnami/postgresql

# Add Minio repo and install chart
helm repo add minio https://helm.min.io/
helm install release-12 minio/minio

# Add Redis Exporter repo and install chart
helm repo add oliver006 https://oliver006.github.io/helm-charts
helm install release-13 oliver006/redis-exporter

# Add Kafka repo and install chart
helm repo add confluentinc https://confluentinc.github.io/cp-helm-charts/
helm install release-14 confluentinc/cp-kafka

# Add Jenkins X repo and install chart
helm repo add jenkins-x https://jenkins-x.github.io/jenkins-x-versions/
helm install release-15 jenkins-x/jx

# Add Nexus repo and install chart
helm repo add sonatype https://sonatype.github.io/helm3-charts/
helm install release-16 sonatype/nexus

# Add Elastic APM repo and install chart
helm repo add elastic https://helm.elastic.co
helm install release-17 elastic/apm-server

# Add Argo CD repo and install chart
helm repo add argo https://argoproj.github.io/argo-helm
helm install release-18 argo/argo-cd

# Add Keycloak repo and install chart
helm repo add codecentric https://codecentric.github.io/helm-charts
helm install
