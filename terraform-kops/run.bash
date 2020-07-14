#!/bin/bash
set -ex

echo "Initializing terraform...."
export TF_VAR_stateBucketName=$2
export TF_VAR_stateBucketRegion=$1
export TF_VAR_region=$1
export TF_VAR_stateBucketKey=terraform.tfstate

echo $TF_VAR_stateBucketName "and" $TF_VAR_stateBucketKey "and" $TF_VAR_region

/usr/local/bin/terraform init -input=false -backend-config "bucket=$TF_VAR_stateBucketName" -backend-config "key=$TF_VAR_stateBucketKey" -backend-config "region=$TF_VAR_stateBucketRegion"

echo "Terraform plan...."
/usr/local/bin/terraform plan -out=tfplan -input=false

echo "Updating Stack...."
/usr/local/bin/terraform apply -input=false -auto-approve