#!/bin/bash
set -ex

cd packer
ARTIFACT_API=`packer build -machine-readable packer-ami-api.json  |awk -F, '$0 ~/artifact,0,id/ {print $6}'`
AMI_ID_API=`echo $ARTIFACT_API | cut -d ':' -f2`
echo 'variable "API_INSTANCE_AMI" { default = "'${AMI_ID_API}'" }' > amivar_API.tf
aws s3 cp amivar_API.tf s3://node-aws-jenkins-terraform/amivar_api.tf