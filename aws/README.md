# Setup AWS

Using the cluster-aws-private composition assumes a NAT instance is already created.
In the future this may be included in the composition or added as a managed or composite resource.

## Create a NAT instance with AWS CLI

Login and run:
```
./create-nat-instance.sh
```
Note: this will also create a NAT instance security group.

## Start a NAT instance with AWS CLI
```
./start-nat-instance.sh
```

## Stop a NAT instance with AWS CLI
```
./stop-nat-instance.sh
```

## Terminate a NAT instance with AWS CLI
```
./terminate-nat-instance.sh
```
Note: this will also eliminate the NAT instance security group.
