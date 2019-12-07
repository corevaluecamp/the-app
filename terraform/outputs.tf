output "availability-zone-a" {
  value = module.network.availability-zone-a
}
output "availability-zone-b" {
  value = module.network.availability-zone-b
}
output "mongodb-server-ip" {
  description = "MongoDB IP address"
  value       = module.network.mongodb-server-ip
}
output "mongodb-server-domain" {
  description = "MongoDB domain"
  value       = module.network.mongodb-server-domain
}
output "redis-server-ip" {
  description = "MongoDB IP address"
  value       = module.instances.redis-server-ip
}
output "redis-server-domain" {
  description = "MongoDB domain"
  value       = module.network.redis-server-domain
}
output "backend_s3_created_bucket_name" {
  description = "Name of s3 artifacts bucket"
  value       = "${var.s3_bucket_name}${module.backend.random}"
}
output "elasticsearch_ip" {
  description = "Elasticsearch IP address"
  value       = module.logging.elasticsearch_ip
}
output "kibana_ip" {
  description = "Kibana IP address"
  value       = module.logging.kibana_ip
}
