#!/bin/bash
# retrieve the following AWS resources with AWS CLI
for element in vpcs security-groups subnets route-tables
do
  [ -f tmp.$element.yaml ] || aws ec2 describe-$element > tmp.$element.yaml
done
