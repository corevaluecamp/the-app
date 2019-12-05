region = "us-west-2"
variable "instance_type" {
  default = "t2.micro"
}
variable "my_ami" {
  default = "ami-04b762b4289fba92b"
}
variable "key-name" {}
variable "subnet_id" {}
variable "id-sg-metrics" {}
variable "id-sg-monitoring-access" {}
