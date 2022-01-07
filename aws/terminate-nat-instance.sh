#!/bin/bash
# Terminate the NAT instance
set -eu

## Parse arguments
while getopts "hi:g:" opt; do
  case "${opt}" in
    h)
      echo "Usage: ${0##*/} -i <instance-id> -g <security-group-id>"
      exit 0
      ;;
    i)
      AWS_EC2_INSTANCE_ID=$OPTARG
      ;;
    g)
      AWS_NAT_SECURITY_GROUP_ID=$OPTARG
      ;;
    \?)
      echo "Invalid option: -$OPTARG" >&2
      ;;
    :)
      echo "Invalid option: -$OPTARG requires an argument" >&2
      ;;
  esac
done
shift $((OPTIND -1))

[ -z $AWS_EC2_INSTANCE_ID ] || echo "Missing argument: -i <instance-id>"
[ -z $AWS_NAT_SECURITY_GROUP_ID ] || echo "Missing argument: -g <security-group-id>"


## Terminate the ec2 instance
aws ec2 terminate-instances \
--instance-ids $AWS_EC2_INSTANCE_ID

## Delete key pair
aws ec2 delete-key-pair \
--key-name myvpc-keypair &&
rm -f myvpc-keypair.pem

## Delete custom security group
aws ec2 delete-security-group \
--group-id $AWS_NAT_SECURITY_GROUP_ID
