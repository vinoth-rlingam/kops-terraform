#!/bin/bash
set -ex

TF_OUTPUT=$(cd .. && terraform output -json)
REGION="$(echo ${TF_OUTPUT} region | jq -r)"
 KOPS_STATE_STORE="$(echo ${TF_OUTPUT} kops_s3_bucket | jq -r)"
 NAME="$(echo ${TF_OUTPUT} kubernetes_cluster_name | jq -r)"
export $REGION
export $KOPS_STATE_STORE
export $NAME