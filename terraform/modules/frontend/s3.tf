resource "aws_s3_bucket" "artifacts_bucket" {
  bucket = "${var.s3_bucket_name}"
  acl    = "private"

  versioning {
    enabled = true
  }
} 