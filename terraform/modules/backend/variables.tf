variable "region" {
  type    = string
  default = "us-east-1"
}

variable "instance_type" {
  type    = string
  default = "t2.micro"
}

variable "image_id" {
  type    = string
  default = "ami-0b69ea66ff7391e80"
}

variable "key" {
  type    = string
  default = "clivpc"
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
variable "my_sg" {
  default = []
}