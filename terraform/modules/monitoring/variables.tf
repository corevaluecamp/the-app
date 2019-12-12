variable "region" {
  default = "eu-west-3"
}
variable "instance_type" {
  default = "t2.micro"
}
variable "my_ami" {
  default = "ami-0e9e6ba6d3d38faa8"
}
variable "key-name" {}
# variable "id-sg-metrics" {}
variable "dos-metrics-logging" {}
variable "id-sg-private" {}
variable "backend_s3_created_bucket_name" {}
variable "subnet-priv-a-id" {}
variable "subnet-priv-b-id" {}
variable "elasticip" {}
variable "id-sg-load" {}
