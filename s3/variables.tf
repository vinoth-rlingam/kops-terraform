variable "kops_state_bucket_name"{
    description = "bucket name of the kops state store"
}

variable "bucket_region" {
  description = "The AWS Region the S3 bucket is deployed into"

  //example = "ap-southeast-2"
}