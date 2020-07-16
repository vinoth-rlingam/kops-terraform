#!/bin/bash
set -ex

TF_OUTPUT=$(cd .. && terraform output -json)
export REGION="$(echo ${TF_OUTPUT} region | jq -r)"
export KOPS_STATE_STORE="$(echo ${TF_OUTPUT} kops_s3_bucket | jq -r)"
export NAME="$(echo ${TF_OUTPUT} kubernetes_cluster_name | jq -r)"

ssh-keygen
kops create secret --name ${NAME} sshpublickey admin -i ~/.ssh/id_rsa.pub

kops create cluster \
  --name=${NAME} \
  --vpc="$(echo ${TF_OUTPUT} vpc_id)" \
  --node-count 1 \
  --zones=ap-southeast-2a,ap-southeast-2b \
  --subnets=$(echo ${TF_OUTPUT} public_subnet_ids | jq -r 'join(",")') \
  --node-size=t2.micro \
  --master-size=t3.small \
  --state=${KOPS_STATE_STORE} \
  --dns private \
  --master-count 1 \
  --networking calico

kops update cluster ${NAME} --yes
