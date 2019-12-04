region = "us-west-2"
variable "instance_type" {
  default = "t2.micro"
}
variable "my_ami" {
  default = "ami-04b762b4289fba92b"
}
variable "key" {
  default = "key"
}

# local machine IP-address for testing purposes
my_IP = "93.175.204.146/32"