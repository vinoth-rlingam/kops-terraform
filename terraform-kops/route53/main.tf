resource "aws_route53_zone" "private" {
  name = "vrcloudtech.in"

  vpc {
    vpc_id = "${var.vpc_id}"
  }
}