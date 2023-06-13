#!/bin/bash

# Generate a private key
openssl genrsa -out webhook.key 2048

# Create a certificate signing request (CSR)
openssl req -new -key webhook.key -subj "/CN=pod-annotate-webhook.default.svc" -out webhook.csr

# Create a configuration file for the certificate
echo "subjectAltName = DNS:pod-annotate-webhook.default.svc" > webhook.ext

# Generate the certificate using the CSR and the configuration file
openssl x509 -req -in webhook.csr -signkey webhook.key -out webhook.crt -days 365 -extfile webhook.ext

# Encode the certificate and key in base64 format
CERT=$(base64 -w 0 < webhook.crt)
KEY=$(base64 -w 0 < webhook.key)

# Create the Secret YAML file
cat <<EOF > secret.yaml
apiVersion: v1
data:
  cert.pem: $CERT
  key.pem: $KEY
kind: Secret
metadata:
  name: pod-annotate-webhook-certs
EOF
kubectl apply -f secret.yaml

cat <<EOF > webhook.yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: pod-annotate-webhook
  labels:
    app: pod-annotate-webhook
spec:
  replicas: 1
  selector:
    matchLabels:
      app: pod-annotate-webhook
  template:
    metadata:
      labels:
        app: pod-annotate-webhook
    spec:
      containers:
        - name: pod-annotate-webhook
          image: quay.io/slok/kubewebhook-pod-annotate-example:latest
          imagePullPolicy: Always
          args:
            - -tls-cert-file=/etc/webhook/certs/cert.pem
            - -tls-key-file=/etc/webhook/certs/key.pem
          volumeMounts:
            - name: webhook-certs
              mountPath: /etc/webhook/certs
              readOnly: true
      volumes:
        - name: webhook-certs
          secret:
            secretName: pod-annotate-webhook-certs
---
apiVersion: v1
kind: Service
metadata:
  name: pod-annotate-webhook
  labels:
    app: pod-annotate-webhook
spec:
  ports:
    - port: 443
      targetPort: 8080
  selector:
    app: pod-annotate-webhook
EOF

kubectl apply -f webhook.yaml

cat <<EOF > mwebhook.yaml
apiVersion: admissionregistration.k8s.io/v1
kind: MutatingWebhookConfiguration
metadata:
  name: pod-annotate-webhook
  labels:
    app: pod-annotate-webhook
    kind: mutator
webhooks:
  - name: pod-annotate-webhook.slok.dev
    clientConfig:
      service:
        name: pod-annotate-webhook
        namespace: default
        path: "/mutate"
      caBundle: $CERT
    rules:
      - operations: ["CREATE"]
        apiGroups: [""]
        apiVersions: ["v1"]
        resources: ["pods"]
    sideEffects: None
    admissionReviewVersions: ["v1"]
EOF

kubectl apply -f mwebhook.yaml





Error creating: Internal error occurred: failed calling webhook "pod-annotate-webhook.slok.dev": received invalid webhook response: expected webhook response of admission.k8s.io/v1, Kind=AdmissionReview, got /, Kind=
