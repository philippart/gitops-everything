# GitOps for Everything
Forked from [Combining Argo CD (GitOps), Crossplane (Control Plane), And KubeVela (OAM)](https://youtu.be/eEcgn_gU3SM)

This repo is showcasing: 
1. infrastructure, managed service and application deployment based on GitOps principles, and 
2. a split of responsibility between Dev and Platform teams.

# Changelog

## Done
- Remove Civo, Kuvela and Sealed-Secrets
- Upgrade Crossplane, AWS and Helm providers
- Script to update AWS credentials
- Add eksctl option for creating the control cluster
- Update composite resource definitions and compositions
  - Update repo URLs and resource path
  - Use EC2 t3a instances instead of t3 (avoid t4g arm64 architecture)
  - Change region to eu-central-1
  - Import and reference existing AWS managed resources
  - Add permission boundary to IAM roles
  - Require AWS account number in the Cluster XRD 
- Create 3 compositions for AWS EKS clusters
  - outside accounts with public subnets
  - inside accounts with intranet subnets
  - inside accounts with private subnets (default composition)
- Add readme files to various directories
- Add script to retrieve AWS inventory

## Todo
- Create managed resource manifest for NAT instance (private subnet -> intranet)
- Test the whole thing

# Dependencies
- Helm 3.7
- Microk8s 1.23 (control cluster)
- ArgoCD 2.21
- Crossplane 1.6
- AWS provider 0.22
- Helm provider 0.9
- AWS EKS 1.21
