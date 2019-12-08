resource "random_string" "random" {
  length = 12
  special = false
  upper = false
}

resource "aws_s3_bucket" "artifacts_bucket" {
  bucket = "${var.s3_bucket_name}${random_string.random.result}"
  acl    = "private"
  force_destroy = "${var.s3force}"

  versioning {
    enabled = true
  }
}
