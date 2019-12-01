output "vpc-id" {
  description = "The ID of the VPC"
  value       = "${aws_vpc.dos-vpc.id}"
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
