# Setup compositions

## Retrieve the current AWS inventory

Login and run:
```
./get-aws-resources.sh
```
This will produce tmp.<resource_type>.yaml files for each resource type.

## Update the following files

| Filename                    | AWS resource ids            |
| --------------------------- | --------------------------- |
| existing-aws-resources.yaml | vpc-id, sg-id, subnet-id    |
| cluster-aws-private.yaml    | nat instance id             |

Note also that compositions:
- cluster-aws-private.yaml
- cluster-aws-intranet.yaml
make references to the vpc resource names in 
- existing-aws-resources.yaml

| Filename                    | Crossplane references                      |
| --------------------------- | ------------------------------------------ |
| cluster-aws-intranet.yaml   | vpc-nodepool, sg-intranet, subnet intranet |
| cluster-aws-private.yaml    | vpc-nodepool                               |

Finally, the AWS account number is passed as input in the cluster claim.
