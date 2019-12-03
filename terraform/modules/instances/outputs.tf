output "mongo-server-ip" {
  description = "MongoDB server IP address"
  value       = "${aws_instance.dos-mongodb[0].private_ip}"
}
