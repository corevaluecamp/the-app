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
variable "subnet_id" {}
variable "id-sg-metrics" {}
variable "id-sg-monitoring-access" {}
