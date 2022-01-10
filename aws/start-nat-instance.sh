#!/bin/bash +x
# Stop the NAT instance
set -eu

## Parse arguments
while getopts ":hi:" opt; do
  case "${opt}" in
    h) echo "Usage: ${0##*/} -i <instance-id>>" ; exit 0 ;;
    i) AWS_EC2_INSTANCE_ID=$OPTARG ;;
    \?) echo "Invalid option: -${OPTARG}" ; exit 1 ;;
    :) echo "Invalid option: -$OPTARG requires an argument" ; exit 1 ;;
  esac
done
shift $((OPTIND -1))

[ -z $AWS_EC2_INSTANCE_ID ] || echo "Missing argument: -i <instance-id>"


## Stop the ec2 instance
aws ec2 stop-instances \
--instance-ids $AWS_EC2_INSTANCE_ID
