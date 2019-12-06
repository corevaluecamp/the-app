# CREATE VPC
resource "aws_vpc" "dos-vpc" {
  cidr_block           = "${var.vpc-cidr}"
  instance_tenancy     = "default"
  enable_dns_hostnames = true
  enable_dns_support   = true
  tags = {
    Name = "${var.vpc-name}"
  }
}
# CREATE SUBNETS
# List available availability zone names
data "aws_availability_zones" "available" {
  state = "available"
}
# subnets for availability zone eu-west-3a
resource "aws_subnet" "dos-subnet-public-a" {
  vpc_id                  = "${aws_vpc.dos-vpc.id}"
  cidr_block              = "${cidrsubnet(var.vpc-cidr, 8, 1)}"
  availability_zone       = "${data.aws_availability_zones.available.names[0]}"
  map_public_ip_on_launch = "true"
  tags = {
    Name = "${var.subnet-a-name[0]}"
  }
}
resource "aws_subnet" "dos-subnet-private-a" {
  vpc_id                  = "${aws_vpc.dos-vpc.id}"
  cidr_block              = "${cidrsubnet(var.vpc-cidr, 8, 2)}"
  availability_zone       = "${data.aws_availability_zones.available.names[0]}"
  map_public_ip_on_launch = "false"
  tags = {
    Name = "${var.subnet-a-name[1]}"
  }
}
resource "aws_subnet" "dos-subnet-db-a" {
  vpc_id                  = "${aws_vpc.dos-vpc.id}"
  cidr_block              = "${cidrsubnet(var.vpc-cidr, 8, 3)}"
  availability_zone       = "${data.aws_availability_zones.available.names[0]}"
  map_public_ip_on_launch = "false"
  tags = {
    Name = "${var.subnet-a-name[2]}"
  }
}
# subnets for availability zone eu-west-3b
resource "aws_subnet" "dos-subnet-public-b" {
  vpc_id                  = "${aws_vpc.dos-vpc.id}"
  cidr_block              = "${cidrsubnet(var.vpc-cidr, 8, 4)}"
  availability_zone       = "${data.aws_availability_zones.available.names[1]}"
  map_public_ip_on_launch = "true"
  tags = {
    Name = "${var.subnet-b-name[0]}"
  }
}
resource "aws_subnet" "dos-subnet-private-b" {
  vpc_id                  = "${aws_vpc.dos-vpc.id}"
  cidr_block              = "${cidrsubnet(var.vpc-cidr, 8, 5)}"
  availability_zone       = "${data.aws_availability_zones.available.names[1]}"
  map_public_ip_on_launch = "false"
  tags = {
    Name = "${var.subnet-b-name[1]}"
  }
}
resource "aws_subnet" "dos-subnet-db-b" {
  vpc_id                  = "${aws_vpc.dos-vpc.id}"
  cidr_block              = "${cidrsubnet(var.vpc-cidr, 8, 6)}"
  availability_zone       = "${data.aws_availability_zones.available.names[1]}"
  map_public_ip_on_launch = "false"
  tags = {
    Name = "${var.subnet-b-name[2]}"
  }
}
# CREATE GATEWAYS
# elastic IP allocation
resource "aws_eip" "dos-eip-nat" {
  tags = {
    Name = "${var.nat-eip}"
  }
}
# internet gateway
resource "aws_internet_gateway" "dos-igw" {
  vpc_id = "${aws_vpc.dos-vpc.id}"
  tags = {
    Name = "${var.igw-name}"
  }
}
# NAT gateway
resource "aws_nat_gateway" "dos-nat" {
  allocation_id = "${aws_eip.dos-eip-nat.id}"
  subnet_id     = "${aws_subnet.dos-subnet-public-a.id}"
  depends_on    = ["aws_internet_gateway.dos-igw"]
  tags = {
    Name = "${var.nat-name}"
  }
}
# CREATE ROUTING
# create route tables for public, private and database subnets
resource "aws_route_table" "dos-routetb-public" {
  vpc_id = "${aws_vpc.dos-vpc.id}"
  tags = {
    Name = "${var.routetb-name[0]}"
  }
}
resource "aws_route_table" "dos-routetb-private" {
  vpc_id = "${aws_vpc.dos-vpc.id}"
  tags = {
    Name = "${var.routetb-name[1]}"
  }
}
resource "aws_route_table" "dos-routetb-db" {
  vpc_id = "${aws_vpc.dos-vpc.id}"
  tags = {
    Name = "${var.routetb-name[2]}"
  }
}
# create routing rules for public and private subnets
resource "aws_route" "dos-public-route" {
  route_table_id         = "${aws_route_table.dos-routetb-public.id}"
  destination_cidr_block = "${var.all-ip}"
  gateway_id             = "${aws_internet_gateway.dos-igw.id}"
}
resource "aws_route" "dos-private-route" {
  route_table_id         = "${aws_route_table.dos-routetb-private.id}"
  destination_cidr_block = "${var.all-ip}"
  nat_gateway_id         = "${aws_nat_gateway.dos-nat.id}"
}
resource "aws_route" "dos-db-route" {
  route_table_id         = "${aws_route_table.dos-routetb-db.id}"
  destination_cidr_block = "${var.all-ip}"
  nat_gateway_id         = "${aws_nat_gateway.dos-nat.id}"
}
# associate route tables with subnets in AZ-A
resource "aws_route_table_association" "public-subnet-association" {
  subnet_id      = "${aws_subnet.dos-subnet-public-a.id}"
  route_table_id = "${aws_route_table.dos-routetb-public.id}"
}
resource "aws_route_table_association" "private-subnet-association" {
  subnet_id      = "${aws_subnet.dos-subnet-private-a.id}"
  route_table_id = "${aws_route_table.dos-routetb-private.id}"
}
resource "aws_route_table_association" "db-subnet-association" {
  subnet_id      = "${aws_subnet.dos-subnet-db-a.id}"
  route_table_id = "${aws_route_table.dos-routetb-db.id}"
}
# associate route tables with subnets in AZ-B
resource "aws_route_table_association" "public-subnet-association-b" {
  subnet_id      = "${aws_subnet.dos-subnet-public-b.id}"
  route_table_id = "${aws_route_table.dos-routetb-public.id}"
}
resource "aws_route_table_association" "private-subnet-association-b" {
  subnet_id      = "${aws_subnet.dos-subnet-private-b.id}"
  route_table_id = "${aws_route_table.dos-routetb-private.id}"
}
resource "aws_route_table_association" "db-subnet-association-b" {
  subnet_id      = "${aws_subnet.dos-subnet-db-b.id}"
  route_table_id = "${aws_route_table.dos-routetb-db.id}"
}
# VPC's main routing table fallback
resource "aws_main_route_table_association" "set-main-routetb" {
  vpc_id         = "${aws_vpc.dos-vpc.id}"
  route_table_id = "${aws_route_table.dos-routetb-public.id}"
}
# CREATE ROUTE 53
# create Route 53 hosted zone
resource "aws_route53_zone" "dos-private-hz" {
  name = "${var.hz-domain}"
  vpc {
    vpc_id = "${aws_vpc.dos-vpc.id}"
  }
  tags = {
    Name = "${var.hz-name}"
  }
}
# create Route 53 records set
resource "aws_route53_record" "dos-rec-set-mongo" {
  zone_id = "${aws_route53_zone.dos-private-hz.id}"
  name    = "${var.mongo-rec}"
  type    = "A"
  ttl     = "300"
  records = ["${var.mongo-server-ip}"]
}
