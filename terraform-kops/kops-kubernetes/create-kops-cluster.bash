#!/bin/bash
set -ex

TF_OUTPUT=$(cd .. && terraform output -json)
export REGION="$(echo ${TF_OUTPUT} region | jq -r)"
export KOPS_STATE_STORE="$(echo ${TF_OUTPUT} kops_s3_bucket | jq -r)"
export NAME="$(echo ${TF_OUTPUT} kubernetes_cluster_name | jq -r)"