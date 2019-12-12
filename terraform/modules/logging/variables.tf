# FOR eu-west-3 ONLY!
# [0] - for Amazon Linux 2
# [1] - for Ubuntu 18.04
# [2] - for RHEL 8
variable "instance-ami" {
  description = "List of AMIs"
}
# for eu-west-3
# [0] - t.micro
# [1] - t.medium
# [2] - t.xlarge
variable "instance-type" {
  description = "List of instance types"
}
variable "key-name" {}
# variable "my_vpc" {}
variable "subnet-pub-a-id" {}
variable "subnet-pub-b-id" {}
variable "subnet-priv-a-id" {}
variable "subnet-priv-b-id" {}
variable "id-sg-es" {}
# variable "id-sg-kibana" {}
variable "id-sg-private" {}
variable "id-sg-jenkins" {}
variable "id-sg-bastion" {}
