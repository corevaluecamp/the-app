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
variable "key-name" {}
variable "subnet-pub-a-id" {}
variable "subnet-pub-b-id" {}
variable "subnet-priv-a-id" {}
variable "subnet-priv-b-id" {}