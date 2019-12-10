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
  value       = module.backend.backend_s3_created_bucket_name
}
output "application_load_balancer_DNS" {
  description = "DNS name of application load balancer"
  value       = module.backend.application_load_balancer_dns
}
output "elasticsearch_ip" {
  description = "Elasticsearch IP address"
  value       = module.logging.elasticsearch_ip
}
output "kibana_ip" {
  description = "Kibana IP address"
  value       = module.logging.kibana_ip
}
