output "vpc-id" {
  description = "The ID of the VPC"
  value       = "${aws_vpc.dos-vpc.id}"
}
output "availability-zone-a" {
  value = "${data.aws_availability_zones.available.names[0]}"
}
output "availability-zone-b" {
  value = "${data.aws_availability_zones.available.names[1]}"
}
output "subnet-pub-a-id" {
  description = "The ID of public subnet in AZ-A"
  value       = "${aws_subnet.dos-subnet-public-a.id}"
}
output "subnet-pub-b-id" {
  description = "The ID of public subnet in AZ-A"
  value       = "${aws_subnet.dos-subnet-public-b.id}"
}
output "subnet-db-a-id" {
  description = "The ID of public subnet in AZ-A"
  value       = "${aws_subnet.dos-subnet-db-a.id}"
}
output "hosted-zone-domain" {
  description = "Domain provided by Route 53"
  value       = "${var.hz-domain}"
}
output "mongodb-server-domain" {
  description = "MongoDB domain"
  value       = join(".", ["${var.mongo-rec}", "${var.hz-domain}"])
}
output "mongodb-server-ip" {
  description = "MongoDB IP address"
  value       = "${var.mongo-server-ip}"
}
