variable "aws-region" {
  default     = "eu-west-3"
  type        = "string"
  description = "AWS region"
}
variable "s3_bucket_name" {
  type    = string
  default = "artifacts-devops-school.bucket-bicycle"
}