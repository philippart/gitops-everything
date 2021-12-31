#!/bin/bash
# Update aws-creds.yaml and apply to cluster
set -eu

AWS_PROFILE=myprofile

cat > creds.conf << EOF
[$AWS_PROFILE]
aws_access_key_id = $(aws configure get aws_access_key_id --profile $AWS_PROFILE)
aws_secret_access_key = $(aws configure get aws_secret_access_key --profile $AWS_PROFILE)
EOF

CREDS=$(base64 -w0 creds.conf)

cat > aws-creds.yaml << EOF
apiVersion: v1
kind: Secret
metadata:
  name: aws-creds
  namespace: crossplane-system
type: Opaque
data:
  creds: $CREDS
EOF

# CREATE OR UPDATE WITH
# kubectl apply -f aws-creds.yaml
# kubectl create secret generic aws-creds --save-config --dry-run=client --from-file=creds=./creds.conf -o yaml | kubectl apply -f - 
