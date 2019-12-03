variable "vpc-name" {
  description = "VPC name"
  default     = "dos-vpc"
  type        = "string"
}
variable "vpc-cidr" {
  description = "VPC CIDR"
  default     = "10.10.0.0/16"
  type        = "string"
}

# [0] - for dos-subnet-public-A
# [1] - for dos-subnet-private-A
# [2] - for dos-subnet-db-A
variable "subnet-a-name" {
  description = "Subnet names in AZ-A"
  type        = "list"
  default = [
    "dos-subnet-public-A",
    "dos-subnet-private-A",
    "dos-subnet-db-A"
  ]
}
variable "subnet-b-name" {
  description = "Subnet names in AZ-B"
  type        = "list"
  default = [
    "dos-subnet-public-B",
    "dos-subnet-private-B",
    "dos-subnet-db-B"
  ]
}
variable "nat-eip" {
  description = "Elastic IP address"
  type        = "string"
  default     = "dos-eip-nat"
}
variable "igw-name" {
  description = "Internet gateway name"
  default     = "dos-IGW"
  type        = "string"
}
variable "nat-name" {
  description = "NAT gateway name"
  default     = "dos-NAT"
  type        = "string"
}
variable "routetb-name" {
  description = "Route table names list"
  type        = "list"
  default = [
    "dos-public-route-table",
    "dos-private-route-table",
    "dos-db-route-table"
  ]
}
variable "all-ip" {
  description = "All IP addresses allowed"
  type        = "string"
  default     = "0.0.0.0/0"
}
variable "hz-domain" {
  description = "Hosted zone domain name"
  type        = "string"
  default     = "dos.net"
}
variable "hz-name" {
  description = "Hosted zone name"
  type        = "string"
  default     = "dos-private-hz"
}
variable "mongo-rec" {
  description = "mongodb.dos.net"
  type        = "string"
  default     = "mongodb"
}
variable "mongo-server-ip" {}
