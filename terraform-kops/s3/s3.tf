// S3 bucket to store kops state.
resource "aws_s3_bucket" "kops_state_bucket" {
  bucket        = "${var.kops_state_bucket_name}"
  acl           = "private"
  region = "${var.bucket_region}"
  force_destroy = true
  }

  output "kops_state_bucket_id" {
  value = "${aws_s3_bucket.kops_state_bucket.id}"
}