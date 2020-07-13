#!/bin/bash

terraform -v

echo "Initializing terraform...."
export TF_VAR_stateBucketName=$2
export TF_VAR_stateBucketRegion=$1
export TF_VAR_region=$1
export TF_VAR_stateBucketKey=terraform.tfstate


echo $TF_VAR_stateBucketName "and" $TF_VAR_stateBucketKey "and" $TF_VAR_region

terraform init -input=false -backend-config "bucket=$TF_VAR_stateBucketName" -backend-config "key=$TF_VAR_stateBucketKey" -backend-config "region=$TF_VAR_stateBucketRegion"
terraform get
echo "Terraform plan...."
terraform plan -out=tfplan -input=false

echo "Updating Stack...."
terraform apply -input=false -auto-approve