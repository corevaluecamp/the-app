variable "instance-ami" {
  type = "list"
  default = [
    "ami-0e9e6ba6d3d38faa8",
    "ami-087855b6c8b59a9e4",
    "ami-0556a158653dad0ba"
  ]
  description = "List of AMIs"
}

variable "instance-type" {
  type = "list"
  default = [
    "t2.micro",
    "t2.medium",
    "t2.xlarge"
  ]
}

variable "userdata-path" {
  type    = "string"
  default = "userdata-templates"
}

variable "key-name" {}
variable "id-sg-bastion" {}
variable "id-sg-jenkins" {}
variable "id-sg-private" {}
variable "id-sg-metrics" {}
variable "subnet-pub-a-id" {}
variable "subnet-pub-b-id" {}
variable "subnet-priv-a-id" {}
variable "subnet-priv-b-id" {}
variable "jenkins_user" {
  description = "User name for Jenkins login"
}
variable "jenkins_pass" {
  description = "Password for Jenkins login"
}
variable "elsip" {}

variable "iam_role" {}
variable "id-sg-load" {}
variable "id-sg-mongodb" {}
variable "backend_s3_created_bucket_name" {}
variable "application_load_balancer_DNS" {}