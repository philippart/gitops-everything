# Setup a control cluster

The control cluster runs argocd and crossplane and will access both the gitops repo and AWS (via the AWS & helm provider).

To create a control cluster use one of the following options:

## with kind
```
kind create cluster --config=kind.yaml
```

## with k3s
```
k3d cluster create --config k3d.yaml
```

## with microk8s
```
sudo snap install microk8s --classic --channel=1.23
microk8s enable dns storage ingress
```
Then save the kubeconfig with this command:
```
microk8s config > ~/.kube/config
```

## with eksctl
Update eksctl.yaml with your AWS details and then run
```
eksctl create cluster -f eksctl.yaml --auto-kubeconfig
or
eksctl create cluster --config-file=eksctl.yaml --auto-kubeconfig

```
This will create a new kubeconfig file with the cluster name under ~/.kube/eksctl/clusters.
