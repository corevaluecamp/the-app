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
