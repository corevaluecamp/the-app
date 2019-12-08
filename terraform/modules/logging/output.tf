output "elasticsearch_ip" {
  value = aws_instance.ELSearch.private_ip
}
output "kibana_ip" {
  value = aws_instance.Kibana.private_ip
}
output "kibana_id" {
  value = aws_instance.Kibana.id
}