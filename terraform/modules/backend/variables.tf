variable "region" {
  type    = string
  default = ""
}

variable "instance_type" {
  type    = string
  default = "t2.micro"
}

variable "image_id" {
  type    = string
  default = "ami-0e9e6ba6d3d38faa8"
}

variable "key" {
  type    = string
  default = ""
}

variable "s3_bucket_name" {
  type    = string
  default = ""
}
#artifacts-devops-school.bucket-bicycle
variable "my_vpc" {
  type    = string
  default = ""
}

/*  variable "my_sg" {
  default = ["${aws_security_group.my_sg.id}]"]
}  */
variable "mongo_ip" {}
variable "es_ip" {}
variable "redis_ip" {}

variable "s3force" {}

variable "id-sg-bastion" {}
variable "id-sg-backend" {}
variable "id-sg-private" {}
variable "id-sg-mongodb" {}
variable "id-sg-jenkins" {}
variable "id-sg-redis" {}
variable "dos-metrics-logging" {}
# variable "id-sg-monitoring-access" {}
# variable "id-sg-metrics" {}
# variable "id-sg-es" {}
# variable "id-sg-monitoring-access" {}
# variable "id-sg-metrics" {}
variable "id-sg-load" {}
variable "subnet-priv-a-id" {}
variable "subnet-priv-b-id" {}
variable "subnet-pub-a-id" {}
variable "subnet-pub-b-id" {}

variable "kibana_id" {}
variable "grafana_id" {}
variable "jenkins_asg_id" {}
