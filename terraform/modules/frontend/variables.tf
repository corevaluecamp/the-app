variable "region" {
  default = "eu-west-3"
} 

variable "instance_type" {
  default = "t2.micro"
}

variable "image_id" {
  default = "ami-0c5204531f799e0c6" //oregon x86
}

variable "s3_bucket_name" {
  default = ""
}
#artifacts-devops-school.bucket-bicycle
variable "my_vpc" {
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
variable "mongo_ip" {
  default = ""
}
variable "es_ip" {
  default = ""
}