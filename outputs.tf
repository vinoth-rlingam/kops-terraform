data "aws_region" "current" {}

output "region" {
  value = "${data.aws_region.current.name}"
}

output "vpc_id" {
  value = "${module.vpc.vpc_id}"
}

output "vpc_name" {
  value = "k8_cluster_vpc"
}

output "vpc_cidr_block" {
  value = "${module.vpc.vpc_cidr_block}"
}

// Public Subnets

output "public_subnet_ids" {
  value = ["${module.vpc.public_subnet_ids}"]
}

// Private Subnets

output "private_subnet_ids" {
  value = ["${module.vpc.private_subnet_ids}"]
}

output "public_route_table_ids" {
  value = ["${module.vpc.public_route_table_ids}"]
}

output "private_route_table_ids" {
  value = ["${module.vpc.private_route_table_ids}"]
}


output "nat_gateway_ids" {
  value = "${module.vpc.nat_gateway_ids}"
}

// Needed for kops

output "kops_s3_bucket" {
  value = "${module.s3.kops_state_bucket_id}"
}

output "kubernetes_cluster_name" {
  value = "${var.config["kubernetes_cluster_name"]}"
}