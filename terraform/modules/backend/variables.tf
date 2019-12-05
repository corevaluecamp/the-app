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
variable "my_public_subnet" {
  default = ""
}
variable "my_private_subnet" {
  default = ""
}
/*  variable "my_sg" {
  default = ["${aws_security_group.my_sg.id}]"]
}  */
variable "mongo_ip" {
  default = ""
}
variable "es_ip" {
  default = "127.0.0.1"
}
variable "force_des" {
  default = ""
}