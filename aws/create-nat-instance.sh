#!/bin/bash
# Create a VPC NAT instance
set -eu

## Parse arguments
while getopts "hv:s:" opt; do
  case "${opt}" in
    h)
      echo "Usage: ${0##*/} -v <vpc-id> -s <subnet-id>"
      exit 0
      ;;
    v)
      AWS_VPC_ID=$OPTARG
      ;;
    s)
      AWS_INTRANET_SUBNET_ID=$OPTARG
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

[ -z $AWS_VPC_ID ] || echo "Missing argument: -v <vpc-id>"
[ -z $AWS_INTRANET_SUBNET_ID ] || echo "Missing argument: -s <subnet-id>"

## Create a security group for the NAT instance
aws ec2 create-security-group \
--vpc-id $AWS_VPC_ID \
--group-name nat-security-group \
--description 'NAT instance SG'
# need to catch the sg-id

## Create security group ingress rules
aws ec2 authorize-security-group-ingress \
--group-id $AWS_CUSTOM_SECURITY_GROUP_ID \
--ip-permissions '[{"IpProtocol": "tcp", "FromPort": 22, "ToPort": 22, "IpRanges": [{"CidrIp": "0.0.0.0/0", "Description": "Allow SSH"}]}]' &&
aws ec2 authorize-security-group-ingress \
--group-id $AWS_CUSTOM_SECURITY_GROUP_ID \
--ip-permissions '[{"IpProtocol": "tcp", "FromPort": 80, "ToPort": 80, "IpRanges": [{"CidrIp": "0.0.0.0/0", "Description": "Allow HTTP"}]}]'

## Get Amazon Linux 2 latest AMI ID
AWS_AMI_ID=$(aws ec2 describe-images \
--owners 'amazon' \
--filters 'Name=name,Values=amzn-ami-vpc-nat-2018.03.0.2021*-x86_64-ebs' 'Name=state,Values=available' \
--query 'sort_by(Images, &CreationDate)[-1].[ImageId]' \
--output 'text')

## Create a key-pair
aws ec2 create-key-pair \
--key-name myvpc-keypair \
--query 'KeyMaterial' \
--output text > myvpc-keypair.pem

## Create an EC2 instance in default VPC and the NAT instance security group
AWS_EC2_INSTANCE_ID=$(aws ec2 run-instances \
--image-id $AWS_AMI_ID \
--instance-type t4g.nano \
--key-name myvpc-keypair \
--monitoring "Enabled=false" \
--security-group-ids $AWS_NAT_SECURITY_GROUP_ID \
--subnet-id $AWS_INTRANET_SUBNET_ID \
--tag-specifications 'ResourceType=instance,Tags=[{Key=nat-instance,Value=intranet}]' \
--query 'Instances[0].InstanceId' \
--output text)

## Check if the instance is running
aws ec2 describe-instance-status \
--instance-ids $AWS_EC2_INSTANCE_ID --output text

## Get the public IP address of the instance
AWS_EC2_INSTANCE_PUBLIC_IP=$(aws ec2 describe-instances \
--query "Reservations[*].Instances[*].PublicIpAddress" \
--output=text) &&
echo $AWS_EC2_INSTANCE_PUBLIC_IP

## Try to connect to the instance
# chmod 400 myvpc-keypair.pem
# ssh -i myvpc-keypair.pem ec2-user@$AWS_EC2_INSTANCE_PUBLIC_IP
# exit
