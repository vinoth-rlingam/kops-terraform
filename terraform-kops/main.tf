# Creation of VPC to spin up K8 cluster using kops
module "vpc" {
    source = "./vpc"
}

# S3 bucket to maintain the kops cluster state
module "s3" {
    source = "./s3"
    kops_state_bucket_name = "${var.config["kops_state_bucket_name"]}"
    bucket_region = "${var.region}"
}

module "route53" {
    source = "./route53"
    vpc_id = "${module.vpc.vpc_id}"
}