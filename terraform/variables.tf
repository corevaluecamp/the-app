variable "aws-region" {
  default     = "eu-west-3"
  type        = "string"
  description = "AWS region"
}
# bucket name must contain "artifacts"
variable "s3_bucket_name" {
  description = "Name for backend artifacts s3 bucket(must contain 'artifacts')"
  type        = string
  default     = "artifacts-devops-school.bucket-bicycle."
}

variable "jenkins_user" {
  description = "User name for Jenkins login"
}
variable "jenkins_pass" {
  description = "Password for Jenkins login"
}
