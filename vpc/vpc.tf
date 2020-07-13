# Importing the availability zones for the region
data "aws_availability_zones" "available" {}

# Creation of VPC
resource "aws_vpc" "k8_cluster_vpc" {
  cidr_block       = "10.0.0.0/16"
  instance_tenancy = "default"

  tags = {
    Name = "k8_cluster_vpc"
    Environment = "Testing"
  }
}

# Creation of internet gateway for the vpc
resource "aws_internet_gateway" "k8_cluster_gw" {
  vpc_id = "${aws_vpc.k8_cluster_vpc.id}"

  tags = {
    Name = "k8_cluster_ig"
  }
}

# Creation of public subnet for each availability zone
resource "aws_subnet" "k8_cluster_public_subnet" {
    vpc_id = "${aws_vpc.k8_cluster_vpc.id}"
    count = "${length(data.aws_availability_zones.available.names)}"
    cidr_block = "10.0.${10 + count.index}.0/24"
    availability_zone = "${data.aws_availability_zones.available.names[count.index]}"
    map_public_ip_on_launch = true
    tags = {
    Name = "publicSubnet"
  }
}

# Creation of private subnet for each availability zone
resource "aws_subnet" "k8_cluster_private_subnet" {
    vpc_id = "${aws_vpc.k8_cluster_vpc.id}"
    count = "${length(data.aws_availability_zones.available.names)}"
    cidr_block = "10.0.${20 + count.index}.0/24"
    availability_zone = "${data.aws_availability_zones.available.names[count.index]}"
    map_public_ip_on_launch = true
    tags = {
    Name = "privateSubnet"
  }
}

# Routing table for public subnets
resource "aws_route_table" "k8_cluster_rtblpublic" {
  vpc_id = "${aws_vpc.k8_cluster_vpc.id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.k8_cluster_gw.id}"
  }

  tags = {
    Name = "routeTablePublic"
  }
}

# Route table association with public subnets
resource "aws_route_table_association" "route" {
  count          = "${length(data.aws_availability_zones.available.names)}"
  subnet_id      = "${element(aws_subnet.k8_cluster_public_subnet.*.id, count.index)}"
  route_table_id = "${aws_route_table.k8_cluster_rtblpublic.id}"
}

# Elastic IP for NAT gateway
resource "aws_eip" "k8_cluster_nat" {
  vpc = true
}

# NAT Gateway
resource "aws_nat_gateway" "k8_cluster_natgateway" {
  allocation_id = "${aws_eip.k8_cluster_nat.id}"
  subnet_id     = "${element(aws_subnet.k8_cluster_private_subnet.*.id, 1)}"
  depends_on    = ["aws_internet_gateway.k8_cluster_gw"]
}

# Routing table for private subnets
resource "aws_route_table" "k8_cluster_rtblprivate" {
  vpc_id = "${aws_vpc.k8_cluster_vpc.id}"

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = "${aws_nat_gateway.k8_cluster_natgateway.id}"
  }

  tags = {
    Name = "routeTablePrivate"
  }
}

# Route table association with private subnets
resource "aws_route_table_association" "private_route" {
  count          = "${length(data.aws_availability_zones.available.names)}"
  subnet_id      = "${element(aws_subnet.k8_cluster_private_subnet.*.id, count.index)}"
  route_table_id = "${aws_route_table.k8_cluster_rtblprivate.id}"
}

output "vpc_id" {
  value = "${aws_vpc.k8_cluster_vpc.id}"
}

output "vpc_cidr_block" {
  value = "${aws_vpc.k8_cluster_vpc.cidr_block}"
}

output "public_subnet_ids" {
  value = "${aws_subnet.k8_cluster_private_subnet.*.id}"
}

output "private_subnet_ids" {
  value = "${aws_subnet.k8_cluster_public_subnet.*.id}"
}
output "public_route_table_ids" {
  value = "${aws_route_table.k8_cluster_rtblpublic.*.id}"
}

output "private_route_table_ids" {
  value = "${aws_route_table.k8_cluster_rtblprivate.*.id}"
}

output "nat_gateway_ids" {
  value = "${aws_nat_gateway.k8_cluster_natgateway.id}"
}
