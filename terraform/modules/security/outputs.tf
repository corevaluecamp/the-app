output "key-name" {
  description = "Key pair name"
  value       = "${var.key-name}"
}
output "id-sg-bastion" {
  description = "The ID of security group for remote connection to bastion host"
  value       = "${aws_security_group.dos-bastion-access.id}"
}
output "id-sg-private" {
  description = "The ID of security group that allows connection to private area hosts from bastion over SSH"
  value       = "${aws_security_group.dos-private-access.id}"
}
output "id-sg-mongodb" {
  description = "The ID of security group for MongoDB"
  value       = "${aws_security_group.dos-mongodb-connect.id}"
}

output "id-sg-metrics" {
  description = "The ID of security group for Node_Exporter metrics"
  value       = "${aws_security_group.dos-monitoring-access.id}"
}
output "id-sg-monitoring-access" {
  description = "The ID of security group for Monitoring instance"
  value       = "${aws_security_group.dos-monitoring-access.id}"
}
output "id-sg-jenkins" {
  description = "The ID of security group for Jenkins"
  value       = "${aws_security_group.dos-jenkins.id}"
}
output "id-sg-jenkins-ssh" {
  description = "The ID of security group for Jenkins publish over ssh"
  value       = "${aws_security_group.dos-jenkins-ssh.id}"
}
output "id-sg-backend" {
  description = "The ID of security group for backend"
  value       = "${aws_security_group.dos-backend.id}"
}
output "id-sg-kibana" {
  description = "The ID of security group for Kibana web UI"
  value       = "${aws_security_group.dos-kibana-connect.id}"
}
output "id-sg-es" {
  description = "The ID of security group for Elasticsearch and Filebeat"
  value       = "${aws_security_group.dos-es-connect.id}"
}
output "id-sg-redis" {
  description = "The ID of security group for Elasticsearch and Filebeat"
  value       = "${aws_security_group.dos-redis.id}"
}
