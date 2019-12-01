# FOR eu-west-3 ONLY
# [0] - for Amazon Linux
# [1] - for Ubuntu
variable "instance-ami" {
  type = "list"
  default = [
    "ami-0e9e6ba6d3d38faa8",
    "ami-087855b6c8b59a9e4"
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
variable "bastion-name" {
  type    = "string"
  default = "dos-bastion"
}
variable "mongodb-name" {
  type    = "string"
  default = "dos-mongodb"
}
variable "name-prefix" {
  default = "launch-temlate"
}
variable "key-name" {}
variable "id-sg-bastion" {}
variable "id-sg-private" {}
variable "id-sg-mongodb" {}
variable "subnet-pub-a-id" {}
variable "subnet-pub-b-id" {}
variable "subnet-db-a-id" {}
