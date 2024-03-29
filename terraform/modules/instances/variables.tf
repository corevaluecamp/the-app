# FOR eu-west-3 ONLY!
# [0] - for Amazon Linux 2
# [1] - for Ubuntu 18.04
# [2] - for RHEL 8
variable "instance-ami" {
  type = "list"
  default = [
    "ami-0e9e6ba6d3d38faa8",
    "ami-087855b6c8b59a9e4",
    "ami-0556a158653dad0ba"
  ]
  description = "List of AMIs"
}
# for eu-west-3
# [0] - t.micro
# [1] - t.medium
# [2] - t.xlarge
variable "instance-type" {
  type = "list"
  default = [
    "t2.micro",
    "t2.medium",
    "t2.xlarge"
  ]
}
variable "name-tag" {
  type = "list"
  default = [
    "dos-bastion",
    "dos-mongodb",
    "dos-redis"
  ]
}
variable "name-prefix" {
  default = "launch-temlate"
}
variable "userdata-path" {
  type    = "string"
  default = "./userdata-templates/"
}
variable "mongodb-server-domain" {}
variable "redis-server-domain" {}
variable "key-name" {}
variable "id-sg-bastion" {}
variable "id-sg-private" {}
variable "id-sg-mongodb" {}
variable "id-sg-jenkins" {}
variable "id-sg-redis" {}
variable "dos-metrics-logging" {}
variable "subnet-pub-a-id" {}
variable "subnet-pub-b-id" {}
variable "subnet-priv-a-id" {}
variable "subnet-priv-b-id" {}
variable "subnet-db-a-id" {}
variable "subnet-db-b-id" {}
variable "filebeat-es-ip" {}
