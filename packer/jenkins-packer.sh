#!/bin/bash
set -ex

ARTIFACT=`/usr/local/bin/packer build -machine-readable packerscript.json  |awk -F, '$0 ~/artifact,0,id/ {print $6}'`
AMI_ID=`echo $ARTIFACT | cut -d ':' -f2`
echo 'variable "API_INSTANCE_AMI" { default = "'${AMI_ID}'" }' > amivar.tf
aws s3 cp amivar.tf s3://node-aws-jenkins-terraform/amivar.tf