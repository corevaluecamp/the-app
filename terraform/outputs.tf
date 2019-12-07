output "availability-zone-a" {
  value = module.network.availability-zone-a
}
output "availability-zone-b" {
  value = module.network.availability-zone-b
}
output "hosted-zone-domain" {
  description = "Domain provided by Route 53"
  value       = module.network.hosted-zone-domain
}
output "mongodb-server-domain" {
  description = "MongoDB domain"
  value       = module.network.mongodb-server-domain
}
output "mongodb-server-ip" {
  description = "MongoDB IP address"
  value       = module.network.mongodb-server-ip
}
output "backend_s3_created_bucket_name" {
  description = "Name of s3 artifacts bucket"
  value       = "${var.s3_bucket_name}${module.backend.random}"
}
 output "elasticsearch_ip" {
  description = "Elasticsearch IP address"
  value = module.logging.elasticsearch_ip
}
output "kibana_ip" {
  description = "Kibana IP address"
  value = module.logging.kibana_ip
}