
!/bin/bash
##https://killercoda.com/playgrounds/scenario/kubernetes
echo "Creating Dockerfile..."

mkdir test1
cd test1
# Create the Dockerfile
cat << EOF >app.py
from flask import Flask, request, jsonify
from kubernetes import client, config
import os

app = Flask(__name__)

# Load the in-cluster Kubernetes configuration
config.load_incluster_config()

# Get the path to the CA certificate
ca_cert_path = "/var/run/secrets/kubernetes.io/serviceaccount/ca.crt"

# Check if the CA certificate file exists
if os.path.isfile(ca_cert_path):
    # Configure the Kubernetes API client with the CA certificate
    client.Configuration.ssl_ca_cert = ca_cert_path

# Create an instance of the Kubernetes API client
api_client = client.ApiClient()

@app.route("/mutate", methods=["POST"])
def mutate():
    admission_review = request.json
    admission_request = admission_review["request"]

    # Retrieve the original resource from the admission request
    resource = admission_request["object"]
    print(resources)
    # Add the label to the resource
    labels = resource.setdefault("metadata", {}).setdefault("labels", {})
    labels["animal"] = "dog"

    # Create the admission response with the modified resource
    admission_response = {
        "uid": admission_request["uid"],
        "allowed": True,
        "patch": None,
        "patchType": None,
        "auditAnnotations": {}
    }

    # Set the modified resource in the admission response
    admission_response["response"] = {"allowed": True, "patchType": "JSONPatch"}

    # Return the admission response as JSON
    return jsonify(admission_response)

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=8000)
EOF


cat <<EOF > Dockerfile
FROM python:3.9-slim

# Install required dependencies
RUN pip install flask kubernetes

# Copy the app.py file
COPY app.py /app.py

# Set the working directory
WORKDIR /

# Expose the necessary port
EXPOSE 8000

# Run the Flask application
CMD ["python", "/app.py"]
EOF


cat <<EOF > requirement.txt
Flask
kubernetes
os 
ssl
EOF

echo "pushing Dockerfile..."
docker build -t ttl.sh/mutate .
docker push ttl.sh/mutate

echo "deploying on kubernetes"
kubectl apply -f -<< EOF
apiVersion: apps/v1
kind: Deployment
metadata:
  name: webhook-app-deployment
spec:
  replicas: 1
  selector:
    matchLabels:
      app: webhook-app
  template:
    metadata:
      labels:
        app: webhook-app
    spec:
      containers:
        - name: webhook-app-container
          image: ttl.sh/mutate
          ports:
            - containerPort: 8000
---
apiVersion: v1
kind: Service
metadata:
  name: webhook-app-service
spec:
  selector:
    app: webhook-app
  ports:
    - protocol: TCP
      port: 8000
      targetPort: 8000
  type: ClusterIP
---
EOF


echo "Script execution paused."
sleep 4


kubectl apply -f -<< EOF
apiVersion: admissionregistration.k8s.io/v1
kind: MutatingWebhookConfiguration
metadata:
  name: webhook-app-mutating-webhook
webhooks:
  - name: webhook-app.example.com
    clientConfig:
      url:  https://192.168.1.3:8000/mutate
      caBundle: "LS0tLS1CRUdJTiBDRVJUSUZJQ0FURS0tLS0tCk1JSUMvakNDQWVhZ0F3SUJBZ0lCQURBTkJna3Foa2lHOXcwQkFRc0ZBREFWTVJNd0VRWURWUVFERXdwcmRXSmwKY201bGRHVnpNQjRYRFRJek1EVXlNREU1TVRBek1Gb1hEVE16TURVeE56RTVNVEF6TUZvd0ZURVRNQkVHQTFVRQpBeE1LYTNWaVpYSnVaWFJsY3pDQ0FTSXdEUVlKS29aSWh2Y05BUUVCQlFBRGdnRVBBRENDQVFvQ2dnRUJBTVF4CjUwTGhHR1BkU1NtR1FlaEx0MlUzbzNmSkVsUmRwNGMwNE42WnlPeUxENTM2ZWlLa2FOVTJEVUdycEMwemJaMTMKMGMyaXRaVWV1UmFpOGRoeVo0ckdsaG5naXV4OXpwRFFqVHlrYkJiZ210SXNGeVFZbHU1V0Y5c0l1NEhCMncxbAptUTJXYjBVa0xOMDRHOHEza3NrdUxVQTIrelFLNnJDd1FQTXltR0ZWekhVWE1TdTg1Ti9rbWtPOXU5MTBsbkhqClVSYkhWNG53S3FpYzRNTzkwK2krdnpMTWlQb0lCMHdMazMyV2FlNDROaGpZUi9pT09Ta2RwTHZRUnZibmFsdWwKMXNzbGhHWWw2Y1BMakJUOWpZUWV3NkNLZkZWSi9QRkRXR0VlR2tWOG11TExOSTNKQi9rWDdpL2VRcDhLb0NoVAp3L1IyWFY1elh1SENma1EyRm1zQ0F3RUFBYU5aTUZjd0RnWURWUjBQQVFIL0JBUURBZ0trTUE4R0ExVWRFd0VCCi93UUZNQU1CQWY4d0hRWURWUjBPQkJZRUZPcHg1MVJ2NlZDd0JuMWtFOXZSV0dKUm5sQ1hNQlVHQTFVZEVRUU8KTUF5Q0NtdDFZbVZ5Ym1WMFpYTXdEUVlKS29aSWh2Y05BUUVMQlFBRGdnRUJBQmY0U2JiVWZjeTdSclAvdUx3OQpUVWJOa1hZclY0RGRIc3EzdWdsNTVJcS8rOG5BS0RPWG9hWlpnQ3VMOVUyQ2M1d0NvU3BHWEkyOVJMSS9PdndpCktKSkdOcktCYUc2eGVOMkFGbGFMeEJuK3NxY0dPMGJGd3poTDBWdHBvMTJGd1BraUFIVE1EQzlPaDVoSGdmUWsKSTdWQU1uaEp0ak1zMkRuMVZwRlRrbnJEeFBRZGxWVnlFemJvTGR4bHhEbmNnSzFIWDBkOGMrZ1J1SGNnRjQ5aQpxdGM3M2pkOXlRb1FEenNTT0cva1crbUV4aFZ0TDFwNTdjRmYzdHFPRll1Q1lSeTVtSU5hVHYxRmF4QWNoay9MCllzMExkN0JaOENiTHA2dWNRbkNPbWZYWTRjL2E5TnIzYzVzKzNGZlNmM3dvcW5KeWlHNEdsRTlybFlyazZGU2EKQWlBPQotLS0tLUVORCBDRVJUSUZJQ0FURS0tLS0tCg=="
    rules:
      - operations: ["CREATE", "UPDATE"]
        apiGroups: [""]
        apiVersions: ["v1"]
        resources: ["pods"]
    admissionReviewVersions: ["v1", "v1beta1"]
    sideEffects: None
EOF
: '
* Running on all addresses (0.0.0.0)
 * Running on http://127.0.0.1:8000
 * Running on http://192.168.1.3:8000
Press CTRL+C to quit
192.168.0.0 - - [01/Jun/2023 05:31:05] code 400, message Bad request version ('À\x13À')
192.168.0.0 - - [01/Jun/2023 05:31:05] "\x16\x03\x01\x00ù\x01\x00\x00õ\x03\x03Q¸ÊÌ\x972CÞ£þv$c½c@\x92Q J\x1dQ=M&ðà\x8eà\x15c\x8b ùBä\x86{¼\x91JZ°,f¡ï|M4\x8b\x14S\x84Ç*vâ\x86ÆY\x94ööî\x00&À+À/À,À0Ì©Ì¨À\x09À\x13À" HTTPStatus.BAD_REQUEST -
192.168.0.0 - - [01/Jun/2023 05:33:09] code 400, message Bad request version ("ð:\x81\x02\x04\x13º\x8dE²ªlÝcD¬dy`5&Íå^ÃÖç'¦¨ú}\x00>\x13\x02\x13\x03\x13\x01À,À0\x00\x9fÌ©Ì¨ÌªÀ+À/\x00\x9eÀ$À(\x00kÀ#À'\x00gÀ")
192.168.0.0 - - [01/Jun/2023 05:33:09] "\x16\x03\x01\x02\x00\x01\x00\x01ü\x03\x03±tÝÈ\x09@Þ\x1c¼[Ë\x8c.\x9eG\x0e5\x19¥3A\x9drPïÄk9\x13gz( ð:\x81\x02\x04\x13º\x8dE²ªlÝcD¬dy`5&Íå^ÃÖç'¦¨ú}\x00>\x13\x02\x13\x03\x13\x01À,À0\x00\x9fÌ©Ì¨ÌªÀ+À/\x00\x9eÀ$À(\x00kÀ#À'\x00gÀ" HTTPStatus.BAD_REQUEST -
192.168.0.0 - - [01/Jun/2023 05:33:31] code 400, message Bad request version ("ÎR³\x83\x10ú\x01\x98X\x90dFÞiÌÛ6b<aæ¥Ì¨°S\x1búx\x8cû!\x00>\x13\x02\x13\x03\x13\x01À,À0\x00\x9fÌ©Ì¨ÌªÀ+À/\x00\x9eÀ$À(\x00kÀ#À'\x00gÀ")
192.168.0.0 - - [01/Jun/2023 05:33:31] "\x16\x03\x01\x02\x00\x01\x00\x01ü\x03\x03K"\x09ÞØ\x87¿Á\x9f\x03uG»f-~¡xå´\x1d/I#ÞÿóÔ\x07Â\x03` ÎR³\x83\x10ú\x01\x98X\x90dFÞiÌÛ6b<aæ¥Ì¨°S\x1búx\x8cû!\x00>\x13\x02\x13\x03\x13\x01À,À0\x00\x9fÌ©Ì¨ÌªÀ+À/\x00\x9eÀ$À(\x00kÀ#À'\x00gÀ" HTTPStatus.BAD_REQUEST -
192.168.0.0 - - [01/Jun/2023 05:33:59] code 400, message Bad request version ("\x07ä\x02\x19eÂ?î¤ñOÈþ\x18\x00>\x13\x02\x13\x03\x13\x01À,À0\x00\x9fÌ©Ì¨ÌªÀ+À/\x00\x9eÀ$À(\x00kÀ#À'\x00gÀ")
192.168.0.0 - - [01/Jun/2023 05:33:59] "\x16\x03\x01\x02\x00\x01\x00\x01ü\x03\x03jf \x89§Å\x7f\x19h\x8eb9I\x00hßûd;éËÎ\x810Óèj¸$_ê\x7f \x1e/\x0cÈí¾¹=\x13×¹`e\x17G\x13Ø\x1d\x07ä\x02\x19eÂ?î¤ñOÈþ\x18\x00>\x13\x02\x13\x03\x13\x01À,À0\x00\x9fÌ©Ì¨ÌªÀ+À/\x00\x9eÀ$À(\x00kÀ#À'\x00gÀ" HTTPStatus.BAD_REQUEST -
192.168.0.0 - - [01/Jun/2023 05:33:59] code 400, message Bad request version ("\x00>\x13\x02\x13\x03\x13\x01À,À0\x00\x9fÌ©Ì¨ÌªÀ+À/\x00\x9eÀ$À(\x00kÀ#À'\x00gÀ")
192.168.0.0 - - [01/Jun/2023 05:33:59] "\x16\x03\x01\x02\x00\x01\x00\x01ü\x03\x03ÖKCX'ªSÃ·£×Ú\x0f>é¹\x1d\x02\x9cNô\x01s:ïÏ\x94\x16\x84p\x09r \x1b\x7f\x06Ã\x06¯ãY6JÙyurÊ£³a\x84\x97\x0b\x1ax¿2\x80«oòuå\x1e\x00>\x13\x02\x13\x03\x13\x01À,À0\x00\x9fÌ©Ì¨ÌªÀ+À/\x00\x9eÀ$À(\x00kÀ#À'\x00gÀ" HTTPStatus.BAD_REQUEST -
192.168.0.0 - - [01/Jun/2023 05:33:59] code 400, message Bad request version ("\x14\x86'T\x9dè¸~Ë\x96Ôm#\x00>\x13\x02\x13\x03\x13\x01À,À0\x00\x9fÌ©Ì¨ÌªÀ+À/\x00\x9eÀ$À(\x00kÀ#À'\x00gÀ")
192.168.0.0 - - [01/Jun/2023 05:33:59] "\x16\x03\x01\x02\x00\x01\x00\x01ü\x03\x03'Åýò\x94\x17íòò\x85ÚØ7#´èäõ\x14î\x89òú\x83iÝ?R\x1aß\x0dÊ Ñ\x01&Ã\x02v\x1d¿\x1e\x19õ\x19%\x8dMuïU\x0b\x14\x86'T\x9dè¸~Ë\x96Ôm#\x00>\x13\x02\x13\x03\x13\x01À,À0\x00\x9fÌ©Ì¨ÌªÀ+À/\x00\x9eÀ$À(\x00kÀ#À'\x00gÀ" HTTPStatus.BAD_REQUEST -
''

                                
                                    
 

