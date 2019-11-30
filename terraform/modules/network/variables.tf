variable "vpc-name" {
  default     = "dos-vpc"
  type        = "string"
  description = "VPC name"
}
variable "vpc-cidr" {
  default     = "10.10.0.0/16"
  type        = "string"
  description = "VPC CIDR"
}
variable "subnet-a-name" {
  type = "list"
  default = [
    "dos-subnet-public-A",
    "dos-subnet-private-A",
    "dos-subnet-db-A"
  ]
}
variable "subnet-b-name" {
  type = "list"
  default = [
    "dos-subnet-public-B",
    "dos-subnet-private-B",
    "dos-subnet-db-B"
  ]
}
variable "nat-eip" {
  type    = "string"
  default = "dos-eip-nat"
}
variable "igw-name" {
  default     = "dos-IGW"
  type        = "string"
  description = "Internet gateway name"
}
variable "nat-name" {
  default     = "dos-NAT"
  type        = "string"
  description = "NAT gateway name"
}
variable "routetb-name" {
  type = "list"
  default = [
    "dos-public-route-table",
    "dos-private-route-table",
    "dos-db-route-table"
  ]
}
variable "all-ip" {
  default = "0.0.0.0/0"
}
