resource "random_string" "random" {
  length = 8
}

resource "aws_s3_bucket" "artifacts_bucket" {
  bucket = "${var.s3_bucket_name}-${random_string.random.result}"
  acl    = "private"

  versioning {
    enabled = true
  }
}


